            % initialize the storage space for the constraint jacobian
            nb = 4;
            nw = 4;
                
            p = nb*(nb-1)/2;  %number of object interaction
            wp = nw*nb;   %number of wall-object interaction
                
            %%%%%%%%%%%%% Begin JA %%%%%%%%%%%%%%%%%%%%%%
             [tri_rows, tri_columns] = find(tril(ones(nb),-1)); %the two vectors of lower triangular matrix                

             rows = 1:3*p;
             columns1 = [6*tri_columns-5 6*tri_columns-4 6*tri_columns-3]'; % spread out 3x columns and fill in 2nd and 3rd column
             columns1 = columns1(:)';
 
            indices1 = sub2ind([3*p,6*nb],rows,columns1);

            JA = sparse(3*p,6*nb);
            JA(indices1) = -ones(3*p,1);  %no angular (1st,4th,7th... columns are empty)
                
            columns2  = [6*tri_rows-5 6*tri_rows-4 6*tri_rows-3]';
            columns2 = columns2(:)';
             
            indices2 = sub2ind([3*p,6*nb],rows,columns2);
                    %indices2 = sub2ind([2*p,3*nb],rows,rows2);
            JA(indices2) = ones(3*p,1);  %fill in ones at where with content
                    
            
            JA_columns3 = zeros(1,length(columns1));
            JA_columns4 = zeros(1,length(columns1));
            JA_columns5 = zeros(1,length(columns2));
            JA_columns6 = zeros(1,length(columns2));
            
            %This loops fills in the indices for rx, ry, rz
            for k = 1:length(columns1)
                if mod(k,3)==1
                    JA_columns3(k)=columns1(k)+4;
                    JA_columns4(k)=columns1(k)+5;
                elseif mod(k,3)==2
                    JA_columns3(k)=columns1(k)+2;
                    JA_columns4(k)=columns1(k)+4;  
                else 
                    JA_columns3(k)=columns1(k)+1;
                    JA_columns4(k)=columns1(k)+2;                      
                end
            end
            for k = 1:length(columns2)
                if mod(k,3)==1
                    JA_columns5(k)=columns2(k)+4;
                    JA_columns6(k)=columns2(k)+5;
                elseif mod(k,3)==2
                    JA_columns5(k)=columns2(k)+2;
                    JA_columns6(k)=columns2(k)+4;  
                else 
                    JA_columns5(k)=columns2(k)+1;
                    JA_columns6(k)=columns2(k)+2;                      
                end
            end  
            
            JA_indices3 = sub2ind([3*p,6*nb],rows,JA_columns3);
            JA_indices4 = sub2ind([3*p,6*nb],rows,JA_columns4);
            JA_indices5 = sub2ind([3*p,6*nb],rows,JA_columns5);
            JA_indices6 = sub2ind([3*p,6*nb],rows,JA_columns6);              
            
            % test that the elements ae filled in in the correct order
%             for i = 1:length(JA_indices4)
%                 JA(JA_indices4(i)) = 1;  %fill in ones at where with content            
%                 spy(JA)
%                 drawnow
%                 pause(1)
%             end
            JA(JA_indices3) = -ones(3*p,1); 
            JA(JA_indices4) = -ones(3*p,1);  %fill in ones at where with content
            JA(JA_indices5) = ones(3*p,1);  %fill in ones at where with content
            JA(JA_indices6) = ones(3*p,1);  %fill in ones at where with content
            
            normal=[1,2,3;4,5,6;7,8,9;10,11,12;13,14,15;16,17,18];
            %
            r_vec = [1;2;3;4];
            [JA_BL,JA_TR] = radius_for_JA(nb,r_vec);
            [zzy,yxx] = expand_normal(p,normal);
            
            JA(JA_indices3) = -zzy.*JA_BL; 
            JA(JA_indices4) = -yxx.*JA_BL;  %fill in ones at where with content
            JA(JA_indices5) = zzy.*JA_TR;  %fill in ones at where with content
            JA(JA_indices6) = yxx.*JA_TR;  %fill in ones at where with content
            full(JA)
            spy(JA)