function show_boundary_nodes(coordinates,dn,nn)

hold_status=ishold;
if ~hold_status
    hold on
end

if size(coordinates,2)==2
    scatter(coordinates(dn,1),coordinates(dn,2),10,'k','filled')%'o','MarkerFaceColor','k')
    scatter(coordinates(nn,1),coordinates(nn,2),30,'ro')
    xlabel('x'); ylabel('y');
elseif size(coordinates,2)==3
    %plot_points([coordinates(nn,1),coordinates(nn,2),coordinates(nn,3)],'rx'); 
    scatter3(coordinates(dn,1),coordinates(dn,2),coordinates(dn,3),25,'o', 'MarkerFaceColor','k')
    scatter3(coordinates(nn,1),coordinates(nn,2),coordinates(nn,3),50, 'ro')
    xlabel('x'); ylabel('y'); zlabel('z');
end

if ~hold_status
    hold off
end

end

