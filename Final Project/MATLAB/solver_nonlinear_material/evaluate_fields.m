function [F, cofFsurfnormal, C, detF, detC, cofC, Sigma1, Sigma2, E] = evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges)
%x denotes nodes2coords

y=x+u;    %deformation

F = gradientOfVector(y,elems2nodes,dphi_3DmatrixT);      %deformation gradient tensor y_grad_all (denoted as F)

anormal=reshape(iedges.normal',1,2,size(iedges.normal,1));
Fsurf=amtam(amt(F(:,:,iedges.elems(:,1))),copy_matrix_to_3Dmatrix(eye(2),size(iedges.normal,1))-amtam(anormal,anormal));
%Fsurf2=amtam(amt(F(:,:,iedge2elems(:,2))),copy_matrix_to_3Dmatrix(eye(2),size(iedge2normal,1))-amtam(av,av))
%cofFsurf=zeros(2,2,size(iedge2normal,1));

%cofactor of sufrace deformation tensor
cofFsurf(1,1,:)=Fsurf(2,2,:);
cofFsurf(1,2,:)=-Fsurf(2,1,:);
cofFsurf(2,1,:)=-Fsurf(1,2,:);
cofFsurf(2,2,:)= Fsurf(1,1,:);

cofFsurfnormal=squeeze(amtam(amt(anormal),cofFsurf))';

C=amtam(F,F);  %C=F^T*F

if (nargout>=4)   
    detF=amdet(F)'; 
    detC=amdet(C)'; %determinant of C
    
    cofC(1,1,:)=C(2,2,:);
    cofC(2,2,:)=C(1,1,:);
    cofC(1,2,:)=-C(2,1,:);
    cofC(2,1,:)=-C(1,2,:);

    Sigma1=parameters.alpha*repmat(F1inv*F1inv',[1 1 size(dphi_3DmatrixT,3)])+parameters.delta1*cofC-(parameters.delta2/2)*astam(1./detC,cofC);
    Sigma2=parameters.alpha*repmat(F2inv*F2inv',[1 1 size(dphi_3DmatrixT,3)])+parameters.delta1*cofC-(parameters.delta2/2)*astam(1./detC,cofC); 

    I=copy_matrix_to_3Dmatrix(eye(2),size(C,3));

    E=(C-I)/2;       %Green-Lagrangian strain tensor
end


 
