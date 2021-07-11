function z= minimization_z_old(W1,W2,cofFsurfnormal,z0,areas,iedges,parameters,bounds_decrease )

Wdiference=W1-W2; 

if (norm([parameters.alphaI parameters.alphaS])==0)
    if (bounds_decrease==0)
        value_between=1/2; 
        if 1           
            values_z=Wdiference+parameters.beta*(1-2*z0);
            z=zeros(size(W1));
            z(values_z<0)=1;
            z(values_z==0)=value_between; 
        else             
            z=value_between*ones(size(w0));  %initial value
            values_z_arg_1=W1+beta_dissipation*(1-z0);      %value for z=1
            values_z_arg_0=W2+beta_dissipation*z0;          %value for z=0
            z(values_z_arg_1>values_z_arg_0)=0;
            z(values_z_arg_1<values_z_arg_0)=1;            
        end
        
        if 0
            %linear programming, it works only for alpha_gradient=0 (no gradient of z)
            options = optimoptions('linprog','Algorithm','dual-simplex');
            n=size(areas,1); ie=size(iedge2size,1); 
            fztilde=areas.*(w0-w1); flambdatilde=beta_dissipation*areas; 
            f=[fztilde; flambdatilde];
            A=[eye(n) -eye(n); -eye(n) -eye(n)]; b=zeros(2*n,1); %this constraint enforces the absolute value in the dissipation 
            LB=[-z0; -inf*ones(n,1)];
            UB=[1-z0; inf*ones(n,1)];
            ztildelambdatilde=linprog(f,A,b,[],[],LB,UB,options);
            ztilde=ztildelambdatilde(1:n);
            lambdatilde=ztildelambdatilde(n+1:end);  
            z=ztilde+z0;
        end    
    else
        value_between=1/2; z=value_between*ones(size(W1));  %initial value
        values_z_arg_1=(1-bounds_decrease)*W1+bounds_decrease*W2+beta_dissipation*abs(1-bounds_decrease-z0);      %value for z=1-epsilon
        values_z_arg_0=bounds_decrease*W1+(1-bounds_decrease)*W2+beta_dissipation*abs(bounds_decrease-z0);      %value for z=0+epsilon
        z(values_z_arg_1>values_z_arg_0)=bounds_decrease;
        z(values_z_arg_1<values_z_arg_0)=1-bounds_decrease;
    end
    
else
    
    %linear programming, it works only for alpha_gradient>0 (including gradient of z)
    alphas=parameters.alphaI+parameters.alphaS*sqrt(sum(cofFsurfnormal.^2,2));                              %new

    options = optimoptions('linprog','Algorithm','dual-simplex');
    n=size(areas,1); ie=size(iedges.size,1); 
    fztilde=areas.*Wdiference; 
    flambdatilde=parameters.beta*areas; 
    fsigmatilde=alphas.*iedges.size;
    f=[fztilde; flambdatilde; fsigmatilde];

    Asigma=sparse(1:ie,iedges.elems(:,1),ones(ie,1),ie,n)-sparse(1:ie,iedges.elems(:,2),ones(ie,1),ie,n);
    A=[eye(n) -eye(n) zeros(n,ie); ...
      -eye(n) -eye(n) zeros(n,ie); ...
       Asigma  zeros(ie,n) -eye(ie); ...
      -Asigma zeros(ie,n) -eye(ie)]; 

    b=[zeros(n,1);  ...
       zeros(n,1);  ... 
      -z0(iedges.elems(:,1)) + z0(iedges.elems(:,2)); ...
       z0(iedges.elems(:,1)) - z0(iedges.elems(:,2))]; %this constraint enforces the absolute value in the dissipation 
    LB=[-z0; -inf*ones(n,1); -inf*ones(ie,1)];
    UB=[1-z0; inf*ones(n,1);  inf*ones(ie,1)];
    
    %ztildelambdatildesigmatilde=linprog(f,A,b,[],[],LB,UB);
    
    [ztildelambdatildesigmatilde,FVAL,EXITFLAG,OUTPUT,LAMBDA]=linprog(f,A,b,[],[],LB,UB);
    
    if EXITFLAG>1
       save
       fprintf('save and stop')
       pause
    end
       
    
    
    ztilde=ztildelambdatildesigmatilde(1:n);
    lambdatilde=ztildelambdatildesigmatilde(n+1:2*n);  
    sigmatilde=ztildelambdatildesigmatilde(2*n+1:end);
    z=ztilde+z0;

    %norm(abs(ztilde)-lambdatilde,inf)    %this should be close to zero!
    %norm(abs(Asigma*z)-sigmatilde,inf)   %this should be close to zero!
    %norm(z-z,inf)   %this should be zero for alpha_gradient close to zero

end
end 

