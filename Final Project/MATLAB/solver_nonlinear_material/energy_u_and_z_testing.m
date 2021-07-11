function [e, phi1, phi2, e_density, detF] = energy_u_and_z_testing(u,z,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv,areas)

if nargout<=4
    [phi1, phi2] = energy_u_and_z_part1_testing(u,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv);
else
    [phi1, phi2, detF] = energy_u_and_z_part1_testing(u,x,elems2nodes,dphi_3Dmatrix,F1inv,F2inv);
end
    
[e, e_density] = energy_u_and_z_part2(z,areas,phi1,phi2);

end

