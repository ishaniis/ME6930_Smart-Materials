

load 
close all

z0=0*z;
z0=randi(2,size(z))-1;



parameters.beta=0.4;
parameters.alphaI=0.01;


[F,cofFsurfnormal,C] = evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges);

C=astam(100*rand(size(z)),C);

W1=material_law(C,parameters,F1inv);
W2=material_law(C,parameters,F2inv);

tic
z= minimization_z_old(W1,W2,cofFsurfnormal,z0,areas,iedges,parameters,bounds_decrease );
toc
h=figure; visualize_memory; movegui(h,'west')

tic
z= minimization_z(W1,W2,cofFsurfnormal,z0,areas,iedges,parameters);
toc
h=figure; visualize_memory; movegui(h,'east')
