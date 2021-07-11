function sub_pos = prepare_new_figure(subplotsx,subplotsy)
%parameters for figure and panel size 
plotheight=29.7;
plotwidth=21;
leftedge=1.2;
rightedge=0.4;   
topedge=1;
bottomedge=1.5;
spacex=1;
spacey=1; 
sub_pos=subplot_pos(plotwidth,plotheight,leftedge,rightedge,bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);
 
%setting the Matlab figure
f=figure('visible','on');
clf(f);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 plotwidth plotheight]);

end