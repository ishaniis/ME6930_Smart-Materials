figure;
subplot(1,2,1)
show_mesh(elemsRectangular2nodes,x+[x(:,2)*parameters.epsilon 0*x(:,2)]) 
axis equal; axis off

subplot(1,2,2)
show_mesh(elemsRectangular2nodes,x+[-x(:,2)*parameters.epsilon 0*x(:,2)]) 
axis equal; axis off