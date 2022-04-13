
%Open manually the average figures of electrodes of interest 
% Run this after opening each (it modifies 'gca' axes of current graph) 
%------------------------------------------------------------------------
%Give the name of the electrode you just opened to a popup window

   prompt={'Which electrode plot did you just open?','Which group Grand Average?'};
   name='Figure name';
   numlines=1;
   defaultanswer = {'???','???'};
   options.Resize='on';
   options.WindowStyle='modal';
  
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   Electrode=cell2mat(answer(1));
   Group=cell2mat(answer(2));
 
   
 DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\GrandAverages';
 cd (DIRNAME);
 % Name the file with this info
FILENAME = [Group,'-',Electrode];
%% Include ticks every 100 ms after 0 and label: % -1500,0,200(N2comp),500,1500
L = [1:1600];
X = L(1:100:length(L))-1;
XTick = [-500,X];
s = size(XTick);
XTickLabel = cell(1,s(2));
XTickLabel(1)= {-500};
XTickLabel(2)= {0};
XTickLabel(4)= {200};
XTickLabel(7)= {500};
XTickLabel(12)= {1000};
XTickLabel(17)= {1500};
set(gca,'XTick', XTick,'XTickLabel',XTickLabel)
set(gca,'YMinorTick','off','XMinorTick','on')
ylim = get(gca,'Ylim');
xlim = get(gca,'Xlim');
%% Edit plot for manuscript format
set(legend, 'String', {'words', 'Symbols'},'Visible','off');
children = get(gca,'Children');
for l= 1:length(children);
    % get the channel name axes
   if strcmp(get(children(l),'Type'),'text');
      chname = children(l);
      % save it also as figure name
      set(gcf,'Name',get(children(l),'String'));
   end
%     %remove lines
    linestyle = get(children(l),'LineStyle');
    linewidth = get(children(l),'LineWidth');
     if strcmp(linestyle,'-')== 1 && ~isempty(find(linewidth==0.5,1))==1;
       set(children(l),'visible','off')
     end 
end
% set channel name new position
set(chname, 'Position', [ xlim(2) (ylim(2)-ylim(2)/8) 0],'FontSize', 20,'Visible','on')
% mark components
text(125,10, 'P1','FontSize',12)
text(320,10, 'P2','FontSize',12)
text(170,-16, 'N1','FontSize',12)
%make box without ticks
line(get(gca,'XLim'), [ylim(2),ylim(2)],'Color', 'k','LineWidth',.1)
line([xlim(2), xlim(2)],ylim, 'Color', 'k');
% line([0 0],ylim,'LineStyle', ':','Color','k')
% line([100 100],ylim,'LineStyle', ':')
% line([200 200],ylim,'LineStyle', ':')
% line(get(gca,'XLim'),[0 0],'Color', 'k','LineWidth',.1)
% change  font size of labels and ticks
set(get(gca,'XLabel'),'FontSize',12);
set(get(gca,'YLabel'),'FontSize',12);
set(gca,'FontSize', 10); % to change general size (tick labels

%% save figure in separate files: 'matlab' and 'tiff' formats 
saveas(gca, FILENAME,'fig');
saveas(gca, FILENAME,'tiff');







