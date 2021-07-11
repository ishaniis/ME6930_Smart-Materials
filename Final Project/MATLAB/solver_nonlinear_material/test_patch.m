add_paths

elem2nodes=x;

v = [0 0; 1 0; 1 1];
f = [1 2 3];
figure
patch('Faces',f,'Vertices',v,...
    'EdgeColor','green','FaceColor','none','LineWidth',2);


v = [2 0; 3 0; 3 1];
f = [1 2 3];
c = [1 0 0; % red
    0 1 0; % green
    0 0 1]; % blue
c=[3; 4; 5]
figure
patch('Faces',f,'Vertices',v,'FaceVertexCData',c,...
    'EdgeColor','flat','FaceColor','none','LineWidth',2);
colorbar

[edge2nodes, edge2elems, elem2edges, node2edges]=getEdges(elems2nodes);
edge2vector=x(edge2nodes(:,2),:)-x(edge2nodes(:,1),:);
edge2size=sqrt(sum(edge2vector.^2,2));  %edges sizes
edge2normal=[edge2vector(:,2) -edge2vector(:,1)];
edge2normal=edge2normal./[edge2size edge2size];

ind=(edge2elems(:,2)~=0);
iedge2elems=edge2elems(ind,:);  %internal edges
iedge2size=edge2size(ind);      %internal edges sizes
iedge2normal=edge2normal(ind,:); %internal edges normals 

show_edge_constant_frame(1:size(edge2nodes,1),x,elems2nodes,elem2edges)



hold on
for i=1:size(elem2edges)
    elem=elems2nodes(i,:);
    v=x(elem,:);
    f=[1 2 3];   
    c=elem2edges(i,:)';
    
    patch('Faces',f,'Vertices',v,'FaceVertexCData',c,...
    'EdgeColor','flat','FaceColor','none','LineWidth',2);
    
end
hold off
colorbar

    

