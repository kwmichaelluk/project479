classdef Direct < PDASM
    % Direct implementation of PDASM
    methods
        function obj = Direct(H, c, A, b, m, n)
            obj = obj@PDASM(H,c,A,b,m,n);
        end
    end
    methods (Access = protected)
        function [x, lambda, obj] = equalitySubProblem(obj, W, ~)
            
            % form the KKT matrix induced by W
            [K, b] = formKKT(obj, W);
            %condest(K)
            % solve the KKT system
            n = obj.nVars;
            m = obj.nConstraints;
            soln = K \ [-obj.linearObjective; b];
            lambda = zeros(m, 1);
            lambda(W) = -soln(n + 1: end);
            x = soln(1: n);
        end
    end
end