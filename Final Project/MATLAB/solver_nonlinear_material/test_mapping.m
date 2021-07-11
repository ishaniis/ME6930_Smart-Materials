clear all
close all

a=2; b=1; 

[u,v] = meshgrid(0:0.1:a,0:0.1:b); 
%u=[u(1,:), u(end,:), u(:,1)', u(:,end)']; v=[v(1,:), v(end,:), v(:,1)', v(:,end)']; 
u=[u(1,:), u(end,:)]; v=[v(1,:), v(end,:)]; 

x=[u(:) v(:)]; %bounding box x
x1Max=max(x(:,1)); x1Min=min(x(:,1)); x2Max=max(x(:,2)); x2Min=min(x(:,2));

r_delta=0.1;
all_r=[15:-r_delta:0.5 0.5+r_delta:r_delta:15];
all_r=[15:-r_delta:0.5];

all_t=0:64;

amplitude=10*(x1Max-x1Min)/50; 
xScaling=1; yScaling=2; u_basic_shape=[xScaling*x(:,1)/x1Max, +yScaling*x(:,1).^2/x1Max^2];

h=figure(1);
subplot(1,2,1); plot(x(:,1),x(:,2),'x'); title('x'); axis image; 

all_displacement_multiplier=displacement_multiplier(all_t,all_t,amplitude);
all_r=0.5./(abs(all_displacement_multiplier)+0.01);

for time_step=1:(numel(all_t)-1)    
    if 0
        ampl=all_displacement_multiplier(time_step+1); 
        u=u_basic_shape*diag([abs(ampl),ampl]); y=u+x;
        subplot(1,2,2); plot(y(:,1),y(:,2),'x'); title('y'); axis equal;  %axis([0 2*a -b 2*b]); drawnow;
    else
        r=all_r(time_step+1);
        [u,y]=transform_rectangle_to_annulus(x,r); 
        
        %bounding box
        y_box_dummy=[min(y(:,1)) max(y(:,1)) min(y(:,2)) max(y(:,2))]; 
        
        if ~exist('y_box')
            y_box=y_box_dummy;
        else
            y_box_both=[y_box; y_box_dummy];
            y_box=[min(y_box_both(:,1)),max(y_box_both(:,2)),min(y_box_both(:,3)),max(y_box_both(:,4))]; 
        end
        
        
        
        subplot(1,2,2); plot(y(:,1),y(:,2),'x',0,r+b,'ro'); title('y'); axis equal;  axis([0 2 0 2.4]); drawnow;
    end
end
