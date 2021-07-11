function W = material_law(C,parameters,Finv)

if 1
    W=MooneyRivlin(C,parameters,Finv);
else
    C=smtam(Finv,amsm(C,Finv));
    detC=amdet(C)';
    W=amnorm(C)+(1./amdet(C))'; 
end

end

