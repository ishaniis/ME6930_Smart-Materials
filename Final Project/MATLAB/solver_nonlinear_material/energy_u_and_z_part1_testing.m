function [phi1, phi2, detF, F, angleF] = energy_u_and_z_part1_testing(u,x,elems2nodes,dphi_3DmatrixT,C1,C2,p)
%x denotes nodes2coords

y=x+u;   

F = gradientOfVector(y,elems2nodes,dphi_3DmatrixT);      %deformation gradient tensor y_grad_all (denoted as F)

phi1=amnorm(F-C1,p); 
phi2=amnorm(F-C2,p);

%playing with functional - start
y1=y(:,1); y2=y(:,2); y_3Dmatrix=[conv_ma2av(y1(elems2nodes)) conv_ma2av(y2(elems2nodes))];
F=amtam(y_3Dmatrix,dphi_3DmatrixT);
phi11=sqrt(am_InnerProduct_am(F,F));    %OK

y_3DmatrixT=amt(y_3Dmatrix);
dphi_3Dmatrix=amt(dphi_3DmatrixT);

phi12=sqrt(am_InnerProduct_am(amtam(dphi_3Dmatrix,dphi_3Dmatrix),amtam(y_3DmatrixT,y_3DmatrixT)));

%playing with functional - end

if 0
%playing with gradient - start
u1=u(:,1); u2=u(:,2); u_3Dmatrix=[conv_ma2av(u1(elems2nodes)) conv_ma2av(u2(elems2nodes))];

u_grad_all=amtam(u_3Dmatrix,dphi_3DmatrixT);
for i=1:size(u,1)
    for j=1:2
        uOnes=zeros(size(u,1),2);
        uOnes(i,j)=1;
        
        u1=uOnes(:,1); u2=uOnes(:,2);  
        uOnes_grad_all=amtam([conv_ma2av(u1(elems2nodes)) conv_ma2av(u2(elems2nodes))],dphi_3DmatrixT);    
        
        
    end
end
end

%playing with gradient - end




if nargout>=3
    detF=(amdet(F))';
end

if nargout==5
    %extra fields
    %C_all=amtam(F_all,F_all);     %right Cauchy tensor F'*F
    angleF=angleOfRotationMatrix(F);
    %end of extra fields
end

if 0
    Du=gradientOfVector(u,elems2nodes,dphi_3Dmatrix);  
    pol = polyfit([min(x(:,2)) max(x(:,2))],[volumeFactor -volumeFactor],1);
    w=evaluate_elements_average(elems2nodes,polyval(p,x(:,2)));
    
    e_density=z.*phi1+(1-z).*phi2+detFactor./abs(detF);  %-w.*squeeze(Du(2,2,:));  
end



end

