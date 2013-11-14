classdef SCwithCF < PDASM
    %SCHURPA implementation of PDASM
    properties
        %Cholesky factorization
        R;
    end
    
    methods
        function obj = SCwithCF(H, c, A, b, m, n)
            obj = obj@PDASM(H,c,A,b,m,n);
        end
        function [x2, fval, exitflag, output, lambda2, activeSet] = solve(obj, x, lambda, W)
            
            % ensure all vectors are column vectors
            x = x(:);
            lambda = lambda(:);
            W = W(:);
            
            % ensure proper dimensions
            checkDimensions(obj, x, lambda, W);
            
            % set the initial iterates
            if (isempty(W))
                W = prediction(obj, x, lambda);
            end
            %W = logical(zeros(length(lambda),1));
            % initial working set
            W0 = W;
            
            % output arguments
            exitflag = 0;
            obj.output = {};
            
            % Forming K = A*H^-1*A' and finding it's cholesky from the initial working set
            A0 = obj.constraintJacobian(W0,:);
            nActive0 = nnz(W0);
            b0 = obj.constraintRHS(W0);
            H_inverse = obj.Hessian^-1;
            n = obj.nVars;
            m = obj.nConstraints;
            c = - obj.linearObjective;
            lambda2 = zeros(m,1);
            if isempty(A0)
                x2 = H_inverse*c;
            else
                K = A0*H_inverse*A0';
                obj.R = chol(K);
                
                g = A0*H_inverse*c - b0;
                v = obj.CF_solve(g);
                lambda2(W0) = -v;
                x2 = H_inverse * ( c + A0' * -v );
            end
            % iterate
            for iterations = 1:PDASM.MAX_ITERS+1

                % stopping criteria
                if (iterations > 1)
                    if (Wold == W)
                        activeSet = W;
                        break;
                    end
                end

                % record last prediction
                Wold = W;

                % current prediction
                W = prediction(obj, x2(:), lambda2);
                
                % compute U from the change between W and Wold
                %updates = W ~= W0; % the updated indices are the ones that are different from the the initial set
                added = bsxfun(@and, W, ~W0); % the added active indices are the updated ones equal to 0 in the initial set
                removed = bsxfun(@and, ~W, W0); % the removed indices are the ones equal to 1 in the inital set and 0 in the update history
                A_add = obj.constraintJacobian(added, :);
                nAdded = nnz(added);
                b_add = obj.constraintRHS(added);

                A_remove = diag(removed);
                A_remove = A_remove(logical(removed),logical(W0));
                nRemoved = nnz(removed);
                b_remove = zeros(nRemoved,1);
                
                nUpdated = nAdded + nRemoved;

                A = [A0;...
                    A_add];
                
                A_new = [A0;...
                    A_add];
                
                nNew = nnz(added+W0);
               

                b = [b0; b_add];

                if ~isempty(A0)
                    if nUpdated ~= 0
                        u = [A_add*H_inverse*A_new' zeros(nAdded,nRemoved);...
                        A_remove zeros(nRemoved,nAdded) eye(nRemoved)]; 
                        v = [zeros(nUpdated,nActive0) eye(nUpdated)];
                        %using inverse multiplication to solve for now
                        A_inverse = blkdiag(obj.R^-1*(obj.R')^-1,(-A_add*H_inverse*A_add')^-1, -0.5*eye(nRemoved));
                        [X, G] = obj.update_svd(u,v,nUpdated);
                        update_inverse = A_inverse - A_inverse*X*(G^-1+X'*A_inverse*X)^-1*X'*A_inverse;
                        sol = -update_inverse(1:nNew,1:nNew)*(A*H_inverse*c - b);
                        lambda2(W0) = sol(1 : nActive0);
                        lambda2(added) = sol(nActive0+1 : end);
                        %lambda2(removed) = zeros(nRemoved,1);
                        x2 = H_inverse * (c + obj.constraintJacobian(W,:)' * lambda2(W));
                    else
                        g = A0*H_inverse*c - b0;
                        v = obj.CF_solve(g);
                        lambda2(W0) = -v;
                        x2 = H_inverse * ( c + A0' * -v );
                    end
                else
                    if ~isempty(A_add)
                        A_inverse = (-A_add*H_inverse*A_add')^-1;
                        lambda2(W) = A_inverse * (A*H_inverse*c -b);
                        x2 = H_inverse * (c + A' * lambda2(W));
                    else                
                        x2 = H_inverse*c;
                        lambda2 = zeros(m, 1);
                        break
                    end
                end
            end

            % set output
            fval = computeObjective(obj, x(:));
            if (iterations ~= PDASM.MAX_ITERS)
                exitflag = 1;
                activeSet = W;
            end
            obj.output.iters = iterations - 1; % last iteration doesn't count
            output = obj.output;
        end
    end
    methods
        function [X,G] = update_svd(obj,u,v,nUpdates)
            [U,S,~] = svd(v'*u + u'*v);
            G = S(1:nUpdates,1:nUpdates);
            X = U(:,1:nUpdates);
        end
    end
    methods (Access = protected)
        function r = CF_solve(obj, u)
            r = obj.R^-1*(obj.R')^-1*u;
        end

    end
end