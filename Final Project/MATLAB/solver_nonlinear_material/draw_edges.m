function draw_edges(edges,coordinates,Zmax,which,format)

if (nargin<5)
    format='k-';
end

if (nargin<4) 
    which=1:size(edges,1);
end

if isempty(which)
    which=1:size(edges,1);
end

if (which==inf) 
   which=1:size(edges,1);
end
   
if (size(which,2)>size(which,1))
    which=which';
end

if (nargin<3)
    Zmax=0;
end

if (nargin>=3)
    if isempty(Zmax)
       Zmax=0;
    end
end



X=[coordinates(edges(which,1),1) coordinates(edges(which,2),1)]';
Y=[coordinates(edges(which,1),2) coordinates(edges(which,2),2)]';


plot3(X,Y,Zmax*ones(size(Y)),format,'LineWidth',0.5)


end
