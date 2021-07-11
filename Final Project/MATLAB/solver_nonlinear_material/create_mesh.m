%xmin=0; xmax=1; ymin=-0.5; ymax=0.5;      %domain geometry 

if 1 %~license('test', 'pde_toolbox') 
   %coarse mesh
    if 1
        if 0
            %x=[0 -0.5; 1 -0.5; 0 0.5; 1 0.5];
            x=[0 0; 1 0; 0 1; 1 1];
            elems2nodes=[1 2 3; 2 4 3];

            x=[x; 2 0; 2 1];
            elems2nodes=[elems2nodes; 2 5 4; 5 6 4]; 

            elems2nodes(1,:)=[1 2 4];
            elems2nodes(2,:)=[1 4 3];
        else
            x=[0 0; 1 0; 2 0; 0 1; 1 1; 2 1];
            elemsRectangular2nodes=[1 2 5 4; 2 3 6 5];
        end
    else
        x=[0 -0.5; 1 -0.5; 0 0.5; 1 0.5; 0.5 0];
        elems2nodes=[1 2 5; 2 4 5; 4 3 5; 3 1 5];
    end
    %prolongation to the actual mesh         
    for i=1:mesh_level
        
        %creating finer mesh
        %[x,elems2nodes]=refinement_uniform_2D(x,elems   2nodes);
        [x,elemsRectangular2nodes]=refinement_uniform_2D(x,elemsRectangular2nodes);       
        elemsRectangular2nodes=reorder_elements(elemsRectangular2nodes,x);
        
        elemsTriangular2nodes=[];
        width=size(elemsRectangular2nodes,1)/2^i;
        for s=1:(2^i)
            if mod(s,2)==1  %odd rectangular strip
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+1):2:(width*s),[1 2 4])];   
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+1):2:(width*s),[2 3 4])]; 
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+2):2:(width*s),[1 2 3])];   
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+2):2:(width*s),[1 3 4])]; 
            else  %even rectangular strip
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+1):2:(width*s),[1 2 3])];   
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+1):2:(width*s),[1 3 4])]; 
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+2):2:(width*s),[1 2 4])];   
                elemsTriangular2nodes=[elemsTriangular2nodes; elemsRectangular2nodes((width*(s-1)+2):2:(width*s),[2 3 4])];
            end
        end      
        elems2nodes=elemsTriangular2nodes;
           
        if visualization>0
            if (i==1) || (i==2)
                figure
                subplot(2,1,i); show_mesh(elemsRectangular2nodes,x);
                hold on; show_elements(elemsRectangular2nodes,x); hold off; axis equal; axis tight;

                figure
                subplot(2,1,i); show_mesh(elemsTriangular2nodes,x);
                hold on; show_elements(elemsTriangular2nodes,x); hold off; axis equal; axis tight;
            end
        end
    
    end     
else
    [x,elems2nodes]=rectangular_mesh_from_pde_toolbox(0,1,-0.5,0.5,level); 
end
elems2midpoint=evaluate_elements_average(elems2nodes,x);

%bounding box edges
[edge2nodes, edge2elements, element2edges]=getEdges_triangles(elems2nodes);
edges_boundary2nodes=edge2nodes(find(edge2elements(:,2)==0),:);

%nodes classification
nodes_number=size(x,1);
nodes_boundary = get_boundary_nodes(elems2nodes);

%bounding box
x1Max=max(x(:,1)); 
x1Min=min(x(:,1)); 
x2Max=max(x(:,2)); 
x2Min=min(x(:,2)); 
L1=x1Max-x1Min; 
L2=x2Max-x2Min;

%dirichlet and neumann nodes
I1=find(x(nodes_boundary,1)==x1Min); %left edge 
I2=find(x(nodes_boundary,1)==x1Max); %right edge
I3=find(x(nodes_boundary,2)==x2Min); %bottom edge
I4=find(x(nodes_boundary,2)==x2Max); %top edge

switch free_boundary
    case 0
        nodes_dirichlet=nodes_boundary;         
    case 1       
        nodes_dirichlet=nodes_boundary(unique([I1; I2; I4]));   %lower edge is neumann edge
    case 2
        nodes_dirichlet=nodes_boundary(unique([I1; I2]));   
    case 3
        nodes_dirichlet=nodes_boundary(unique([I1; I4])); 
    case 4
        nodes_dirichlet=nodes_boundary(unique(I4)); 
end

if  periodic_bc
    nodes_periodic=setdiff(nodes_boundary,nodes_dirichlet);
    [xdummy,isort]=sort(x(nodes_periodic,1));
    nodes_periodic_pairs=reshape(nodes_periodic(isort),2,numel(nodes_periodic)/2)';  
    nodes_free=setdiff((1:nodes_number)',union(nodes_dirichlet,nodes_periodic_pairs(:,2)));
    nodes=struct('number',size(x,1),...
                 'dirichlet',nodes_dirichlet,...
                 'periodic',nodes_periodic_pairs, ...
                 'free',nodes_free);
else    
    nodes_neumann=setdiff(nodes_boundary,nodes_dirichlet);
    nodes_free=setdiff((1:nodes_number)',nodes_dirichlet);
    nodes=struct('number',size(x,1),...
                 'dirichlet',nodes_dirichlet,...
                 'neumann',nodes_neumann, ...
                 'free',nodes_free);
end     
         
clear nodes_dirichlet nodes_neumann nodes_free nodes_boundary nodes_periodic nodes_periodic_pairs

nn=nodes.number;
ne=size(elems2nodes,1);

[edge2nodes, edge2elems, elem2edges, node2edges]=getEdges(elems2nodes);
edge2vector=x(edge2nodes(:,2),:)-x(edge2nodes(:,1),:);
edge2size=sqrt(sum(edge2vector.^2,2));  %edges sizes
edge2normal=[edge2vector(:,2) -edge2vector(:,1)];
edge2normal=edge2normal./[edge2size edge2size];

ind=(edge2elems(:,2)~=0);
iedge2elems=edge2elems(ind,:);  %internal edges
iedge2size=edge2size(ind);      %internal edges sizes
iedge2normal=edge2normal(ind,:); %internal edges normals 

iedges.elems=iedge2elems;
iedges.size=iedge2size;
iedges.normal=iedge2normal;
clear ind iedge2elems iedge2normal iedge2size