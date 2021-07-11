clear all; close all;

add_paths;

epsilon=0.3; %epsilon1=0.00001;  stretching matrices parameter
alpha1=1; 
alpha2=1; 
delta1=1;

parameters.epsilon=epsilon;  
parameters.alpha1=alpha1;
parameters.alpha2=alpha2;
parameters.delta1=delta1;
parameters.delta2=2*alpha1+2*alpha2+2*delta1;  %in 2D





epsilon=0;
F=generate_Fperturbed(1,epsilon,1);
Finv=inv(F); 
I=eye(2); detI=det(I); 



[X,Y] = meshgrid(0.8:0.02:1.5, 0.8:0.02:1.5);


for i=1:size(X,1)
    for j=1:size(X,1)          
        vector=[X(i,j) Y(i,j)];
        C=parametrize_GLplus(vector);      
        detC=det(C); 

        
        
        W(i,j) = material_law(C,detC,parameters,Finv);     
        %W(i,j)=norm(vector);
    end
end

W_I = material_law(I,detI,parameters,Finv);     

Imin=find(W==min(min(W)));



figure(100)

hold on
scatter3(1,1,W_I,30,'filled','MarkerEdgeColor','k');
scatter3(X(Imin),Y(Imin),W(Imin),[],'filled','MarkerEdgeColor','r');
scatter3(1,1,0,30,'filled','MarkerEdgeColor','k');
scatter3(X(Imin),Y(Imin),0,[],'filled','MarkerEdgeColor','r');

contourf(X,Y,W)
mesh(X,Y,W)
hold off
view(78,50)
legend('C=I','C minimal energy')






