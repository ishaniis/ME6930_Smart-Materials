function [e, eStructure] = energy_F_and_z(F,cofFsurfnormal,z,z0,areas,iedges,parameters,F1inv,F2inv)

%bulk energy (defined on triangles)
C=amtam(F,F);  %C=F^T*F
W1=material_law(C,parameters,F1inv);
W2=material_law(C,parameters,F2inv);
e_densityArea_partBulkEnergy=z.*W1+(1-z).*W2;

%dissipation (defined on triangles)
e_densityArea_partDissipation=parameters.beta*abs(z-z0);

zJump=abs(z(iedges.elems(:,2))-z(iedges.elems(:,1)));
%interfacial energy (defined on internal edges)
e_densityEdge_partInterfacialEnergy=parameters.alphaI*zJump;  

%surface energy (defined on internal edges)
e_densityEdge_partSurfaceEnergy=zJump.*(parameters.alphaS*sqrt(sum(cofFsurfnormal.^2,2)));
           
%values
e_valueArea_partBulkEnergy=dot(areas,e_densityArea_partBulkEnergy);
e_valueArea_partDissipation=dot(areas,e_densityArea_partDissipation);
e_valueEdge_partInterfacialEnergy=dot(iedges.size,e_densityEdge_partInterfacialEnergy);
e_valueEdge_partSurfaceEnergy=dot(iedges.size,e_densityEdge_partSurfaceEnergy);


e_densityArea=e_densityArea_partBulkEnergy+e_densityArea_partDissipation;
e_valueArea=e_valueArea_partBulkEnergy+e_valueArea_partDissipation;

e_densityEdge=e_densityEdge_partInterfacialEnergy+e_densityEdge_partSurfaceEnergy;
e_valueEdge=e_valueEdge_partInterfacialEnergy+e_valueEdge_partSurfaceEnergy;

e=e_valueArea+e_valueEdge;

if nargout==2
    eStructure = struct('value',e, ...
                       'valueArea_partBulkEnergy', e_valueArea_partBulkEnergy, ...
                       'valueArea_partDissipation',  e_valueArea_partDissipation , ...
                       'valueEdge_partInterfacialEnergy', e_valueEdge_partInterfacialEnergy, ...
                       'valueEdge_partSurfaceEnergy', e_valueEdge_partSurfaceEnergy, ...
                       'densityArea',e_densityArea, ...
                       'densityEdge',e_densityEdge, ...
                       'densityArea_partBulkEnergy',e_densityArea_partBulkEnergy, ...
                       'densityArea_partDissipation',e_densityArea_partDissipation, ...
                       'densityEdge_partInterfacialEnergy',e_densityEdge_partInterfacialEnergy,...
                       'densityEdge_partSurfaceEnergy',e_densityEdge_partSurfaceEnergy,...
                       'C',C);
end
                       

end


