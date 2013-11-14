function createDisk(S,R,X,Y,Vx,Vy,angle,omega,res)
%adding a Disk of random velocity to the scene
V = V_vector(Vx,Vy,omega);

S.adding_body(Disk(X,Y,V,angle,1,R,res));
%setting mass to 1 for now
end

