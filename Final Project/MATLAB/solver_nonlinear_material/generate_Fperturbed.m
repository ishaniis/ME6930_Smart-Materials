function Fperturbed = generate_Fperturbed(f11,f12,ne)

Iperturbed=[f11 f12; 0 1/f11];
             
Fperturbed=repmat(Iperturbed,[1 1 ne]); 
%Cperturbed=amtam(Fperturbed,Fperturbed);

end

