classdef PDASM
    % Primal-dual active-set method class
    %
    % Solves the following sparse, convex quadratic programming problem:
    %
    %   minimize 0.5 * x' H * x + x' * c
    %
    %   subject to
    %               A * x >= b
    %
    % INPUT:
    % H - symmetric positive definite matrix of size n x n
    % A - sparse full row rank matrix of size m x n
    % x_0 - initial primal guess of size n x 1
    % lambda_0 - initial lambda guess of size m x 1
    %
    % OUTPUT:
    % x - optimal primal solution of size n x 1
    % lambda - optimal dual solution of size n x 1
    % fval - optimal value
    % exitflag - 1 if algorithm converged; 0 otherwise
    % iterations - min(number of iterations required for convergence, maxIters) 
    % 
    % See Ito and Kunisch 2008 Lagrange Multiplier Approach to Variational
    % Problems and Applications (Chapter 7)
    properties (Constant)
        MAX_ITERS = 100;
        EPS = 1e-8;
        TOL = 1e-8;
    end
    
    properties (GetAccess = 'protected', SetAccess = 'protected')
        Hessian;
        linearObjective;
        constraintJacobian;
        constraintRHS;
        nConstraints;
        nVars;
        output;
    end
    
    methods
        function obj = PDASM(H, c , A , b, m, n)
            if (nargin > 0)
                obj.Hessian = H;
                obj.linearObjective = c;
                obj.constraintJacobian = A;
                obj.constraintRHS = b;
                obj.nConstraints = m;
                obj.nVars = n;
            end
        end
        
        function [x, fval, exitflag, output, lambda, activeSet] = solve(obj, x, lambda, W)
            
            % ensure all vectors are column vectors
            x = x(:); lambda = lambda(:); W = W(:);
            
            % ensure proper dimensions
            checkDimensions(obj, x, lambda, W);
            
            % set the initial iterates
            if (isempty(W))
                if (isempty(x))
                    x = zeros(obj.nVars,1);
                end
                if (isempty(lambda))
                    lambda = zeros(obj.nConstraints);
                end
                W = prediction(obj, x, lambda);
            end
            
            % output arguments
            exitflag = 0;
            obj.output = {};
            
            % iterate
            for iterations = 1:PDASM.MAX_ITERS+1

                % stopping criteria
                if (iterations > 1)
                    if (Wold == W)
                        activeSet = W;
                        break;
                    end
                end

                % solve equality subproblem induced by working set
                [x, lambda, obj] = equalitySubProblem(obj, W, iterations);

                % record last prediction
                Wold = W;

                % current prediction
                W = prediction(obj, x, lambda);
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
        
        function checkKKT(obj, x, lambda)
            % parameters
            throw_flag = 0;
            eps = obj.EPS;
            tol = obj.TOL;
            err = MException('ResultChk:BadInput', ...
                'KKT Conditions not met.');
            H = obj.Hessian;
            d = obj.linearObjective;
            A = obj.constraintJacobian;
            b = obj.constraintRHS;

            % peripheral data
            %size(A)
            %size(x)
            %size(b)
            s = A * x(:) - b;

            % kkt conditions
            if(~isempty(s(s < -eps)~= 0)) % should be 0
                throw_flag = 1;
                errCause = MException('Result:BadInput', 'Constraints are not satisfied.');
                err = addCause(err, errCause);
            end

            if(~isempty(lambda(lambda < -eps))) % should be 0
                throw_flag = 1;
                errCause = MException('Result:BadInput', 'Dual variable is infeasible.');
                err = addCause(err, errCause);
            end

            if(norm(H * x(:) + d - A' * lambda) > tol)
                throw_flag = 1;
                errCause = MException('Result:BadInput', 'Gradient of Lagrangian is nonzero.');
                err = addCause(err, errCause);
            end

            if(norm(s.* lambda) > tol)
                throw_flag = 1;
                errCause = MException('Result:BadInput', 'Complementarity slackness is nonzero.');
                err = addCause(err, errCause);
            end

            if(throw_flag)
                throw(err);
            end
        end
    end
    methods (Access = protected)
        function [K, b] = formKKT(obj, W)
            %
            % formKKT(W)
            %
            % Forms the KKT system defined by the working set W

            p = nnz(W);
            A = obj.constraintJacobian(W,:);
            %full(A)
            [~,S,V] = svds(A,min(size(A)));
            S;
            size(V);
            if (issparse(A))
               K = [obj.Hessian, A'; A, sparse(p,p)];
            else
               K = [obj.Hessian, A'; A, zeros(p)];
            end
            b = obj.constraintRHS(W);
        end
        function [K, b] = formKKTLarge(obj, W)
            %
            % formKKTLarge(W)
            %
            % Forms the expanded KKT system defined by the working set W
            p = nnz(W);
            m = obj.nConstraints;
            n = obj.nVars;
            
            % form KKT
            A = obj.constraintJacobian;
            A(~W, :) = sparse(m - p, n);
            E = speye(m);
            E(W, :) = sparse(p, m);
            K = [obj.Hessian, A'; A, E];

            % form rhs
            b = obj.constraintRHS;
            b(~W) = zeros(m - p, 1);
        end
    end
    methods (Access = protected)
        function W = prediction(obj, x, lambda)
            %W = lambda + obj.constraintRHS - obj.constraintJacobian*x > 0;
            %lambda + obj.constraintRHS - obj.constraintJacobian*x
            W = lambda + obj.constraintRHS - obj.constraintJacobian*x > 0;
%             m = length(W);
%             for i=1:4:m
%                 if (obj.constraintRHS(i) < eps)
%                     % treat as 0
%                     W(i) = 1;
%                     W(i+1) = 0;
%                     W(i+2) = 1;
%                     W(i+3) = 0;
%                 end
%             end
        end
        
        function f = computeObjective(obj, x)
            f = 0.5*x'*obj.Hessian*x + obj.linearObjective'*x;
        end
        
        function checkDimensions(obj, x, lambda, W)
            %
            % checkDimensions(this)
            %
            % Checks that all dimensions are correct

            % parameters
            throw_flag = 0;
            H = obj.Hessian;
            d = obj.linearObjective;
            A = obj.constraintJacobian;
            b = obj.constraintRHS;
            m = obj.nConstraints;
            n = obj.nVars;
            
            % check nonzero hessian
            if (size(H, 1) ~= n || size(H, 2) ~= n)
                throw_flag = 1;
                output = 'Incorrect Hessian dimensions.';

            % check d
            elseif (length(d) ~= n)
                throw_flag = 1;
                output = 'Incorrect object linear term dimensions.';

            % check A
            elseif (size(A, 1) ~= m || size(A, 2) ~= n)
                throw_flag = 1;
                output = 'Incorrect constraint matrix dimensions.';
                
            % check B
            elseif (length(b) ~= m)
                throw_flag = 1;
                output = 'Incorrect right hand side dimensions.';

            % check x
            elseif (length(x) ~= n && ~isempty(x))
                throw_flag = 1;
                output = 'Incorrect primal variable dimensions.';

            % check lambda
            elseif (length(lambda) ~= m && ~isempty(lambda))
                throw_flag = 1;
                output = 'Incorrect dual variable dimensions.';
                
            % check working set
            elseif (length(W) ~= m && ~isempty(W))
                throw_flag = 1;
                output = 'Incorrect working set dimensions.';
            end

            if (throw_flag)
                err = MException('ResultChk:BadInput', output);
                throw(err);
            end
        end
    end
    methods (Access = protected)
       [x, lambda, obj] = equalitySubProblem(obj, W, iter)
    end
end