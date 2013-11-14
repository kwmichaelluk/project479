classdef Wall3D < handle
% The class of 3D non-moveable walls
% Described by the line equation
%       a*x + b*y + c*z = d
    properties
        restitution;
        normal;
        d;
        normal_direction;   %indicate which side of the wall is feassible
    end
    
    methods
        function obj = Wall3D(a,b,c,d,side,restitution)
            if(nargin > 0)
                obj.restitution = restitution;
                obj.normal = [a b c];
                obj.d = d;
                obj.normal_direction = side;
            end
        end
        
    end
end