function amb = smtam (smx, ama)
% smx: smx(1:ny,1:nk)
% ama: ama(1:nx,1:ny,1:nz)
% amb: amb(1:nx,1:nk,1:nz)

[ny,nk]    = size(smx);
[nx,ny,nz] = size(ama);

amb     = zeros(nx,nk,nz);
for row = 1:nx

    amb(row,:,:) = svtam(smx(row,:),ama);
    
end

return