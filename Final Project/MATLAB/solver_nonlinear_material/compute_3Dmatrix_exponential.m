function Cp_all=compute_3Dmatrix_exponential(A_all)

    Cp_all=zeros(2,2,size(A_all,3));
    for i=1:size(A_all,3)
        Cp_all(:,:,i)=expm(A_all(:,:,i));
    end

end