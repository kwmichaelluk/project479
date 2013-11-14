function createSphere(Scene,Position,Velocity,mass,Radius,res)
%adding a Disk of random velocity to the scene
%Sphere(X,Y,Z,angle1,angle2,angle3,V,m,r,res)

%V = V_vector(Vx,Vy,Vz,omega1,omega2,omega3);


Scene.adding_body(Sphere(Position,Velocity,mass,Radius,res));
%setting mass to 1 for now
end