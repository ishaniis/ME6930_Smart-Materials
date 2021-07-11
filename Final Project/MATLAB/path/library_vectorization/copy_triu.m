function ama = copy_triu(ama)
% COPY_TRIU
% ama: ama(1:nx,1:ny,1:nz)
%   Copy the upper triangular part of given square matrices A such that
%   A(k,m,:) = A(m,k,:)
%
% SYNTAX:  A = copy_triu(A)
%
% IN:   A    matrices whose upper triangular parts we wish to copy
%
% OUT:  A    matrices with upper triangular parts copied to the lower
%            triangular parts (essentially making them symmetric)
%

nrows = size(ama,1);
ncols = size(ama,2);

if ( nrows ~= ncols )
    error('The given matrices are not square matrices.')
end

for m=1:nrows
    for k=m+1:nrows
        ama(k,m,:) = ama(m,k,:);
    end
end
