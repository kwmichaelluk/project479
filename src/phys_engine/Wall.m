classdef Wall < handle
% The class of not moveable walls
% Described by the line equation
%       a*x + b*y = c
    properties
        restitution;
        normal;
        c;
        normal_direction;   %indicate which side of the wall is feassible
        
        
    end
    
    methods
        function obj = Wall(a,b,c,side,restitution)
            if(nargin > 0)
                obj.restitution = restitution;
                obj.normal = [a b];
                obj.c = c;
                obj.normal_direction = side;
            end
        end
        
    end
end
