function  elements2matrix3D=evaluate_element_average_matrix3D(matrix3D,elems2nodes,which_elements_number)
        
dummy=matrix3D(:,:,elems2nodes(:,1));
for i=2:size(elems2nodes,2)
    dummy=dummy+matrix3D(:,:,elems2nodes(:,i));
end
elements2matrix3D=dummy/size(elems2nodes,2);

if nargin==3
   elements2matrix3D=elements2matrix3D(which_elements_number,:);
end

   
end
