function initialize_position(S,r,n)
    Height = S.height;
    W = S.width;
    resolution = S.resolution;
    
    xstart = -W/2 + 1*r;
    xend = W/2 - 1*r;
    ystart = Height/2 - 2*r;
    yend = -Height/2 + 2*r;
    xinterval = 2.1*r;
    yinterval = 2.1*r;
    xnumber = floor((xend - xstart)/xinterval);
    ynumber = floor((ystart - yend)/yinterval);

    %create n number of diskes
    for i = 1:n
        x = xstart + (mod((i-1),xnumber)+1)*xinterval;
        y = ystart - floor((i-1)/ynumber)*yinterval;
        theta = 2*pi*rand;
        vx = 10*rand-5;
        vy = 10*rand-5;
        angle = rand;
        omega = 0;
        createDisk(S,r,x,y,vx,vy,angle,omega,resolution);
        %create a disk with random velocity at a position(x,y)
    end