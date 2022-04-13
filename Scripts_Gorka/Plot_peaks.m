%%%%% Make plots of the average of the channel per condition and mark peak
%Peaks in Channels of Interest
N1COI = N1(COI,:);
%get peak N1 Y and X values for the plot
N1COI(k,1:2);
XN1 = N1(k,2);
YN1 = N1(k,1);

% Plot that average 
X = time ;
Y = AvgEl(k,:);
plot(X,Y)
%Title
PLOTNAME = [TABLENAME,'-',cell2mat(labels(k))];
%set the ticks for the axes in the plots
    XTick = [-500:100:1500] ;
    rmv = [1:21]; 
    rmv([2,4,6,8,10,12,14,16,18,20]) = []; 
    XTickLabel = num2cell(XTick);
    XTickLabel(rmv) = {''};
    
set(gca,'YLim', [-20 20],'XLim',[-500, 1500],'XTick',XTick, 'XTickLabel',XTickLabel); 
set(gca,'Title',text('String',PLOTNAME,'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
set(get(gca,'XLabel'),'String','time');
set(get(gca,'YLabel'),'String','response index');
line([0 ; 0],[-20 20], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
line([-500 ; 1500],[0 0], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
scatter (cell2mat(XN1), cell2mat(YN1),'filled','marker', '^','markeredgecolor','k','markerfacecolor','k');hold on;
line([200;200],[-20;20], 'linewidth',1,'LineStyle', ':','color', 'k');hold on; 

%save in output dir

% saveas (gcf,PLOTNAME, 'fig');
% saveas (gcf,PLOTNAME, 'tiff')