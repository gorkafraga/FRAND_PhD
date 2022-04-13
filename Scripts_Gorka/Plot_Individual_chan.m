
%Open manually the average figures of electrodes of interest 
% Run this after opening each (it modifies 'gca' axes of current graph) 
%------------------------------------------------------------------------
%Give the name of the electrode you just opened to a popup window

prompt={'Which electrode figure did you just open?','Which group Grand Average?'};
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
%Include ticks every 100 ms after 0 and label: % -1500,0,200(N2comp),500,1500
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
% save figure in separate files: 'matlab' and 'tiff' formats 
saveas(gca, FILENAME,'fig');
saveas(gca, FILENAME,'tiff');







