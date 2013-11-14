function [zzy,yxx] = expand_normal(p,normal)
%normal is p by 3

            %p = 4;
A = normal;
            %A = [1,2,3;4,5,6;7,8,9;10,11,12];
A2 = horzcat(A,-A,A);
A3 = A2';
A4 = reshape(A3,3,3*p);

index = sparse(3,3);
index([7,8,6])=ones(3,1);  % zzy at 7,8,6
index = repmat(index,p,1)';
zzy = A4(logical(index));

A2 = horzcat(-A,A,-A);
A3 = A2';
A4 = reshape(A3,3,3*p);

index2 = sparse(3,3);
index2([4,2,3])=ones(3,1);  % zzy at 4,2,3
index2 = repmat(index2,p,1)';
yxx = A4(logical(index2));



