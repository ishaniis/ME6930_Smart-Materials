function [K,areas,K_3Dmatrix,dphi_3Dmatrix]=stifness_matrixP1_2D(elements,coordinates)
NE=size(elements,1); %number of elements
DIM=size(coordinates,2); %problem dimension

%particular part for a given element in a given dimension
NLB=3; %number of local basic functions, it must be known!
coord=zeros(DIM,NLB,NE);
for d=1:DIM
    for i=1:NLB
        coord(d,i,:)=coordinates(elements(:,i),d);
    end
end   
IP=[1/3;1/3];
[dphi_3Dmatrix,jac_3Dmatrix] = phider(coord,IP,'P1'); %integration rule, it must be known! 
dphi_3Dmatrix = squeeze(dphi_3Dmatrix); 
areas=abs(squeeze(jac_3Dmatrix))/factorial(DIM);
Y=reshape(repmat(elements,1,NLB)',NLB,NLB,NE);

%copy this part for a creation of a new element
X=permute(Y,[2 1 3]);

K_3Dmatrix=astam(areas',amtam(dphi_3Dmatrix,dphi_3Dmatrix));
K=sparse(X(:),Y(:),K_3Dmatrix(:));  

