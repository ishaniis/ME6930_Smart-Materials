function show_edge_constant_frame(edgeValue,nodes2coord,edge2nodes,nodalDisplacement)

if (nargin==4)     
    if norm(nodalDisplacement)==0
       factor=1;
    else
       factor =10^(-round(log10(max(max(nodalDisplacement)))));
    end   
else
    nodalDisplacement=zeros(size(nodes2coord));
end

nodes2coord=nodes2coord+factor*nodalDisplacement;


hold on
f=[1 2 3];   
for i=1:size(edge2nodes)
    edge=edge2nodes(i,:);
    v=nodes2coord(edge,:);
    v=[v; sum(v,1)/2];
    c=[edgeValue(i); edgeValue(i); edgeValue(i)];
    
    patch('Faces',f,'Vertices',v,'FaceVertexCData',c,...
    'EdgeColor','flat','FaceColor','none','LineWidth',2);
    
end
hold off