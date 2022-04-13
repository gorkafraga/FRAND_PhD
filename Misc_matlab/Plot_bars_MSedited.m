%% data

cond1g1 = [6.00,	12.65,	11.78,	8.36,	15.57,	10.35,	13.02,	12.28,	10.74,	17.42,	10.08,	14.57,	15.28,	8.39]';
cond2g1 = [4.65,	8.41,	8.88,	7.01,	11.38,	8.88,	9.87,	8.97,	8.44,	11.62,	7.25,	10.11,	10.41,	5.87]';
group1 = [cond1g1, cond2g1];
group1diff = [cond1g1 -  cond2g1];

cond1g2 = [7.05,	15.37,	14.79,	10.29,	18.33,	10.94,	13.65,	12.96,	10.39,	17.49,	9.62,	15.09,	15.50,	7.87]';
cond2g2 = [4.83,	9.81,	10.36,	7.93,	13.29,	9.11,	10.47,	10.20,	8.90,	13.01,	7.93,	11.43,	11.33,	6.39]';
group2 = [cond1g2, cond2g2];
group2diff = [cond1g2 - cond2g2] ;
%% channel to plot 
 prompt={'Define channel'};
   name='Define subjects and output values to plot';
   numlines=1;
   defaultanswer = {'TP7,PO7,PO3,P9,P7,P5,O1,O2,P6,P8,P10,PO4,PO8,TP8'};
   options.Resize='on';
   options.WindowStyle='modal';
    
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   labels=answer{1}; labels = strrep(labels,',', ' '); 
  %% make a cell array with the channel labels from answer one in each cell 
          % Trim off any leading & trailing blanks & Locate white-spaces
            labels=strtrim(labels); spaces=isspace(labels);
           % Build the cell array
            idx=0;
            while sum(spaces)~=0
                idx=idx+1; chanlabels{idx}=strtrim(labels(1:find(spaces==1,1,'first')));
                labels=strtrim(labels(find(spaces==1,1,'first')+1:end)); spaces=isspace(labels);
            end
            chans{idx+1}=labels;
%   allchans = {'Fp1',	'AF7',	'AF3',	'F1',	'F3',	'F5',	'F7',	'FT7',	'FC5',	'FC3',	'FC1',	'C1',	'C3',	'C5',	'T7',...
%       'TP7',	'CP5',	'CP3',	'CP1',	'P1',	'P3',	'P5',	'P7',	'P9',	'PO7',	'PO3',	'O1',	'Iz',	'Oz',	'POz',...
%       'Pz',	'CPz',	'Fpz',	'Fp2',	'AF8',	'AF4',	'Afz',	'Fz',	'F2',	'F4',	'F6',	'F8',	'FT8',	'FC6',	'FC4',	'FC2',...
%       'FCz',	'Cz',	'C2',	'C4',	'C6',	'T8',	'TP8',	'CP6',	'CP4',	'CP2',	'P2',	'P4',	'P6',	'P8',	'P10',	'PO8',...
%       'PO4',	'O2'};
allchans = {'TP7', 'P9','P7','P5','PO7','PO3','O1','O2','PO4','PO8','P6','P8','P10', 'TP8'};


%make a cell array with the channel labels from answer one in each cell 
          % Trim off any leading & trailing blanks & Locate white-spaces
            labels=strtrim(labels); spaces=isspace(labels);
           % Build the cell array
            idx=0;
            while sum(spaces)~=0
                idx=idx+1; chanlabels{idx}=strtrim(labels(1:find(spaces==1,1,'first')));
                labels=strtrim(labels(find(spaces==1,1,'first')+1:end)); spaces=isspace(labels);
            end
            chanlabels{idx+1}=labels;
  for l = 1:length(chans); 
      ch(l)= find(strcmp(chans(l), allchans));
  end
%% PLOT 
data2plot = [group1diff,group2diff];
nbars =  1:length(ch);
bg = bar(nbars,data2plot(ch),1,'grouped');
set(bg(1), 'FaceColor',[.85 .85 .85 ])
set(bg(2), 'FaceColor',[.3 .3 .3 ])
set(gca, 'TickDir','out')
set(gca,'box','off')
legend([bg(1) bg(2)],'Typical readers','Dyslectics', 'Location', 'NorthEast');
set(legend,'Visible','on');
   % modify ticks
%   set(gca, 'yGrid','on' )
    %%%%%%%%if values are latencies     
    if strcmp(values2plot,'difL')== 1;
         Ylim = [min(min(data2plot))-50 max(max(data2plot))+ 50];
         set(gca, 'YLim', Ylim, 'YTick',[0:15:Ylim(2)],'XTickLabel',chanlabels);
     elseif strcmp(values2plot,'aL')== 1 ||  strcmp(values2plot,'bL')== 1;
         Ylim = [min(min(data2plot))-50 max(max(data2plot))+ 100];
         set(gca,'YLim',Ylim,'YTick',[0:15:Ylim(2)],'XTickLabel',chanlabels);
    %%%%%%%%if values are amplitudes     
    elseif  strcmp(values2plot,'dif')==1 
         set(gca, 'YLim', [0 10], 'YTick',[0:1:10],'XTickLabel',chanlabels);
    elseif strcmp(values2plot,'a')== 1 ||  strcmp(values2plot,'b')== 1;
         set(gca, 'YLim', [0 25],'YTick',[0:5:25],'XTickLabel',chanlabels);
    end
   
    if strcmp(ERP,'N1')==1 && [strcmp(values2plot,'a')==1 || strcmp(values2plot,'b')==1]%If we plot N1 AMPLITUDESse negative values in y axis ticks
        if  strcmp(values2plot,'dif')==1;
                set(gca,'YTickLabel',[0:-1:-10]);
        else
                set(gca,'YTickLabel',[0:-5:-25]);
        end
    else
    end
%% error bars (adjust to width of bar)
hold on;
addpath 'C:\Program Files\MATLAB\Errorbar_tick';% to use function for tick width
 width= (get(ph(1), 'BarWidth'))/10;
    eh1=errorbar(nbars-width/.75,data2plot(:, 1), errorbar2plot(:, 1),...
        'Marker', 'none','Color', 'k', 'LineStyle', 'none');
    errorbar_tick(eh1,0.075,'UNITS');
    eh2=errorbar(nbars+width/.75,data2plot(:, 2), errorbar2plot(:, 2),...
     'Marker', 'none','Color', 'k', 'LineStyle', 'none');
      errorbar_tick(eh2,0.075,'UNITS');
%% Title containing group and size 
 if strcmp(values2plot,'a')==1; description = 'amplitudes for word stimuli';
           ylbl = ylabel('[\muV]');% ylbl = ylabel('mean amplitude ( \muV)');
     elseif  strcmp(values2plot,'b')==1; description = 'amplitudes for symbol stimuli';
            ylbl = ylabel('[\muV]');  % ylbl = ylabel('mean amplitude ( \muV)');
     elseif strcmp(values2plot,'dif')==1; description =  'amplitudes for word-symbol differences';
            ylbl = ylabel('[\muV]');  % ylbl = ylabel('mean amplitude difference ( \muV)');
 elseif strcmp(values2plot,'aL')==1; description =  'latencies for word stimuli';
            ylbl = ylabel('[ms]'); % ylbl = ylabel('mean latency (ms)');
     elseif  strcmp(values2plot,'bL')==1; description = 'latencies for symbol stimuli';
           ylbl = ylabel('[ms]'); % ylbl = ylabel('mean latency (ms)');
     elseif strcmp(values2plot,'difL')==1; description =  'latencies for word-symbol differences';  
           ylbl = ylabel('[ms]'); % ylbl = ylabel('mean latency difference (ms)');
 end

 titlename = ['Group ',ERP,' ',description];
         set(gcf,'Name', titlename)
     set(gca,'Title',text('String',titlename,'Color','k'));
  %% axis labels        
    xlim = get(gca, 'xlim');ylim = get(gca,'Ylim');
    xlbl = xlabel('Electrodes');
     set(ylbl,'Position',[(xlim(1)+ xlim(2)/35),(ylim(2)-ylim(2)/20),0],'Rotation',360);
    set(xlbl,'FontAngle','italic');
%% Save plot
        DIROUTPUT =  'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD';
         filename = [strtok(groupname1),'Vs',strtok(groupname2),'_',ERP,'-',num2str(length(chanlabels)),'chans','_',values2plot];
                    newfolder = 'BarGraphs';
                    newdir = [DIROUTPUT,'\',newfolder];
                    mkdir(DIROUTPUT,newfolder);
                    cd (newdir)
              if  isempty(dir ([filename,'*']))==1;   
                    saveas (gcf,strrep(filename,'-',''),'fig');
                    saveas (gcf,filename, 'tiff');
              else filename = [filename,'I'];
                    saveas (gcf,strrep(filename,'-',''),'fig');
                    saveas (gcf,filename, 'tiff'); 
              end
                     close (gcf);
                    cd ..
     


                          
