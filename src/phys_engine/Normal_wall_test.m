                  % initialize the storage space for the constraint jacobian
            nb = 5;
            %nw = 4;
            nw = 6;
                
            p = nb*(nb-1)/2;  %number of object interaction
            wp = nw*nb;   %number of wall-object interaction          

%wall_normal = [0,1;0,1;1,0;1,0];
%wall_direction = [-1;1;1;-1];

wall_normal = [0,0,1;0,0,1;1,0,0;1,0,0;0,1,0;0,1,0];
wall_direction = [-1;1;-1;1;-1;1];
%             w_rows = 1:wp;
%             w_columns1 = 1:2:2*wp;
%             w_columns2 = 2:2:2*wp;
%             
%             %the normal of the wall, pointing away from the frobidden region
%             haha = wall_normal .* repmat(wall_direction,1,2);
%             lala = repmat(haha,nb,1);
%             lala = ones(20,2);
% 
%             w_indices1 = sub2ind([wp 2*wp], w_rows, w_columns1);
%             w_indices2 = sub2ind([wp 2*wp], w_rows, w_columns2);
%             Normal_wall = sparse(wp,2*wp);
%             Normal_wall(w_indices1) = lala(:,1);
%             Normal_wall(w_indices2) = lala(:,2);

            w_rows = 1:wp;
            w_columns1 = 1:3:3*wp;
            w_columns2 = 2:3:3*wp;
            w_columns3 = 3:3:3*wp;
            % the normal of the wall, pointing away from the forbidden region
         
            %%variable "normal_wall" is re-named "temp" tp avoid confusion with obj.normal_wall
            temp = wall_normal .* repmat(wall_direction,1,3);
            temp = repmat(temp,nb,1); 

            w_indices1 = sub2ind([wp 3*wp], w_rows, w_columns1);
            w_indices2 = sub2ind([wp 3*wp], w_rows, w_columns2);
            w_indices3 = sub2ind([wp 3*wp], w_rows, w_columns3);
            Normal_wall = sparse(wp,3*wp);
            Normal_wall(w_indices1) = temp(:,1);
            Normal_wall(w_indices2) = temp(:,2);
            Normal_wall(w_indices3) = temp(:,3);