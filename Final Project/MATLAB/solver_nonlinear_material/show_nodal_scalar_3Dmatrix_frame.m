function show_nodal_scalar_3Dmatrix_frame(A_all,nodes2coord,elems2nodes,nodalDisplacement)

switch nargin, 
    case 3,
        nodalDisplacement=0*nodes2coord;
    case {0, 1, 2}
        fprintf('missing parameters')
end

for k=1:2
    for l=1:2
        subplot(2,2,(k-1)*2+l)
        A_kl=(squeeze(A_all(k,l,:)));
        show_nodal_scalar_frame(A_kl',nodes2coord,elems2nodes,nodalDisplacement) 
        view(-20,62)
    end
end

end
