function z= minimization_z(W1,W2,cofFsurfnormal,z0,areas,iedges,parameters)

W12=W1-W2; 

Lz=W12+parameters.beta*(1-2*z0);

if (norm([parameters.alphaI parameters.alphaS])==0)    
    value_between=1/2;     
    z=zeros(size(W1));
    z(Lz<0)=1;
    z(Lz==0)=value_between; 
else   
    alphas=parameters.alphaI+parameters.alphaS*sqrt(sum(cofFsurfnormal.^2,2));
    nn=size(areas,1); nie=size(iedges.size,1); 
    
    f=[areas.*Lz; iedges.size.*alphas];

    Asigma=sparse(1:nie,iedges.elems(:,1),ones(nie,1),nie,nn)-sparse(1:nie,iedges.elems(:,2),ones(nie,1),nie,nn);

    A=[Asigma   -eye(nie); ...
      -Asigma   -eye(nie)]; 

    b=zeros(2*nie,1);

    LB=zeros(nn+nie,1);
    UB=ones(nn+nie,1);   

    [zsigma,FVAL,EXITFLAG,OUTPUT,LAMBDA]=linprog(f,A,b,[],[],LB,UB);

    z=zsigma(1:nn);
    %sigma=zsigma(nn+1:end);
end
end 

