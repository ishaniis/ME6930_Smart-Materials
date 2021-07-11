view(2); 
axis image; 

if exist('all_Limits_y','var')
    axis([min(all_Limits_y(:,1)) max(all_Limits_y(:,1)) min(all_Limits_y(:,2)) max(all_Limits_y(:,2))]);
    enlarge_axis(0.01,0.01);
    set(gca, 'box', 'on', 'xcolor','y','ycolor','y','Visible', 'on','xtick', [], 'ytick', [])
    xlabel(''); ylabel('');
else
    enlarge_axis(0.01,0.01);
    set(gca, 'box', 'on', 'xcolor','y','ycolor','y','Visible', 'on','xtick', [], 'ytick', [])
    xlabel(''); ylabel('');
end