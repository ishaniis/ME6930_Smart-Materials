function nom = amnorm (ama,p)
% ama: ama(1:nx,1:nx,1:nz)

if (nargin==1)
   p=2;
end


if p==2
    nom=sqrt(sum(sum(ama.^2,1),2));
    nom=nom(:);
    %nom2=sqrt(am_InnerProduct_am (ama,ama));
else
    ama_abs=abs(ama);
    nom=squeeze((sum(sum(ama_abs.^p,1),2)).^(1/p));
end

return