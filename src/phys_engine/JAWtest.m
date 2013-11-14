            % initialize the storage space for the constraint jacobian
            nb = 5;
            nw = 6;
                
            p = nb*(nb-1)/2;  %number of object interaction
            wp = nw*nb;   %number of wall-object interaction


            [wall_rows, wall_columns] = find(ones(nw,nb));
            
            wall_rows = 1:3*wp;
            wall_columns = [6*wall_columns-5 6*wall_columns-4, 6*wall_columns-3]';
            wall_columns = wall_columns(:)';
            Wall_indices = sub2ind([3*wp,6*nb],wall_rows,wall_columns);
            
            JAW = sparse(3*wp,6*nb);
            JAW(Wall_indices) = -ones(3*wp,1);
            
            JAW_columns3=zeros(1,length(wall_columns));
            JAW_columns4=zeros(1,length(wall_columns));
        
            %This loops fills in the indices for rx, ry, rz
            for k = 1:length(wall_columns)
                if mod(k,3)==1
                    JAW_columns3(k)=wall_columns(k)+4;
                    JAW_columns4(k)=wall_columns(k)+5;
                elseif mod(k,3)==2
                    JAW_columns3(k)=wall_columns(k)+2;
                    JAW_columns4(k)=wall_columns(k)+4;  
                else 
                    JAW_columns3(k)=wall_columns(k)+1;
                    JAW_columns4(k)=wall_columns(k)+2;                      
                end
            end
            
            JAW_indices3 = sub2ind([3*wp,6*nb],wall_rows,JAW_columns3);
            JAW_indices4 = sub2ind([3*wp,6*nb],wall_rows,JAW_columns4);
         
            JAW(JAW_indices3) = -ones(3*wp,1);  %fill in -ones at where with content            
            JAW(JAW_indices4) = -ones(3*wp,1);
            
            
            wall_normal = [0,0,1;0,0,1;1,0,0;1,0,0;0,1,0;0,1,0];
            wall_direction = [-1;1;-1;1;-1;1];
            temp = wall_normal.*repmat(wall_direction,1,3);
            temp = repmat(temp,nb,1); 
            object_wall_normal=temp;
            
            
            r_vec = [1;2;3;4;5];
            [JAW_BL] = radius_for_JAW(nw,r_vec);
            [zzy,yxx] = expand_normal(wp,object_wall_normal);
           
            JAW(JAW_indices3) = -zzy.*JAW_BL; 
            JAW(JAW_indices4) = -yxx.*JAW_BL;  %fill in ones at where with content
            full(JAW)
            spy(JAW)
            
            
            