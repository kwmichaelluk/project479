function visual3d(x,y,z,X,Y,Z,ff)
%x,y,z - vectors that determine nodal points
%X,Y,Z - 3D arrays of coordinates x,y,z inside the element
%ff - 3D array that contains function values inside the element

figure;
hold on;

%nodes
plot3(x,y,z,'ko','markerfacecolor','k');

%edges
plot3([x(1:4) x(1)],[y(1:4) y(1)],[z(1:4) z(1)],'k-');
plot3([x(5:8) x(5)],[y(5:8) y(5)],[z(5:8) z(5)],'k-');
plot3([x(2) x(6)],[y(2) y(6)],[z(2) z(6)],'k-');
plot3([x(3) x(7)],[y(3) y(7)],[z(3) z(7)],'k-');
plot3([x(4) x(8)],[y(4) y(8)],[z(4) z(8)],'k-');
plot3([x(1) x(5)],[y(1) y(5)],[z(1) z(5)],'k-');
view(-116,16);
xlabel('x','fontsize',18);
ylabel('y','fontsize',18);
zlabel('z','fontsize',18);

%faces
surf(X(:,:,1),Y(:,:,1),Z(:,:,1),ff(:,:,1),'edgecolor','none','facealpha',0.5);
surf(X(:,:,end),Y(:,:,end),Z(:,:,end),ff(:,:,end),'edgecolor','none','facealpha',0.5);

X2(:,:)=X(:,1,:);
Y2(:,:)=Y(:,1,:);
Z2(:,:)=Z(:,1,:);
ff2(:,:)=ff(:,1,:);

surf(X2,Y2,Z2,ff2,'edgecolor','none','facealpha',0.5);

X2(:,:)=X(:,end,:);
Y2(:,:)=Y(:,end,:);
Z2(:,:)=Z(:,end,:);
ff2(:,:)=ff(:,end,:);

surf(X2,Y2,Z2,ff2,'edgecolor','none','facealpha',0.5);


X2(:,:)=X(1,:,:);
Y2(:,:)=Y(1,:,:);
Z2(:,:)=Z(1,:,:);
ff2(:,:)=ff(1,:,:);

surf(X2,Y2,Z2,ff2,'edgecolor','none','facealpha',0.5);

X2(:,:)=X(end,:,:);
Y2(:,:)=Y(end,:,:);
Z2(:,:)=Z(end,:,:);
ff2(:,:)=ff(end,:,:);

surf(X2,Y2,Z2,ff2,'edgecolor','none','facealpha',0.5);


end