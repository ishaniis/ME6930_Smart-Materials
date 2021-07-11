function A_3Dmatrix_finer=prolongate_3Dmatrix(A_3Dmatrix,elems2nodes,edge2nodes)

nnodes_finer=max(max(elems2nodes))+size(edge2nodes,1);

A_3Dmatrix_finer=zeros(size(A_3Dmatrix,1),size(A_3Dmatrix,2),nnodes_finer);
for k=1:size(A_3Dmatrix,1)
    for l=1:size(A_3Dmatrix,2)
        A_kl_finer=prolongate((squeeze(A_3Dmatrix(k,l,:))),elems2nodes,edge2nodes);
        A_3Dmatrix_finer(k,l,:)=A_kl_finer;  
    end
end
end



