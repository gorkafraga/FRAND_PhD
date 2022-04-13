%%scatter plot of y over x where: 
    % X = response latencies
    % Y = indexes of responses
 FILENAME =  's001-responses.xls';
 PLOTNAME = strrep (FILENAME, 'responses.xls', 'resp-plot');
% load excel file with responses latencies
responses = xlsread (FILENAME); 
responses(isnan(responses)) = 0;
%read cols of the different events
X21 = responses(2:end,3);
X21(X21==0) = []; 
Y21 = 1:length(X21);
X22 = responses(2:end,6);
X22(X22==0) = []; 
Y22 = 1:length(X22);
X23 = responses(2:end,9);
X23(X23==0) = []; 
Y23 = 1:length(X23);
X24 = responses(2:end,12);
X24(X24==0) = []; 
Y24 = 1:length(X24);

%set the ticks for the axes in the plot
    XTick = [-500:100:1500] ;
    rmv = [1:21]; 
    rmv([2,4,6,8,10,12,14,16,18,20]) = []; 
    XTickLabel = num2cell(XTick);
    XTickLabel(rmv) = {''};

% generate scatter plots, and define axis properties and legends

scatter (X21, Y21,'filled','marker', 'o','markeredgecolor','k','markerfacecolor','w');hold on;
scatter (X22, Y22,'filled','marker', 'o','markeredgecolor','k','markerfacecolor','k');hold on; 
scatter (X23, Y23,'filled','marker', '^','markeredgecolor','k','markerfacecolor','w');hold on;
scatter (X24, Y24,'filled','marker', '^','markeredgecolor','k','markerfacecolor','k');hold on;

set(gca,'YLim', [0 50],'XLim',[-600, 1600],'XTick',XTick, 'XTickLabel',XTickLabel); 
set(gca,'Title',text('String',FILENAME,'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
set(get(gca,'XLabel'),'String','time');
set(get(gca,'YLabel'),'String','response index');
legend ('shortwords', 'longwords', 'shortsymbols','longsymbols')
line([0 ; 0],[0 ;50 ], 'linewidth',1,'LineStyle', ':','color', 'k ');hold on; 

% save plot in current directory
% 
% saveas (gcf,PLOTNAME, 'fig');
% saveas (gcf,PLOTNAME, 'tiff')
