function angleF_all=angleOfRotationMatrix(F_all)

angleF_all=zeros(size(F_all,3),1);
for i=1:size(F_all,3)
    F=F_all(:,:,i);
    [U,S,V] = svd(F);

    R=U*V';            %rotation
    T=V*S*V';          %translation
    
    %then F=R*U

    angle=asin(R(2,1));
    angleF_all(i)=angle;
end

end
