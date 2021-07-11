function F = gradientOfVector(y,elems2nodes,dphi_3DmatrixT)
  
y1=y(:,1); y2=y(:,2); u_3Dmatrix=[conv_ma2av(y1(elems2nodes)) conv_ma2av(y2(elems2nodes))];

F=amtam(u_3Dmatrix,dphi_3DmatrixT);

end

