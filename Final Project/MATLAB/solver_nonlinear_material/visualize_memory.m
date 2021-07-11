colormap gray

nx=1; ny=visualization_fields_number;

subplot(nx,ny,1); hold on;
for i=0:periodic_bc_mesh_layers_to_add
   yshift=[y(:,1) y(:,2)+i*L2];
   show_mesh(elemsRectangular2nodes,yshift); 
   if isfield(nodes,'periodic')
      show_boundary_nodes(yshift,nodes.dirichlet,nodes.periodic);  
   else
      show_boundary_nodes(yshift,nodes.dirichlet,nodes.neumann);
   end 
end
hold off; subplot_setup;

if visualization_fields_number>=2
    subplot(nx,ny,2); hold on; 
    for i=0:periodic_bc_mesh_layers_to_add
        yshift=[y(:,1) y(:,2)+i*L2];
        show_constant_scalar(z,yshift,elems2nodes); 
        hold on
        draw_edges(edges_boundary2nodes,yshift,1)
    end
    hold off; subplot_setup; 
    caxis([0 1])
end

if visualization_fields_number>=3
   subplot(nx,ny,3); 
   hold on
   for i=0:periodic_layers_to_add
        yshift=[y(:,1) y(:,2)+i*L2];
        show_constant_scalar(SigmaNorm,yshift,elems2nodes); 
        draw_edges(edges_boundary2nodes,yshift)
    end
   hold off; subplot_setup; 
end

if visualization_fields_number>=4
   subplot(nx,ny,4); 
   ind=(edge2elems(:,2)~=0);
   col=zeros(size(edge2nodes,1),1);
   col(ind)=eStructure.densityEdge_partSurfaceEnergy;   
   hold on
   for i=0:periodic_layers_to_add
        yshift=[y(:,1) y(:,2)+i*L2];
        xshift=[x(:,1) x(:,2)+i*L2];
        show_edge_constant_frame(col,xshift,edge2nodes,yshift);
    end
   hold off; subplot_setup; 
   axis tight
end
%colormap default
   
   %hold on; draw_edges(edges_boundary2nodes,y); hold off;
   
   
   
    


if 0

if (visualization_fields_number==8)
    nx=2; ny=4;
    subplot(nx,ny,1); show_mesh(elems2nodes,x); axis equal; axis([x1Min x1Max+a x2Min x2Max]); ht=title('x');
    hold on; plot(x(nodes_dirichlet,1),x(nodes_dirichlet,2),'.r', 'MarkerSize',15); hold off        
    subplot(nx,ny,ny+1); show_mesh(elems2nodes,y); axis equal; axis tight; title('y')
    hold on; plot(y(nodes_dirichlet,1),y(nodes_dirichlet,2),'.r', 'MarkerSize',15); hold off

    if 1
    subplot(nx,ny,2); show_constant_scalar(eStructure.phi1,y,elems2nodes); ht=title('\Phi_1 (F(y), F_1)'); subplot_setup;
    subplot(nx,ny,ny+2); show_constant_scalar(eStructure.phi2,y,elems2nodes); ht=title('\Phi_2 (F(y), F_2)'); subplot_setup;
    subplot(nx,ny,3); show_constant_scalar(eStructure.density,y,elems2nodes); ht=title('z \Phi_1 + (1-z) \Phi_2'); subplot_setup;
    subplot(nx,ny,ny+3); show_constant_scalar(eStructure.detF,y,elems2nodes); ht=title('det(F)'); subplot_setup;
    subplot(nx,ny,4); show_constant_scalar(z,y,elems2nodes); ht=title('z'); subplot_setup; 
    subplot(nx,ny,ny+4); show_constant_scalar(eStructure.density_partDissipation,y,elems2nodes); ht=title('\beta | z -z_0 |'); subplot_setup; 
    end
end

if 0
    figure(fig+2)
    subplot(1,2,1); show_constant_scalar(detF_all,y,elems2nodes); axis square; title('determinant of F'); view(2); colorbar
    subplot(1,2,2); show_constant_scalar(angleF_all,y,elems2nodes); axis square; title('angle from the rotation matrix R in the polar decomposition: F=R*T'); view(2); colorbar
end

end