function [H, d, A, b, x0] = randQPSparse(m, n, cn)
%
% randQPDense forms a random dense QP with n x n hessian H and m x n
% constraint matrix A.  We assume that n >= m so that the problem is always
% feasible

% objective data
nnz_row = 10;
densityH = nnz_row/(n);
if (nargin < 3)
    rc = 1e-4; % reciprical condition number
else
    rc = 1/cn;
end
H = sprandsym(n, densityH, rc, 2);
d = rand(n, 1)-0.5;

densityA = 2*nnz_row/(n);
%B = sprand(m, n - m, densityA);
%A = [speye(m) B]; % concatenating the identity ensures A is full row rank
A = sprand(m,n,densityA);
x0 = rand(n,1);
p = 1e-3*rand(m,1);
%b = A*x0 - p; % ensure feasible
b = zeros(m,1);
end