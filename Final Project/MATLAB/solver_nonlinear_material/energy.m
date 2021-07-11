function [e, eStructure] = energy(u,z,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,areas,z0,iedges,parameters)

if nargout==1
    [F, cofFsurfnormal] = evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges);    
    e = energy_F_and_z(F,cofFsurfnormal,z,z0,areas,iedges,parameters,F1inv,F2inv);
    
else
    [F, cofFsurfnormal, C, detF, detC, cofC, Sigma1, Sigma2, E]= evaluate_fields(u,x,elems2nodes,dphi_3DmatrixT,F1inv,F2inv,parameters,iedges);
    
    [e, eStructure] = energy_F_and_z(F,cofFsurfnormal,z,z0,areas,iedges,parameters,F1inv,F2inv);
    eStructure.cofC=cofC;
    eStructure.detC=detC;
    eStructure.F=F;   
    eStructure.detF=detF; 
    eStructure.Sigma1=Sigma1;
    eStructure.Sigma2=Sigma2;
    eStructure.E=E;
    
end
end

