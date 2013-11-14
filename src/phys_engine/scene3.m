classdef scene3 < handle
    % A scene contains rigid bodies which interact with each other
    properties
        RigidBodies = [];
        Walls = [];
        collision_flags;
        height;
        width;
        ax;     %the axes object
        lines;  %the patch object
        global_position;
        global_velocity;    %the time derivative for the Dofs of the system
        global_mass;    %vector
        gravity;
        constraint = [];
        x_trajectory = [];
        y_trajectory = [];
        angle_trajectory = [];
        radius = []; % maybe of various size in future
        velocity_log = [];
        loop_time;
        max_time;
        stop_time;
        number_of_edges;
        step_size;
        wall_normal = [];
        wall_c = [];
        wall_direction = [];
        Normal_object;
        Normal_indices; 
        JA;
        JW;
        previous_set = [];
    end
    
    methods
        function obj = scene3(H,W,number_of_edges,AXES,max_time,step_size)
            obj.ax = AXES;
            obj.lines = patch();
            obj.height = H;
            obj.width = W;
            obj.number_of_edges = number_of_edges;
            obj.max_time = max_time;
            obj.gravity = 100;
            obj.step_size = step_size;
            obj.loop_time = zeros(1,max_time);
            obj.stop_time = 0;
            
            %initializing the walls
            top = Wall(0,1,H/2,-1,0);
            bottom = Wall(0,1,-H/2,1,0);
            left = Wall(1,0,-W/2,1,0);
            right = Wall(1,0,W/2,-1,0);
            obj.adding_wall(top);
            obj.adding_wall(bottom);
            obj.adding_wall(left);
            obj.adding_wall(right);
            
        end
        
        function adding_body(obj,B)
            obj.RigidBodies = [obj.RigidBodies B];
            disp('A rigid body has been added to the scene');
            obj.global_position = [obj.global_position; [B.position B.theta]];
            obj.global_velocity = [obj.global_velocity; B.V];
            obj.global_mass = [obj.global_mass; B.mass_vector'];
            obj.radius = [obj.radius B.radius];
        end
        
        function adding_wall(obj,W)
            % the wall is a line with equation a*x + b*y = c
            % wall_direction pointing towards the empty side
            obj.Walls = [obj.Walls W];
            obj.wall_normal = [obj.wall_normal; W.normal];
            obj.wall_c = [obj.wall_c; W.c];
            obj.wall_direction = [obj.wall_direction; W.normal_direction];
        end
            
        function initialize_configuration(obj,r,n)
            %initialize the configuration of n equal circles with the same
            %radius r
            xstart = -obj.width/2 + 1*r;
            xend = obj.width/2 - 1*r;
            ystart = obj.height/2 - 2*r;
            yend = -obj.height/2 + 2*r;
            xinterval = 2.1*r;
            yinterval = 2.1*r;
            xnumber = floor((xend - xstart)/xinterval);
            ynumber = floor((ystart - yend)/yinterval);

            %create n number of disks
            for i = 1:n
                % distribute the disks so they won't overlap when created
                x = xstart + (mod((i-1),xnumber)+1)*xinterval;
                y = ystart - floor((i-1)/ynumber)*yinterval;
                theta = 2*pi*rand;
                vx = 10*rand-5;
                vy = 10*rand-5;
                angle = rand;
                omega = 0;
                createDisk(obj,r,x,y,vx,vy,angle,omega,obj.number_of_edges);
                %create a disk with random velocity at the position(x,y)
            end
            
            %initialize the space to store the states 
            obj.x_trajectory = zeros(n,obj.max_time);
            obj.y_trajectory = zeros(n,obj.max_time);
            obj.angle_trajectory = zeros(n,obj.max_time);
            obj.velocity_log = zeros(3*n,obj.max_time);
            
            obj.x_trajectory(:,1) = obj.global_position(:,1);
            obj.y_trajectory(:,1) = obj.global_position(:,2);
            obj.angle_trajectory(:,1) = obj.global_position(:,3);
            obj.velocity_log(:,1) = obj.global_velocity;
        
        end
        
    end
        
    methods
        function draw_scene(obj)
            % set the graphic properties
            set(obj.ax,...
                'Box','on',...
                'DataAspectRatio',[1 1 1],...
                'XLim',[-obj.width/2 obj.width/2],...
                'YLim',[-obj.height/2 obj.height/2],...
                'XLimMode','manual',...
                'YLimMode','manual',...
                'XTick',[-obj.width/2 0 obj.width/2],...
                'YTick',[-obj.height/2 0 obj.height/2],...
                'XTickLabel',[-obj.width/2 0 obj.width/2],...
                'YTickLabel',[-obj.height/2 0 obj.height/2]);
             set(obj.lines,...
                'CData',[],...
                'Parent',obj.ax,...
                'FaceColor','flat',...
                'CDataMapping','scaled',...
                'EdgeColor', [0.1 0.1 0.5],...
                'EdgeAlpha', 0.5,...
                'LineWidth', 1,...
                'tag', 'shape');
        end
        
        function dynamics(obj,t,solver)
            dt = obj.step_size;
            g = obj.gravity;
            nb = length(obj.RigidBodies);
            nw = length(obj.Walls);
      
            x = obj.x_trajectory(:,t);
            y = obj.y_trajectory(:,t);
            theta = obj.angle_trajectory(:,t);
            radius = obj.radius(1);
            
            %Ja with no rotation
            Ja = [0 1 0; 0 0 1];

            % the formula gives the distance between a point and a line
            distance = abs(obj.wall_normal * vertcat(x', y') + ...
            repmat(obj.wall_c,1,nb))./ ...
            repmat(sqrt(sum(abs(obj.wall_normal).^2,2)),1,nb) - radius;
            
            w_speed_bound = distance(:)/dt;
            
            J = obj.JW;
            b = -w_speed_bound;
            constraint_count = nw * nb;

            XM = repmat(x,1,nb);
            YM = repmat(y,1,nb);
            x_difference = tril(XM - XM');
            y_difference = tril(YM - YM');
            [lower_tri_rows, lower_tri_columns] = find(tril(ones(nb),-1)); %the two vectors of the indices of a lower triangular matrix
            position_indices = sub2ind([nb,nb],lower_tri_rows, lower_tri_columns);
            x_difference = x_difference(position_indices);
            y_difference = y_difference(position_indices);
            displacement = horzcat(x_difference, y_difference);

            distance_from_centre = sqrt(x_difference.^2 + y_difference.^2);
            distance = distance_from_centre - 2 * radius;
            speed_bound = distance / dt;

            normal = displacement./horzcat(distance_from_centre, distance_from_centre);

            p = nb*(nb - 1)/2; %number of constraints

            normal = normal';
            normal = normal(:);
            
            obj.Normal_object(obj.Normal_indices) = normal;

            Jo = obj.Normal_object*obj.JA;  %constraints between objects

            J = vertcat(J,Jo);
            b = vertcat(b,-speed_bound);
            constraint_count = constraint_count + p;
            
            %resting threshold
            if (1)
                %construct the matrices to be used in the QP solver
                %   new_v = argmin 1/2* old_v'*M_matrix*old_v - old_v*f_g
                %   subject t0 J*v >= 0
                %   where M_matrix is the mass matrix and f_g is the global
                %   force(gravity)
                M_matrix = diag(obj.global_mass);
                f_g = (M_matrix*obj.velocity_log(:,t) - dt*repmat([0 0 g]',nb,1));
                % If the constrain matrix is not empty, solve for the
                % velocity that satisfies the constrain
                if ~isempty(J)

                    KKT = [M_matrix J'; J zeros(constraint_count)];
                    %R = cholinc(KKT,1E-5);
                    %v = pcg(KKT,[-f_g; b],1E-3,100,R',R);
                    v = pcg(KKT,[-f_g; b]);
                    %v = gmres(KKT, [f_g; b]);
                    obj.global_velocity = v(1:3*nb);

                end
                obj.velocity_log(:,t+1)= obj.global_velocity;
            end

            %update the configuration from the calculated velocity

            obj.x_trajectory(:,t+1) = x + obj.global_velocity(2:3:end) * dt;
            obj.y_trajectory(:,t+1) = y + obj.global_velocity(3:3:end) * dt;
            obj.angle_trajectory(:,t+1) = theta + obj.global_velocity(1:3:end) * dt;
        end
        
        function jacobian_initialization(obj)
            % initialize the storage space for the constraint jacobian
            nb = length(obj.RigidBodies);
            nw = length(obj.Walls);
                
            p = nb * ( nb - 1 ) / 2;
            wp = nw * nb;
                
            rows = 1:p;
            columns1 = 1:2:2*p;
            columns2 = 2:2:2*p;
            indices1 = sub2ind([p 2*p], rows, columns1);
            indices2 = sub2ind([p 2*p], rows, columns2);
            indices = vertcat(indices1, indices2);
            indices = indices(:);
            obj.Normal_object = sparse(p,2*p);
            obj.Normal_object(indices) = ones(2*p,1);
            obj.Normal_indices = indices;
            
            [tri_rows, tri_columns] = find(tril(ones(nb),-1)); %the two vectors of lower triangular matrix                
            %[tri_rows, tri_columns] = find(triu(ones(nb),1)); %the two vectors of lower triangular matrix                
            
            rows = 1:2*p;
            columns1 = [3*tri_columns-1 3*tri_columns]';
            columns1 = columns1(:)';
            rows1 = [3*tri_rows-1 3*tri_rows]';
            rows1 = rows1(:)';
            
            indices1 = sub2ind([2*p,3*nb],rows,columns1);
            %indices1 = sub2ind([2*p,3*nb],rows,rows1);
            obj.JA = sparse(2*p,3*nb);
            obj.JA(indices1) = -ones(2*p,1);
                
            columns2  = [3*tri_rows-1 3*tri_rows]';
            columns2 = columns2(:)';
            rows2 = [3*tri_columns-1 3*tri_columns]';
            rows2 = rows2(:)';
            
            indices2 = sub2ind([2*p,3*nb],rows,columns2);
            %indices2 = sub2ind([2*p,3*nb],rows,rows2);
            obj.JA(indices2) = ones(2*p,1);
            
            w_rows = 1:wp;
            w_columns1 = 1:2:2*wp;
            w_columns2 = 2:2:2*wp;
            
                        % the normal of the wall, pointing away from the frobidden
            % region
            wall_normal = obj.wall_normal .* repmat(obj.wall_direction,1,2);
            wall_normal = repmat(wall_normal,nb,1);

            w_indices1 = sub2ind([wp 2*wp], w_rows, w_columns1);
            w_indices2 = sub2ind([wp 2*wp], w_rows, w_columns2);
            Normal_wall = sparse(wp,2*wp);
            Normal_wall(w_indices1) = wall_normal(:,1);
            Normal_wall(w_indices2) = wall_normal(:,2);
            
            [wall_rows, wall_columns] = find(ones(nw,nb));
            
            wall_rows = 1:2*wp;
            wall_columns = [3*wall_columns-1 3*wall_columns]';
            wall_columns = wall_columns(:)';
            Wall_indices = sub2ind([2*wp, 3*nb],wall_rows,wall_columns);
            
            JAW = sparse(2*wp, 3*nb);
            JAW(Wall_indices) = -ones(2*wp,1);
            obj.JW = Normal_wall*JAW;
        end
        
        
    end
    
end
            