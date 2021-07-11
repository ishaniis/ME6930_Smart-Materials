alpha_gradient=1;
[edge2nodes, edge2elems, elem2edges, node2edges]=getEdges(elems2nodes);
edge2vector=x(edge2nodes(:,2),:)-x(edge2nodes(:,1),:);
edge2size=sqrt(sum(edge2vector.^2,2));  %edges sizes
ind=(edge2elems(:,2)~=0);
iedge2elems=edge2elems(ind,:);  %internal edges
iedge2size=edge2size(ind);      %internal edges sizes

z_iedgejump=abs(z(iedge2elems(:,2))-z(iedge2elems(:,1))); 
e=iedge2size'*z_iedgejump; 
e=alpha_gradient*e;
