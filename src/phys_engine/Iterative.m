classdef Iterative < PDASM
    % Iterative implementation of PDASM
    methods
        function obj = Iterative(H, c, A, b, m, n)
            obj = obj@PDASM(H,c,A,b,m,n);
        end
    end
    methods (Access = protected)
        function [x, lambda, obj] = equalitySubProblem(obj, W, ~)
            
            % form the KKT matrix induced by W
            [K, b] = formKKT(obj, W);
            
            % solve the KKT system
            n = obj.nVars;
            m = obj.nConstraints;
            rhs = [-obj.linearObjective; b];
            A=K(1:n,1:n);
            B=K(n+1:end,1:n);
            mm=size(K,1)-n;

            
            if (~isempty(B))
                M=[speye(size(A)) B'; B sparse(mm,mm)];
                [soln,flag,relres,iter,resvec] = gmres(K,rhs,size(K,1),1e-10,100,M);
                %figure;
                %semilogy(resvec);
                %figure
                %spy(K)

            else
                [soln,flag,relres,iter,resvec] = gmres(K,rhs,size(K,1),1e-10,100);
                %figure;
                %semilogy(resvec);
            end
            %soln = K \ [-obj.linearObjective; b];
            lambda = zeros(m, 1);
            lambda(W) = -soln(n + 1: end);
            x = soln(1: n);
        end
    end
end