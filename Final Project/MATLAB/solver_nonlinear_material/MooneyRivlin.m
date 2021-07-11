function W=MooneyRivlin(C,parameters,Finv)

if (nargin==3)
    C=smtam(Finv,amsm(C,Finv)); 
end

detC=amdet(C)';
trC=squeeze(C(1,1,:)+C(2,2,:));
%cofC(1,1,:)=C(2,2,:); cofC(2,2,:)=C(1,1,:); cofC(1,2,:)=-C(2,1,:); cofC(2,1,:)=-C(1,2,:);
%trcofC=squeeze(cofC(1,1,:)+cofC(2,2,:));

W1=parameters.alpha*trC; 
%W2= parameters.alpha2*trcofC; 
W3=parameters.delta1*detC; 
W4=-(parameters.delta2/2)*log(detC);


%W=W1+W2+W3+W4;
W=W1+W3+W4;
