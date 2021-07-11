function vNodal_finer=prolongate(vNodal,elems2nodes,edge2nodes)
if size(elems2nodes,2)==4
    %prolongates bilinear function defined on rectangles
    vNodal_finer=[vNodal; sum(vNodal(edge2nodes),2)/2; sum(vNodal(elems2nodes),2)/4];
elseif size(elems2nodes,2)==3
    %prolongates linear function defined on triangles
    vNodal_finer=[vNodal; sum(vNodal(edge2nodes),2)/2];
end

