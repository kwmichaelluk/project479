function draw_at_time(S,t)
%Draw the disks in scene S at time t
%   Input: scene: S, time frame: t
%   Output: None

%read data from S
position(:,1) = S.x_trajectory(:,t);
position(:,2) = S.y_trajectory(:,t);
angle = S.angle_trajectory(:,t);

%get the coordinates of vertices of the polygons
[vertices faces] = disk_vertices(position,angle,S.radius,S.number_of_edges);

%construct the patch properties and put them into the right format 
len = length(angle);
blue = [0.8 0.8 0.9];
red = [0.9 0.3 0.3];
cdata = [];
cdata(1,:,:) = [blue; red];
cdata = repmat(cdata,[1 len 1]);

%disp(vertices);
%disp(faces);

set(S.lines,...
    'CData',cdata,...
    'Vertices',vertices,...
    'Faces',faces);
