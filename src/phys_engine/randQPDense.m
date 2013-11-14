function [H, d, A, b] = randQPDense(m, n)
%
% randQPDense forms a random dense QP with n x n hessian H and m x n
% constraint matrix A.  We assume that n >= m so that the problem is always
% feasible

% objective data
R = rand(n);
H = R' * R; % random SPD hessian
d = rand(n, 1); % linear term

% constraint data
A = rand(m, n);
b = zeros(m, 1);
end