classdef RigidBody3D < handle
% The class of movealbe rigid-bodies    
    properties
        position;  %position vector
        velocity;  %velocity vector
        mass = 1;
        mass_vector;
        phi; theta; psi; %all angles in radian
        omega_phi; omega_theta; omega_psi; %angular velocity, take counter clockwise to be positive
        resolution;
        
        %used in Disk
        xmax;xmin;  ymax;ymin;  zmax;zmin;
        
        %the following variables are currently unused
        H; %configuration matrix
        x_boundary;  y_boundary;  z_boundary; 
        vertices;
        faces;
    end
    
    methods
        function obj = RigidBody3D(position_vector,velocity_vector,mass_vector,res)
            if(nargin > 0)
                obj.position = position_vector; %[X,Y,Z,angle1,angle2,angle3];
                obj.velocity = velocity_vector;
                
                obj.phi = position_vector(4);
                obj.theta = position_vector(5); 
                obj.psi = position_vector(6); 
                obj.omega_phi = velocity_vector(4);
                obj.omega_theta = velocity_vector(5);
                obj.omega_psi = velocity_vector(6);
                
                obj.mass_vector = mass_vector;
                obj.resolution = res; 
            end
        end
        %%%%???%%%%
        function I = I(obj)
            %moment of inertia
            I = obj.mass_vector(1);
        end
        
    end
end