function Cp = parametrize_GLplus(vector)
%symetric positive definite with positive determinant

if (numel(vector)==2)   %2D implementation
   a=vector(1);
   b=vector(2);
   
   a=abs(a)+1e-6; %to get rid of negative values and in particular zero! 
   b=abs(b)+1e-6; %to get rid of negative values and in particular zero!
   
   %a=sqrt(a);    %normalization
   
   
   Cp=[a 0; 0 b];   
elseif (numel(vector)==3) %3D implementation
    a=vector(1);
    b=vector(2);
    c=vector(3);
    
    a=abs(a)+1e-4; %to get rid of negative values and in particular zero! 
end
    
% a must be strictly positive, b any number
   


end

