if ~exist('periodic_bc_mesh_layers_to_add','var')
    periodic_bc_mesh_layers_to_add=0;
end


%preprocessing all pictures to compute one range for all pictures
all_Limits_SigmaNorm=[];
all_Limits_y=[];
for i=1:numel(all.solutionStructure)
    if (all.t_visualize(i))
        solutionStructure=all.solutionStructure{i};    
        y=solutionStructure.y;
        %z=solutionStructure.z;
        SigmaNorm=solutionStructure.SigmaNorm;
        all_Limits_SigmaNorm=[all_Limits_SigmaNorm; min(SigmaNorm); max(SigmaNorm)];
        all_Limits_y=[all_Limits_y; ...
                     min(y(:,1)) min(y(:,2)); ...
                     max(y(:,1)) max(y(:,2))+L2*periodic_bc_mesh_layers_to_add];
    end
end
clear all_Limits_y            %remove this line to enforce the precomputed box

for i=1:1:numel(all.solutionStructure)
    if (all.t_visualize(i))
        solutionStructure=all.solutionStructure{i};  
        
        y=solutionStructure.y;
        z=solutionStructure.z;

        figure
        visualize_memory; 
        t=solutionStructure.t;

        %printout
        fig_name=sprintf('pictures_memory/benchmark_%d_time_step_%03g',benchmark,t);
        fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
        print('-painters','-depsc2','-r300',fig_name); screen2jpeg(fig_name); save2pdf(fig_name);    
    end
end

figure
subplot(3,1,1)
time_step_finished=size(all.StoredEnergy,2)-1;
plot(all.t(1:time_step_finished+1),all.StoredEnergy(1:time_step_finished+1)+eps,'-o'); 
title('stored energy total vs. time')
legend('stored energy total','location','best')

subplot(3,1,2)
plot(all.t(1:time_step_finished+1),all.StoredEnergyInterfacial(1:time_step_finished+1)+eps,'-o',...
         all.t(1:time_step_finished+1),all.StoredEnergySurface(1:time_step_finished+1)+eps,'-o'); title('stored edge energies vs. time')
legend('stored energy interfacial','stored energy sufrace','location','best')

subplot(3,1,3)  
plot(all.t(1:time_step_finished+1),cumsum(all.Dissipation(1:time_step_finished+1)),'-o'); title('dissipated energy vs. time')
legend('dissipation','location','best')

%printout here !!!!!
fig_name=sprintf('pictures_memory/benchmark_%d_time_development',benchmark);
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('-painters','-depsc2','-r300',fig_name); screen2jpeg(fig_name); save2pdf(fig_name);   


figure; % VFMV
plot(all.t(1:time_step_finished+1),all.VFMV1(1:time_step_finished+1),'-o'); title('VFMV1 vs. time')
legend('volume fraction of one variant martensite','location','best')

%printout
fig_name=sprintf('pictures_memory/benchmark_%d_time_dev_VFMV1',benchmark);
fig = gcf; fig.PaperPositionMode = 'auto'; %fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('-painters','-depsc2','-r300',fig_name); screen2jpeg(fig_name); save2pdf(fig_name); 


if 0
    figure
    plot(all.t(1:time_step_finished+1),all.SigmaAverageNorm(1:time_step_finished+1),'-o',all.t(1:time_step_finished+1),all.SigmaNormAverage(1:time_step_finished+1),'-o'),title('stress vs. time')
    legend('norm of averaged stress','average of norm of stress')

    figure
    plot(all.ENormAverage(2:end), all.SigmaNormAverage(2:end),'-x')
end


    
    
    if 0
figure(2000)
subplot(1,2,1)
show_mesh(elemsTriangular2nodes,x)
axis equal; axis tight;
subplot(1,2,2)
show_mesh(elemsRectangular2nodes,x)
axis equal; axis tight;
save2pdf(sprintf('pictures_memory/mesh'))

figure(3000)
plot(all_t(2:time_step+1),(2.5)*all_displacement_multiplier(2:time_step+1),'-o'); 
legend('\alpha')
title('mesh deformation parameter \alpha vs. time')
%daspect([10 1 2])
axis tight
%set(gcf, 'Position', get(0, 'Screensize'));
save2pdf(sprintf('pictures_memory/alpha_vs_time'))

figure(4000)
set(gcf, 'Position', get(0, 'Screensize'));
subplot(2,1,1)
semilogy(all_t(2:time_step+1),all_StoredEnergy(2:time_step+1),'-o'); title('stored energy vs. time')
legend('stored energy','location','best')
%daspect([20 1 2])
axis tight

subplot(2,1,2)
semilogy(all_t(1:time_step+1),cumsum(all_Dissipation(1:time_step+1)),'-o'); title('dissipated energy vs. time')
%daspect([10 1 2])
legend('dissipation','location','best')
axis tight

save2pdf(sprintf('pictures_memory/energies_vs_time'))

end

    
    


