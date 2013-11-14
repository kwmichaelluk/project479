classdef Disk < RigidBody
    % Circular Disk is a type of rigid body
    
    properties
        radius;


    end
    
    methods
        function obj = Disk(X,Y,V,angle,m,r,res)
            I = m*r^2/2;
            obj = obj@RigidBody(X,Y,V,angle,[I m m],res);
            obj.radius = r;
            obj.xmax = obj.position(1) + obj.radius;
            obj.xmin = obj.position(1) - obj.radius;
            obj.ymax = obj.position(2) + obj.radius;
            obj.ymin = obj.position(2) - obj.radius;

        end
        
        function draw(obj)  %nothing to do with physics
            %calculate the points on the boundary 
            interval = 1/obj.resolution;
            t = (interval:interval:1)*2*pi;
            x_outline = obj.radius*cos(t+obj.theta);
            y_outline = obj.radius*sin(t+obj.theta);
            %disp(obj.position(1));
            obj.vertices = [x_outline+obj.position(1); y_outline+obj.position(2)]';
            %disp(obj.vertices);
            obj.faces(1,1:obj.resolution/2) = 1:obj.resolution/2;
            obj.faces(2,1:obj.resolution/2) = obj.resolution/2+1:obj.resolution;

            
        end
        
        function bounding_box(obj)
            obj.xmax = obj.position(1) + obj.radius;
            obj.xmin = obj.position(1) - obj.radius;
            obj.ymax = obj.position(2) + obj.radius;
            obj.ymin = obj.position(2) - obj.radius;
            %disp(obj.xmax);
        end
        
        
    end
end
