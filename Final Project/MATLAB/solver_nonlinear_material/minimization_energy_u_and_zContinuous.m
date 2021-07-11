function [e_opt, u, z, EXITFLAG_z, OUTPUT_z] = minimization_energy_u_and_zContinuous(u,z,x,elems2nodes,dphi_3Dmatrix,F1_all,F2_all,areas,bounds_decrease,nodes,p)
%input u is an initial displacement matrix satisfying Dirichlet BC! 
%input z is an initial coefficients vector 

%fprintf('continuous optimization of z: ');

n=numel(nodes.free)*2;     %number of free nodes in u

vector_u_free=vectorform(u(nodes.free,:));
%vector_u_free=0.1*rand(size(vector_u_free));   %initial setup 
%vector_z=rand(size(z));    
vector_z=z;                                      %initial setup 
vector=[vector_u_free; vector_z];
%fprintf('taking initial u and z from input \n');


e_init=energy_vector_argument_free(vector);
%fprintf('energy (initial)=%d, ',e_init);

%options=optimoptions('fsolve','MaxFunEvals',600)
%optimset('Display','iter','LargeScale','off')

options = optimoptions('fmincon','Algorithm','interior-point','Display','off','TolFun',1e-10);  %'MaxFunEvals',10000,
%vector_opt = fminunc(@energy_vector_argument_free,vector,options);

lb=-inf*ones(size(vector));  %inf
ub=inf*ones(size(vector));   %inf

lb(n+1:end)=0+bounds_decrease-eps;
ub(n+1:end)=1-bounds_decrease+eps;

%lb=lb;
%ub=ub;

[vector_opt,e_opt,EXITFLAG_z, OUTPUT_z] = fmincon(@energy_vector_argument_free,vector,[],[],[],[],lb,ub,[],options);
%fprintf('energy (optimized)=%d \n',e_opt);


u(nodes.free,:)=matrixform(vector_opt(1:n));
z=vector_opt(n+1:end);

function e=energy_vector_argument_free(vector)
    u_testing=u;
    u_testing(nodes.free,:)=matrixform(vector(1:n));
    z_testing=vector(n+1:end);
    
    e = energy_u_and_z(u_testing,z_testing,x,elems2nodes,dphi_3Dmatrix,F1_all,F2_all,areas);
    
    if 0
    if e<0
        save
        fprintf('problem with determinant')
        pause
    end
    end
        
end

end

