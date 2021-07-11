add_paths

%concrete values
x=[0 0; 1 0; 1 1; 0 1];
elem=[1 2 3 4];
epsilon=-0.3;

%symbolic setup
syms epsilons xs1 xs2
assume(epsilons,'real')
xs = sym('xs', [1 2]);                                               %reference position
us=xs*[0 epsilons; 0 0]'                                             %displacement
Du=[gradient(us(:,1),[xs1 xs2]) gradient(us(:,2),[xs1 xs2])]';       %displacement gradient
ys=xs+us                                                             %deformed position
F=eye(2)+Du                                                          %deformation gradient
C=F'*F                                                               %right Cauchy deformation tensor 
E=(1/2)*(Du+Du'+Du'*Du)                                              %Lagrangian finite strain tensor (from displacement)
E=(1/2)*(C-eye(2))                                                   %Lagrangian finite strain tensor (from deformation)

%substitution
for i=1:size(x,1)
     y(i,:)=subs(subs(ys,xs,{x(i,:)}),epsilons,epsilon);
end
 
%visualization
figure(66)
subplot(1,2,1)
show_mesh(elem,x)
axis image
title('reference configuration') 

subplot(1,2,2)
show_mesh(elem,y)
axis image
title('deformed configuration') 







