clear all
close all

figures_on=1;

level=1;

refinement_extra=2;

add_paths

%coarse mesh
x=[0 0; 1 0; 0 1; 1 1];
elems2nodes=[1 2 3; 2 4 3];

%%%%% this value only for testing, later it will be optimized         
A=[1 1; 1 2; 1 2; 1 1];   %coefficients of A in nodal points
if 0
    A=[0 0; 0 0; 1 1; 0 0];
end
%%%%%%%%%%%%%%%%%%%%

A_all=zeros(2,2,size(A,1)); A_all(1,1,:)=A(:,1); A_all(1,2,:)=A(:,2); A_all(2,1,:)=A(:,2); A_all(2,2,:)=-A(:,1);  %assembling A

%prolongation to the actual mesh         
for i=1:level
    
    %projection of A_all on finer mesh
    if 1
        [~, edges2nodes] = get_edges(elems2nodes); 
        A_all=prolongate_3Dmatrix(A_all,elems2nodes,edges2nodes);
    end
    %creating finer mesh
    [x,elems2nodes]=refinement_uniform_2D(x,elems2nodes);
    
    
    
    %[A_all,x,elems2nodes]=prolongate_3Dmatrix(A_all,x,elems2nodes);
end
        
%displacement u(x,y)=(0,x*b) on the actual mesh
b=-0.1;  %parameter
u=[zeros(size(x(:,1))), b*x(:,1)];
y=x+u;   

figure(1)
subplot(1,2,1); show_mesh(elems2nodes,x); axis square
subplot(1,2,2); show_mesh(elems2nodes,y); axis square

[K,areas,K_3Dmatrix,dphi_3Dmatrix]=stifness_matrixP1_2D(elems2nodes,x);
dphi_3DmatrixT=amt(dphi_3Dmatrix);

u_grad_all = gradientOfVector(u,elems2nodes,dphi_3DmatrixT); %displacement gradient tensor

F_all = gradientOfVector(y,elems2nodes,dphi_3DmatrixT);      %deformation gradient tensor y_grad_all (denoted as F)

C_all=amtam(F_all,amt(F_all));     %right Cauchy tensor F'*F

%%%%%%%%%%%

%computing Cp (=exponential of A)
Cp_all=compute_3Dmatrix_exponential(A_all);

%prolongate A to a finer mesh
elemsNumbersFiner2Coarse=(1:size(elems2nodes,1))';

%projection of A_all on finer mesh
[~, edges2nodes] = get_edges(elems2nodes); A_all_finer=prolongate_3Dmatrix(A_all,elems2nodes,edges2nodes);
%creating finer mesh
[x_finer,elems2nodes_finer,~,elemsNumbersFiner2Coarse]=refinement_uniform_2D(x,elems2nodes,[],elemsNumbersFiner2Coarse);
    
%[A_all_finer,x_finer,elems2nodes_finer,elemsNumbersFiner2Coarse]=prolongate_3Dmatrix(A_all,x,elems2nodes,elemsNumbersFiner2Coarse);

for i=1:refinement_extra   %FIX THIS!!!!
    %projection of A_all on finer mesh
    [~, edges2nodes] = get_edges(elems2nodes_finer); A_all_finer=prolongate_3Dmatrix(A_all_finer,elems2nodes_finer,edges2nodes);
    %creating finer mesh
    [x_finer,elems2nodes_finer,~,elemsNumbersFiner2Coarse]=refinement_uniform_2D(x_finer,elems2nodes_finer,[],elemsNumbersFiner2Coarse);
    
    %[A_all_finer,x_finer,elems2nodes_finer,elemsNumbersFiner2Coarse]=prolongate_3Dmatrix(A_all_finer,x_finer,elems2nodes_finer,elemsNumbersFiner2Coarse);
end
[K_finer,areas_finer,K_3Dmatrix_finer,dphi_3Dmatrix_finer]=stifness_matrixP1_2D(elems2nodes_finer,x_finer);

%computing C (=exponential of A) on a finer mesh
Cp_all_finer=compute_3Dmatrix_exponential(A_all_finer);

%%%%%%% energy in Cp: from gradient
energy_Cp_grad= (1/2)* ...
          (  (squeeze(Cp_all_finer(1,1,:)))'*K_finer*squeeze(Cp_all_finer(1,1,:))+ ...
                   (squeeze(Cp_all_finer(1,2,:)))'*K_finer*squeeze(Cp_all_finer(1,2,:))+...
                   (squeeze(Cp_all_finer(2,1,:)))'*K_finer*squeeze(Cp_all_finer(2,1,:))+...
                   (squeeze(Cp_all_finer(2,2,:)))'*K_finer*squeeze(Cp_all_finer(2,2,:)) );
               
fprintf('energy in Cp - grad part using %d nodes = %d \n', size(Cp_all_finer,3),energy_Cp_grad)
               
 
energy_Cp_grad_elementwise= (1/2)* ...
 ( quadratic_form_elementwise((squeeze(Cp_all_finer(1,1,:))),elems2nodes_finer,K_3Dmatrix_finer)+ ...
   quadratic_form_elementwise((squeeze(Cp_all_finer(1,2,:))),elems2nodes_finer,K_3Dmatrix_finer)+ ...
   quadratic_form_elementwise((squeeze(Cp_all_finer(2,1,:))),elems2nodes_finer,K_3Dmatrix_finer)+ ...
   quadratic_form_elementwise((squeeze(Cp_all_finer(2,2,:))),elems2nodes_finer,K_3Dmatrix_finer) );
                  
 energy_Cp_grad_finer_density=energy_Cp_grad_elementwise./areas_finer;

 
 %%%%%%% energy in Cp: elastic
 Cp_all_finer_inverse=aminv(Cp_all_finer);
 
 Cp_inverse_all_distribution=zeros(2,2,size(elems2nodes,1));
 Cp_inverse_all_finer_distribution=astam (reshape(areas_finer,1,1,size(areas_finer,1)),evaluate_element_average_matrix3D(Cp_all_finer_inverse,elems2nodes_finer));
 for i=1:size(elems2nodes,1)
    I=find(elemsNumbersFiner2Coarse==i);
    Cp_inverse_all_distribution(:,:,i)=sum(Cp_inverse_all_finer_distribution(:,:,I),3);
       
    arg_distribution_finer(:,:,I)=amt(smamt((C_all(:,:,i))',amt(Cp_inverse_all_finer_distribution(:,:,I))));
 end
 energy_Cp_elast_density=squeeze(arg_distribution_finer(1,1,:)+arg_distribution_finer(2,2,:))./areas_finer; %this gives a trace
 
 arg_distribution=amtam(amt(Cp_inverse_all_distribution),C_all);
 
 energy_Cp_elast=trace(sum(arg_distribution,3));
 
 fprintf('energy in Cp - elas part using %d nodes = %d \n', size(Cp_all_finer,3),energy_Cp_elast)
 
 
 %%%%%%%%%%%%%
 
 
 
 if figures_on  
    figure(10)
    show_nodal_scalar_3Dmatrix_frame(A_all,x,elems2nodes,u);
    subplot(2,2,1); title('components of matrix A (P^1 function)')

    figure(11)
    show_nodal_scalar_3Dmatrix_frame(Cp_all,x,elems2nodes,u);
    subplot(2,2,1); title('components of matrix C_p (P^1 interpolation on the same mesh)')
    
    figure(12)
    show_nodal_scalar_3Dmatrix_frame(Cp_all_finer,x_finer,elems2nodes_finer);
    subplot(2,2,1); title('components of matrix C_p(P^1 interpolation on the finer mesh)')
    
    figure(13)
    show_constant_scalar_frame(energy_Cp_grad_finer_density,x_finer,elems2nodes_finer)
    title('minimization of C_p - energy density of (1/2)|\nablaC_p|^2 on the finer mesh')
    
    figure(14)
    show_constant_scalar_frame(energy_Cp_elast_density,x_finer,elems2nodes_finer)
    title('minimization of C_p - energy density of tr(C_p^{-1}(\nablay)^T \nablay)) on the finer mesh')
 end
 
 





