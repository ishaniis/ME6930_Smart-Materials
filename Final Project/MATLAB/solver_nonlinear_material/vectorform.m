function vectorform=vectorform(matrix)
        if size(matrix,1)>=size(matrix,2)
            matrix=matrix';
        end
        vectorform=reshape(matrix,numel(matrix),1);
end