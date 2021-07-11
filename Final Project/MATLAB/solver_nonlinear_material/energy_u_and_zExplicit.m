function [e, z, eStructure] = energy_u_and_zExplicit(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters,bounds_decrease)

if nargout<=2
     [F,cofFsurfnormal,C] = evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges);
else
    [F, cofFsurfnormal, C, detF, detC, cofC, Sigma1, Sigma2, E] = evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges);
end

%bulk energy preparation
W1=material_law(C,parameters,F1inv);
W2=material_law(C,parameters,F2inv);

%minimization over z
z = minimization_z(W1,W2,cofFsurfnormal,z0,areas,iedges,parameters);  %without gradient z

if nargout<=2
    e = energy_F_and_z(F,cofFsurfnormal,z,z0,areas,iedges,parameters,F1inv,F2inv);
       
else
    [e, eStructure] = energy_F_and_z(F,cofFsurfnormal,z,z0,areas,iedges,parameters,F1inv,F2inv);
    eStructure.F=F;
    eStructure.detF=detF; 
    eStructure.cofC=cofC;
    eStructure.detC=detC;
    eStructure.Sigma1=Sigma1;
    eStructure.Sigma2=Sigma2;
    eStructure.E=E;
end


end

