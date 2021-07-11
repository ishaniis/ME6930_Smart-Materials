clear variables
close all 

if ~license('test', 'optimization_toolbox')
   fprintf('Optimization Toolbox is not available! \n') 
   return
end
%options = optimoptions('linprog','Algorithm','dual-simplex');
%options = optimoptions('fminunc','Algorithm','quasi-newton','Display','off','TolFun',1e-10,'MaxFunEvals',1e6);

%%%% SETUP START %%%%%

benchmark=2;  %1, 2 - article examples

alpha=1;  delta1=1;                                                %2D Mooney-Rivlin parameters         
epsilon=0.3;                                                       %stretching matrices parameter
beta=0.1;                                                          %disipation parameter %beta=0.3;
alphaS=0;                                               %surface energy parameter
                                                                      
mesh_level=1;   %mesh refinement, minimum value is 1, usual is 3

visualization=1;   %0 - no pictures, %1 - plus time characteristics, %2 - plus field in time steps, %3 + all fields in time steps (initial as well)
visualization_fields_number=2;      %if the value is 2, only deformed mesh and z fields are visualized
visualization_major_title=0;
                     
switch benchmark
    case 1
         load z_rand.mat
         alphaI=0*0.003;  
         periodic_cycles=1; t_max=16;
         free_boundary=0; %0 - complete dirichlet
    case 2
         alphaI=0*0.001; 
         periodic_cycles=1; t_max=16;
         free_boundary=2; %0 - complete dirichlet
         periodic_bc=1; %only implemented for the case free_boundary=2 !!!
    case 3
        alphaI=0*0.001; %interfacial energy parameter   
        free_boundary=2; %1 - lower horizontal edge is neumann edge, 2 - both horizontal edges are neumann edges
        periodic_bc=1; %only implemented for the case free_boundary=2 !!!
        periodic_bc_mesh_layers_to_add=1;
        periodic_cycles=1.5; t_max=ceil(periodic_cycles*16);     
        all.t=0:t_max; all.t_visualize=(mod(all.t,2)==0);   %time steps and time steps for visualization         
    case 4
        alphaI=0*0.001; %interfacial energy parameter 
        free_boundary=4; %4 - upper horizontal edges in Dirichlet edge
    case 5
        alphaI=0*0.001; %interfacial energy parameter 
        free_boundary=0; %0 - complete dirichlet
        %periodic_bc=0; periodic_mesh_layers_to_add=0;     
        beta=0*0.01;  
        periodic_cycles=2; 
    case 6
        alphaI=0*0.001; %interfacial energy parameter 
        free_boundary=0;    
        periodic_cycles=1; 
        mesh_level=3;
end

if ~exist('periodic_bc','var')
    periodic_bc=0;
end
if ~exist('periodic_cycles','var')
    periodic_cycles=1;  
end
if ~exist('t_max','var')
    t_max=ceil(periodic_cycles*16);   
end
if ~exist('all.t','var')
    all.t=0:t_max;  
    all.t_visualize=(mod(all.t,2)==0);
end




%all.t=0:t_max;                                 %time steps
%all.t_visualize=all.t(find(~mod(all.t,2)));    %time steps for visualization

iterations=10;
%%%% SETUP END %%%%%

add_paths;

start_memory

%save save_file

visualize_memory_all