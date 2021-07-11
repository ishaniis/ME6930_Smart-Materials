t=all.t(time_step+1); 

if time_step==0
   parameters.beta=0;
   %t_delta=0;
else
   % t_delta=all.t(time_step+1)-all.t(time_step);
end

%     
% 
% 
% if beta==0
%     beta_dissipation=0;
% else
%     beta_dissipation=beta/t_delta;
% end

if benchmark == 1
    z = z_rand(1:ne,1); %round(rand(ne,1)); %randi(2,ne,1)-1; %z_rand(1:ne,1); %z0;
end;







fprintf('time step: %d of %d \n', time_step, numel(all.t))

%initial energy
[e, eStructure]=energy(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters);
fprintf(' energy = %d (initial u, initial z)\n',e);

if visualization>=3
    y=x+u; fig=figure_counter+1; visualize_memory; 
    mtit(strcat('time step=', num2str(time_step),', initial u for given z, energy=',num2str(e)))
end

%minimized energy over u for given z
[e, u,EXITFLAG_zFixed, OUTPUT_zFixed] = minimization_energy_u_and_zFixed(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,nodes,z0,iedges,parameters);
fprintf(' energy = %d (u optimized), iterations=%d, function evaluations=%d \n ',e,OUTPUT_zFixed.iterations,OUTPUT_zFixed.funcCount);  
[e, eStructure]=energy(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters);

if visualization>=3
    y=x+u; fig=figure_counter+2; visualize_memory; 
    mtit(strcat('time step=', num2str(time_step),', optimal u for given z, energy=',num2str(e)))  
end

fprintf('\n');

if time_step==0
   parameters.beta=beta;
end

%minimized energy including z (explicitly)
fprintf(' minimization: explicit z method \n');
[e, u, ~, OUTPUT_zExplicit] = minimization_energy_u_and_zExplicit(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,nodes,z0,iedges,parameters);
fprintf(' energy = %d (u optimized), iterations=%d, function evaluations=%d \n ',e,OUTPUT_zExplicit.iterations,OUTPUT_zExplicit.funcCount);  
[e, z, eStructure] = energy_u_and_zExplicit(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters); 


%only for testing
[e, eStructure]=energy(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters);

if visualization>=0
    %stress
    Sigma=astam(z,eStructure.Sigma1)+astam(-z+1,eStructure.Sigma2);
    SigmaAverage=sum(Sigma,3)/size(Sigma,3);
    SigmaAverageNorm=norm(SigmaAverage);
    SigmaNorm=amnorm(Sigma,2);
    SigmaNormAverage=sum(SigmaNorm)/size(Sigma,3);

    %strain
    E=eStructure.E;
    EAverage=sum(E,3)/size(E,3);
    EAverageNorm=norm(EAverage);
    ENorm=amnorm(E,2);
    ENormAverage=sum(ENorm)/size(E,3);   
    
    %VFMV1
    VFMV1 = sum(z)/ne; %ne = number of elements
end

fprintf('\n');

if 0 
fprintf('minimization: continuous z method \n');
[e, u, z, ~, OUTPUT] = minimization_energy_u_and_zContinuous(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,bounds_decrease,nodes);
fprintf('energy = %d (u optimized), iterations=%d, function evaluations=%d \n ',e,OUTPUT_zFixed.iterations,OUTPUT_zFixed.funcCount);  
[e, z, phi1, phi2, e_density, detF] = energy_u_and_zExplicit(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,bounds_decrease); 
y=x+u; fig=figure_counter+5; visualize_memory; mtit(strcat('optimal u an z (continuous), energy=',num2str(e)))  

fprintf('\n');
end

if 0
fprintf('minimization: zig zag \n',i);
%fprintf('setting z=z_ini and computing u from it \n',i); 

z=z_oscilating; 
fprintf('initial u generated \n');
[e, u_init,EXITFLAG_zFixed, OUTPUT_zFixed] = minimization_energy_u_and_zFixed(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,nodes);
fprintf('energy = %d (u optimized), iterations=%d, function evaluations=%d \n',e,OUTPUT_zFixed.iterations,OUTPUT_zFixed.funcCount);  

z=z_oscilating;
u=u_init;
for i=0:iterations
    fprintf('iteration=%d: \n',i);

    [~, phi1, phi2]=energy_u_and_z(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas);
    z = minimization_z(phi1,phi2,bounds_decrease); 
    e=energy_u_and_z(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas);
    fprintf('energy = %d (z optimized) \n',e);

    [e, u,EXITFLAG_zFixed, OUTPUT_zFixed] = minimization_energy_u_and_zFixed(u_init,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,nodes);
    fprintf('energy = %d (u optimized), iterations=%d, function evaluations=%d \n',e,OUTPUT_zFixed.iterations,OUTPUT_zFixed.funcCount);  
    [e, phi1, phi2, e_density, detF]=energy_u_and_z(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas);   
    y=x+u; fig=figure_counter+10+i; visualize_memory; mtit(strcat('optimal u an z (zigzag method), energy=',num2str(e)))      

    %fprintf('pause, press a key \n'); pause

end
end



