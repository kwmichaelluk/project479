classdef RigidBody < handle
% The class of movealbe rigid-bodies    
    properties
        H; %configuration matrix
        V; %velocity vector
        position;
        velocity;
        xmax;
        xmin;
        ymax;
        ymin;
        mass = 1;
        mass_vector;
        theta; %angle in radian
        omega; %angular velocity, take counter clockwise to be positive
        x_boundary;
        y_boundary;
        resolution;
        vertices;
        faces;
    end
    
    methods
        function obj = RigidBody(X,Y,V,angle,mass_vector,res)
            if(nargin > 0)
                obj.V = V;
                obj.position = [X Y];
                %disp(obj.V);
                obj.mass_vector = mass_vector;
                obj.resolution = res;
                obj.theta = angle;
                obj.omega = V(1);
            end
        end
        
        function I = I(obj)
            %moment of inertia
            I = obj.mass_vector(1);
        end
        
    end
end
