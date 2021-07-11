function E = evaluate_strain_E(u,x,elems2nodes,dphi_3Dmatrix)

[I,~] = generate_F1_all_F2_all(0,0,size(elems2nodes,1));

y=x+u; 

F = gradientOfVector(y,elems2nodes,dphi_3Dmatrix);      %deformation gradient tensor y_grad_all (denoted as F)

E=amtam(F,F)-I;

end

