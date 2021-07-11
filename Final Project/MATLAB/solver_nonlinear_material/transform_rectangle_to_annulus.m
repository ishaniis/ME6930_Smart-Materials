function [u,y]=transform_rectangle_to_annulus(x,r)
u=x(:,1); v=x(:,2);

if abs(r)==Inf
    y=0*x;
else
    b=max(v);
    radius=r+b-v;
    angle=u./radius;
    y=[radius.*cos(angle+(3/2)*pi) radius.*sin(angle+(3/2)*pi)+(r+b)];
end

u=y-x;