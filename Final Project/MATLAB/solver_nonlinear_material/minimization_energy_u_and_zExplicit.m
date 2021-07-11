function [e_opt, u, EXITFLAG, OUTPUT] = minimization_energy_u_and_zExplicit(u,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv,areas,nodes,z0,iedges,parameters,bounds_decrease)
%input u is an initial displacement (matrix) satisfying Dirichlet BC! 
%fprintf('explicit computation of z: ');

vector=vectorform(u(nodes.free,:)); 
%fprintf('taking initial u from input \n');
%vector=0.1*rand(size(vector)); fprintf('setting random initial u \n');

%e_init=energy_vector_argument_free(vector);
%fprintf('energy (initial)=%d, ',e_init);

%options=optimoptions('fsolve','MaxFunEvals',600)
%optimset('Display','iter','LargeScale','off')
options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','MaxFunEvals',10000,'TolFun',1e-10);

%warning('off','last')
[u_vector_free, e_opt, EXITFLAG, OUTPUT] = fminunc(@energy_vector_argument_free,vector,options);
%fprintf('energy (optimized)=%d \n',e_opt);

u(nodes.free,:)=matrixform(u_vector_free);
if isfield(nodes,'periodic')
        u(nodes.periodic(:,2),:)=u(nodes.periodic(:,1),:);    
end



function e=energy_vector_argument_free(vector)
    u_testing=u;
    u_testing(nodes.free,:)=matrixform(vector);
    if isfield(nodes,'periodic')
        u_testing(nodes.periodic(:,2),:)=u_testing(nodes.periodic(:,1),:);
    end
    
    e = energy_u_and_zExplicit(u_testing,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv,areas,z0,iedges,parameters);
end

end

