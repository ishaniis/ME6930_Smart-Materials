function show_mesh(elements,coordinates)
if (size(coordinates,2)==2)
        X=reshape(coordinates(elements',1),size(elements,2),size(elements,1));
        Y=reshape(coordinates(elements',2),size(elements,2),size(elements,1));
        fill(X,Y,[1 1 1]);
else
    tetramesh(elements,coordinates,'FaceAlpha',1);%camorbit(20,0);
end


