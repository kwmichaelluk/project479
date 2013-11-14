function [vertices faces] = disk_vertices(position,angle,radius,resolution)
%get the vertices & the faces of the disk object from the position & angles
%   Input: position, angle, and radius vectors + resolution
%   Output: vertices & faces matrices for the patch object
throw_flag = 0;
if (mod(resolution,2)==1)
    throw_flag = 1;
    output = 'number of edges must be even';
end

if (throw_flag)
    err = MException('ResultChk:BadInput', output);
    throw(err);
end
len = length(angle);
%parametrize each circle by the angle t
interval = 1/resolution;
t = (interval:interval:1)'*2*pi;
t = repmat(t,[1,len]);

%put the vectors into the right format to do binary operations
angle = repmat(angle,[1,resolution]);
angle = angle';
position = repmat(position,[1,1,resolution]);
position = permute(position,[3,2,1]);

%construct the vertices of the circles
outline = zeros(resolution,2,len);
%radius
%cos( t + angle )
outline(:,1,:) = cos( t + angle )*diag(radius); 
outline(:,2,:) = sin( t + angle )*diag(radius);

%shift to the right places
vertices_in_3d_matrix = outline + position;

%convert from 3d to 2d to put into the patch object
vertices_in_3d_matrix = permute(vertices_in_3d_matrix, [1,3,2]);
vertices = reshape(vertices_in_3d_matrix,[],2,1);

%assign the faces from the indices of the vertices
faces = reshape(1:resolution*len,resolution/2,2*len)';
