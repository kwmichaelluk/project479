classdef SchurComplement < PDASM
    %Schur Complement implementation of PDASM
    methods
        function obj = SchurComplement(H, c, A, b, m, n)
            obj = obj@PDASM(H, c, A, b, m, n);
        end
    end
    methods (Access = protected)
        function [x, lambda, obj] = equalitySubProblem(obj, W, ~)
            
            %form the Schur complement
            A = obj.constraintJacobian(W,:);
            b = obj.constraintRHS(W);
            H_inverse = obj.Hessian^-1;
            n = obj.nVars;
            m = obj.nConstraints;
            c = - obj.linearObjective;
            lambda = zeros(m,1);
            if isempty(A)
                x = H_inverse*c;
            else
                SC = A*H_inverse*A';
                lambda(W) = - SC\(A*H_inverse*c - b);
                x = H_inverse * ( c + A' * lambda(W) );
            end
        end
    end
end
