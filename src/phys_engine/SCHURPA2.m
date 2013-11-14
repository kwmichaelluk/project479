classdef SCHURPA2 < PDASM
    %SCHURPA implementation of PDASM
    properties
        K0;
    end
    
    methods
        function obj = SCHURPA2(H, c, A, b, m, n)
            obj = obj@PDASM(H,c,A,b,m,n);
        end
        function [x2, fval, exitflag, output, lambda2] = solve(obj, x, lambda, W)
            
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
            
            % Forming K0 from the initial working set
            [obj.K0, b0] = formKKT(obj, W0);
            nActive = nnz(W0);
            
            n = obj.nVars;
            m = obj.nConstraints;
            c = [-obj.linearObjective; b0];
            v = obj.K0_solve(c);
            x2 = v(1:n);
            lambda2 = zeros(m, 1);
            lambda2(W0) = v(n+1: end);
            % iterate
            for iterations = 1:PDASM.MAX_ITERS+1

                % stopping criteria
                if (iterations > 1)
                    if (Wold == W)
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
                U_add = obj.constraintJacobian(added, :);
                nAdded = nnz(added);
                b_add = obj.constraintRHS(added);
                
                U_remove = diag(removed);
                U_remove = U_remove(logical(W0),logical(removed));
                nRemoved = nnz(removed);
                b_remove = zeros(nRemoved,1);
                if isempty(U_add)
                    U_add = [];
                    bottom_left_zeros = [];
                else
                    bottom_left_zeros = zeros(nActive, nAdded);
                end
                if isempty(U_remove)
                    U_remove = [];
                    top_right_zeros = [];
                else
                    top_right_zeros = zeros(n,nRemoved);
                end
                size(U_add');
                size(top_right_zeros);
                size(bottom_left_zeros);
                size(U_remove);
                %iterations
                U = [U_add', top_right_zeros; bottom_left_zeros, U_remove];
                if ~isempty(U)
                    size(U);
                    %a=[obj.K0 U; U' zeros(size(U,2))];
                    %save schurpa a;
                    R = obj.K0_solve(U);
                    C = -U'*R;
                    w = [b_add; b_remove];
                    
                    %ypi = a\[c;w];
                    PI = C\(w - U'*v);
                    y = v - R*PI;
                    x2 = y(1:n);
                    lambda2 = zeros(m,1);
                    lambda2(W0) = -y(n + 1: end);
                    lambda2(added) = -PI(1: nAdded);
                    lambda2(removed) = zeros(nRemoved,1);
                    %x3 = ypi(1:n)';
                    %norm(x3 - x2)
                else
                    x2 = v(1:n);
                    lambda2 = zeros(m, 1);
                    lambda2(W0) = v(n+1: end);
                    break
                end
            end

            % set output
            fval = computeObjective(obj, x(:));
            if (iterations ~= PDASM.MAX_ITERS)
                exitflag = 1;
            end
            obj.output.iters = iterations - 1; % last iteration doesn't count
            output = obj.output;
        end
    end
    
    methods (Access = protected)
        function r = K0_solve(obj, u)
            r = obj.K0\u;
        end
    end
end