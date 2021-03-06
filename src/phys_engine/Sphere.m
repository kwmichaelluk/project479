classdef Sphere < RigidBody3D
    %Sphere is a type of rigid body
    %RigidBody3D(position_vector,velocity_vector,mass_vector,res)
    properties
        radius;
    end
    
    methods
        function obj = Sphere(position,velocity,m,r,res)
            I = 2/5*m*r^2; %moment of ineria
            obj = obj@RigidBody3D(position,velocity,[m,m,m,I,I,I],res);
            obj.radius = r;
            obj.xmax = obj.position(1) + obj.radius;
            obj.xmin = obj.position(1) - obj.radius;
            obj.ymax = obj.position(2) + obj.radius;
            obj.ymin = obj.position(2) - obj.radius;
            obj.zmax = obj.position(3) + obj.radius;
            obj.zmin = obj.position(3) - obj.radius;
        end
        
%         function draw(obj) %%%?????
%             %calculate the points on the boundary 
%             interval = 1/obj.resolution;
%             t = (interval:interval:1)*2*pi;  % 0:nterval:1?
%             x_outline = obj.radius*cos(t+obj.theta);
%             y_outline = obj.radius*sin(t+obj.theta);
%             %z_outline = obj.radius*sin(t+obj.theta);
%             %disp(obj.position(1));
%             obj.vertices = [x_outline+obj.position(1); y_outline+obj.position(2)]';
%             %disp(obj.vertices);
%             obj.faces(1,1:obj.resolution/2) = 1:obj.resolution/2;
%             obj.faces(2,1:obj.resolution/2) = obj.resolution/2+1:obj.resolution;
%         end
        
        %function bounding_box(obj)
         %   obj.xmax = obj.position(1) + obj.radius;
          %  obj.xmin = obj.position(1) - obj.radius;
           % obj.ymax = obj.position(2) + obj.radius;
           % obj.ymin = obj.position(2) - obj.radius;   
           % obj.zmax = obj.position(3) + obj.radius;
           % obj.zmin = obj.position(3) - obj.radius;
            
            %disp(obj.xmax);
        %end
        
    end
end