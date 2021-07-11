function [e_opt, u,EXITFLAG_zFixed, OUTPUT_zFixed] = minimization_energy_u_and_zFixed(u,z,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv,areas,nodes,z0,iedges,parameters)
%input u is an initial displacement matrix satisfying Dirichlet BC! 
%input z is an initial coefficients vector 
%fprintf('optimization of u for fixed z: ');

n=numel(nodes.free)*2;     %number of free nodes in u

vector_u_free=vectorform(u(nodes.free,:));

vector=vector_u_free;
%fprintf('taking initial u from input \n');

e_init=energy_vector_argument_free(vector);
%fprintf('energy (initial)=%d, ',e_init);

%options=optimoptions('fsolve','MaxFunEvals',600)
%optimset('Display','iter','LargeScale','off')

options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','TolFun',1e-10,'MaxFunEvals',1e6);  %'MaxFunEvals',100000,
%vector_opt = fminunc(@energy_vector_argument_free,vector,options);

%lb=lb;
%ub=ub;

[vector_opt, e_opt,EXITFLAG_zFixed, OUTPUT_zFixed] = fminunc(@energy_vector_argument_free,vector,options);
%fprintf('energy (optimized)=%d \n',e_opt);

u(nodes.free,:)=matrixform(vector_opt(1:n));
if isfield(nodes,'periodic')
        u(nodes.periodic(:,2),:)=u(nodes.periodic(:,1),:);    
end
z=vector_opt(n+1:end);

function e=energy_vector_argument_free(vector)
    u_testing=u;
    u_testing(nodes.free,:)=matrixform(vector);
    
    if isfield(nodes,'periodic')
        u_testing(nodes.periodic(:,2),:)=u_testing(nodes.periodic(:,1),:);
    end
    
    e = energy(u_testing,z,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv,areas,z0,iedges,parameters);
    
    if 0
    if e<0
        save
        fprintf('problem with determinant')
        pause
    end
    end
        
end

end

