function avb = svtam (svx,ama)
% svx: svx(1:ny,1)
% ama: ama(1:nx,1:ny,1:nz)
% avb: avb(1,1:nx,1:nz)

[~,ny,nz] = size(ama);

avx = svx(:);
avx = avx(:,ones(ny,1),ones(nz,1));

avb = avx.* ama;
avb = sum(avb,1);

return