x1_length=x1Max-x1Min;
x2_length=x2Max-x2Min;

r_in=4;
r_out=5;

phi_start=0;
phi_end=x1_length/2/r_in;

figure(100)
hold on
for i=1:size(x,1)
    phi=x(i,1)/2/r_in;
    r=r_in+(r_out-r_in)*(x(i,2)-x2Max)/(x2Max-x1Min);
    plot(r*cos(-phi),r*sin(-phi),'x');
end
hold off


