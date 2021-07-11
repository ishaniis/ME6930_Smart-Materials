function [coordinates,elements,edge2nodesLeft,edge2nodesRight]= rectangular_mesh_from_pde_toolbox(xmin,xmax,ymin,ymax,level)

Lx=xmax-xmin;
Ly=ymax-ymin;

h=min(Lx,Ly)/2;   %level 0 mesh size
h=h/(2^(level));  %refining mesh size


rect1 = [3     
    4
    xmin
    xmax
    xmax
    xmin
    ymax
    ymax
    ymin
    ymin];

% Combine the shapes into one matrix
gd = [rect1];

% Give names for the three shapes
ns = char('rect1');
ns = ns';

% Specify the union of the rectangle and C1, and subtract C2
sf = 'rect1';

[dl,bt] = decsg(gd,sf,ns); % combines the basic shapes using the set formula

[p,e,t]=initmesh(dl,'Hmax',h);

for i=1:0
    [p,e,t] = refinemesh(dl,p,e,t); 
end



%transfering to our structures

elements=t(1:3,:)';
coordinates=p';

figure(1)
subplot(2,1,1)
pdegplot(dl,'EdgeLabels','on'); axis equal; axis off
title('boundary edges')

subplot(2,1,2)
pdemesh(p,e,t); axis equal; axis off
title('triangulation')



%applyBoundaryCondition(dl,'edge',2,'u',0);
%applyBoundaryCondition(dl,'edge',[1,4],'g',1,'q',eye(2));

edge2nodesLeft=e(1:2,e(5,:)==4)';
edge2nodesRight=e(1:2,e(5,:)==2)';

end


