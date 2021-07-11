parameters.epsilon=epsilon;  
parameters.alpha=alpha; 
%parameters.alpha2=alpha2; 
parameters.delta1=delta1;
%parameters.delta2=2*alpha1+4*alpha2+2*delta1;   %full 3D version for the future
%parameters.delta2=2*alpha1+4*alpha2+2*delta1;   %2D version assuming nonzero value of alpha2
parameters.delta2=2*alpha+2*delta1;            %2D version assuming zero value of alpha2
parameters.alphaS=alphaS; parameters.alphaI=alphaI; parameters.beta=beta;
clear epsilon alpha1 alpha2 delta1 delta2 alphaS alphaI

create_mesh; %fem mesh and nodes (internal, dirichlet, neumann); 

%setup on the actual mesh
[K,areas,K_3Dmatrix,dphi_3Dmatrix]=stifness_matrixP1_2D(elems2nodes,x); 
dphi_3DmatrixT=amt(dphi_3Dmatrix); clear dphi_3Dmatrix

switch benchmark
    case {1,2,3,4,5,6}
        F1=generate_Fperturbed(1,parameters.epsilon,ne);  
        F2=generate_Fperturbed(1,-parameters.epsilon,ne);
    case 7
        F1=generate_Fperturbed(1+parameters.epsilon,0,ne); 
        F2=generate_Fperturbed(1/(1+parameters.epsilon),0,ne);       
end
%all_t=all_t(1:1:16); all_t_visualize=all_t;    %only for TESTING

F1inv=aminv(F1(:,:,1)); F2inv=aminv(F2(:,:,1));
I=generate_Fperturbed(1,0,ne);

%setup of z
mesh_size_h=min(sqrt(sum((x(edge2nodes(:,1),:)-x(edge2nodes(:,2),:)).^2,2)));
z_oscilating=mod(floor(elems2midpoint(:,2)/mesh_size_h),2);
%z_rand=randi(2,ne,1)-1;
z_half=(1/2)*ones(ne,1);

%setup of boundary displacement
switch benchmark
    case 1
        amplitude=0.75*(x1Max-x1Min)/5; 
    case 2
        amplitude=(x1Max-x1Min)/5;   %this value is 0.4 for our geometry
    case {3,4,5,6}
        amplitude=(x1Max-x1Min)/5;   %this value is 0.4 for our geometry
    case 6
        amplitude=0;
end

all.a=displacement_multiplier(all.t,periodic_cycles);
switch benchmark
    
    case {1,2,3,5,6}    %basic shape setup
        if (benchmark==1)
            xScaling=1; yScaling=0; 
            u_basic_shape=amplitude*[xScaling*((x(:,2)-0.5)), yScaling*x(:,1).^2/x1Max^2];
        end
        
        if (benchmark==2)
            u_basic_shape = amplitude*[0.0*x(:,1), x(:,1)];
        end   
                    
        if (benchmark==3)
            u_basic_shape=amplitude*[x(:,1)/2, x(:,1).^2/2];
        end
        
        if (benchmark==5)
            xScaling=1; yScaling=0; 
            u_basic_shape=amplitude*[xScaling*((x(:,2)-0.5)), yScaling*x(:,1).^2/x1Max^2];
        end      
        
        if (benchmark==6)
            xScaling=1; yScaling=0; 
            u_basic_shape=amplitude*[xScaling*(x(:,1).*(x(:,2)-0.5))/x1Max, yScaling*x(:,1).^2/x1Max^2];
        end     
        
        
        
        
        u1Max=max(u_basic_shape(:,1)); u2Max=max(u_basic_shape(:,2)); 
        u1Min=0; u2Min=-max(u_basic_shape(:,2));
        
        if visualization>0
            figure; 
            %plot(x(nodes.dirichlet,1)+u_basic_shape(nodes.dirichlet,1),x(nodes.dirichlet,2)+u_basic_shape(nodes.dirichlet,2),'*'); 
            draw_edges(edges_boundary2nodes,x,[],[],'k:')
            hold on
            draw_edges(edges_boundary2nodes,x+u_basic_shape,[],[],'k-')
            hold off
            %title('basic shape'); 
            axis equal; axis off
            view(2)
            %save2pdf(sprintf('pictures_memory/example1'))
        end
    
    case 4
        all_r=0.25./(abs(all.a)+0.01);  
        all_r=25./(20*abs(all.a)+1);  
        %all_r=0.5./(all_displacement_multiplier+0.01);
         
        if visualization>0
            figure; 
            in=find(sum(ismember(edges_boundary2nodes,nodes.dirichlet),2)==2);

            draw_edges(edges_boundary2nodes,x,[],[],'k:')
            hold on
            u=transform_rectangle_to_annulus(x,min(all_r));
            draw_edges(edges_boundary2nodes(in,:),x+u,[],[],'k-')

            u=transform_rectangle_to_annulus(x,max(all_r));
            draw_edges(edges_boundary2nodes(in,:),x+u,[],[],'k-')
            hold off
            %title('basic shape'); 
            axis equal; axis off
            view(2)
            %save2pdf(sprintf('pictures_memory/example2'))
        end
end

for time_step=0:numel(all.t)-1
    
    switch benchmark
        case 1
            ampl=all.a(time_step+1); 
            u=u_basic_shape*diag([ampl,ampl]);
        case 2 
            ampl=all.a(time_step+1); 
            u=u_basic_shape*diag([ampl,ampl]);         
        case 3
            ampl=all.a(time_step+1); 
            u=u_basic_shape*diag([abs(ampl),ampl]);
        case 4
            r=all_r(time_step+1); 
            u=transform_rectangle_to_annulus(x,r);
        case {5,6}
            ampl=all.a(time_step+1);
            u=u_basic_shape*diag([ampl,ampl]);          
    end
    
    %u=t*a*[xScaling*x(:,1)/x1Max, +yScaling*x(:,1).^2/x1Max^2];   
    u_dirichlet=u(nodes.dirichlet,:);
    
    %u=u+(mesh_size_h/4)*(2*rand(size(u))-1/2);   %random displacement
    u=u+(mesh_size_h/8)*(2*rand(size(u))-1/2);   %random displacement !!!!
    if isfield(nodes,'periodic')
        u(nodes.periodic(:,2),:)=u(nodes.periodic(:,1),:);    
    end
    
    u(nodes.dirichlet,:)=u_dirichlet;
    
    if time_step==0
        switch benchmark
            case 1
                z0 = z_rand(1:ne,1);
                
            case {2,3,4,5,6,7}
                z0=z_oscilating;   
           
            case 5
                z0=z_rand;
        end     
    else
        z0=z;
    end
    
    y=x+u; z=z0;
    
    %figure; visualize_memory
    
    figure_counter=100*(time_step+1); 
    
    solver;                                             %MAIN SOLVER
    
    all.StoredEnergy(time_step+1)=eStructure.valueArea_partBulkEnergy+eStructure.valueEdge_partInterfacialEnergy+eStructure.valueEdge_partSurfaceEnergy;
    all.StoredEnergyBulk(time_step+1)=eStructure.valueArea_partBulkEnergy;
    all.StoredEnergyInterfacial(time_step+1)=eStructure.valueEdge_partInterfacialEnergy;
    all.StoredEnergySurface(time_step+1)=eStructure.valueEdge_partSurfaceEnergy;
    all.Dissipation(time_step+1)=eStructure.valueArea_partDissipation;
    all.SigmaAverageNorm(time_step+1)=SigmaAverageNorm;
    all.SigmaNormAverage(time_step+1)=SigmaNormAverage;  
    all.EAverageNorm(time_step+1)=EAverageNorm;
    all.ENormAverage(time_step+1)=ENormAverage;  
    all.VFMV1(time_step+1)= VFMV1;
    
    %[val,ind]=min(abs(all.t_visualize-t));    
    %if (val==0)    %val<=t_delta/2
    if 1
        y=x+u; 

        solutionStructure = struct('t',t,'y',y,'z', z,'Sigma', Sigma,'SigmaNorm',SigmaNorm);
        %all.solutionStructure{ind}=solutionStructure;
        all.solutionStructure{time_step+1}=solutionStructure; 
        
        if visualization>=2   
            figure; visualize_memory; 

            if visualization_major_title
                mtit(strcat('time step=', num2str(time_step),', energy=',num2str(e)))
            end
        end
        
        if visualization>=3
            figure(figure_counter+7)
            quiver(x(:,1),x(:,2),u(:,1),u(:,2),0)   
        end
    end 
end

if visualization>0
    %hold on
    %draw_edges(edges_boundary2nodes,x,0,inf,'r:'); 
    %draw_edges(edges_boundary2nodes,x+u,0,inf,'b:'); 
    %hold off
end


        
    

