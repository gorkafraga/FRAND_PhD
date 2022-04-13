% Bar graphs of ERP values 
%===============================
% postdyslexia LSS subjects '401,403:411,413:419,421'
%postdyslexia VWR subjects: 503:512,514:522
% slow dyslectics: 1	2	3	7	8	9	14	15	16	17	18	21	302	304	307	308	309	314	316	318	320
% fast dyslectics: 4	5	6	10	11	12	13	19	20	303	305	306	310	311	312	313	315	317	319
% < 10 percentile school children % 103:105,107,108,110,111,115,117,118,120,121,122
%Channels : 'TP7,PO7,PO3,P9,P7,P5,O1,Iz,Oz,POz,O2,P6,P8,P10,PO4,PO8,TP8'
clear all
close all
cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD_noR\PeakValuesXLS_noR'
%--------------------------------------------------------------------------
%% Pop up for Input of subjects and values to plot
   prompt={'Define ERP component',...
       'Define values to plot: amplitudes (a=words, b=symbols,dif=word-symbol), latencies (aL = words, bL=symbols,difL=wrds-symb)'...
       'Channels (will be averaged by hemisphere)','subjects group1','subjects group2'};
   name='Define subjects and output values to plot';
   numlines=1;
   defaultanswer = {'P1','aL','TP7,PO7,PO3,P9,P7,P5,O1,O2,P6,P8,P10,PO4,PO8,TP8','302:320','201:220'};
   options.Resize='on';
   options.WindowStyle='modal';

   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   ERP =cell2mat(answer(1));
   values2plot=cell2mat(answer(2));
   labels=answer{3}; labels = strrep(labels,',', ' ');
   subjects1=cell2mat(answer(4));subjects1 = str2num(subjects1);
   subjects2=cell2mat(answer(5));subjects2 = str2num(subjects2);

  %% make a cell array with the channel labels from answer one in each cell 
          % Trim off any leading & trailing blanks & Locate white-spaces
            labels=strtrim(labels); spaces=isspace(labels);
           % Build the cell array
            idx=0;
            while sum(spaces)~=0
                idx=idx+1; chanlabels{idx}=strtrim(labels(1:find(spaces==1,1,'first')));
                labels=strtrim(labels(find(spaces==1,1,'first')+1:end)); spaces=isspace(labels);
            end
            chanlabels{idx+1}=labels;

%% load file with component values
filename = ['group',ERP,'.mat'];
load (filename);
groupdata = eval(['group',ERP]);
% % correct small bug with P2 naming
% if strcmp(ERP,'P2')==1; % P2 appears as P3 in the columns (temporal arrangement)
%        ERP = 'P3';
% end
% 
% suffix with the values to plot specified in input (to search in header)
if strcmp(values2plot,'a')==1 || strcmp(values2plot,'b')==1 || strcmp(values2plot,'dif')== 1;
    suffix = ['_',ERP,'amp'];
elseif strcmp(values2plot,'aL')==1 || strcmp(values2plot,'bL')==1 || strcmp(values2plot,'difL')== 1;
    suffix = ['_',ERP,'lat'];
end
if strcmp(ERP,'P2')==1; 
       ERP = 'P2';
end
%% Get header of CHANNELS (same channels for a, b and dif)
nchansindata = size(groupdata(:,(~cellfun('isempty',(strfind(groupdata(1,:),['SW',suffix]))))),2); % total number of channels in the data array
headerchans = groupdata(1,2:nchansindata+1);
for nchan = 1: nchansindata;
    stringlabel = cell2mat(headerchans(nchan));
    cutpoint = regexp(stringlabel,'_');
    headerchans{nchan} = {stringlabel(1:cutpoint(1)-1)};
end
% remove blank rows
emptyCells = cellfun('isempty',groupdata);
groupdata (all(emptyCells,2),:) = []; 
[rows cols ] = size(groupdata);
%% select subjects selected for plot
subjectlist = groupdata(:,1);% control subjects
for rr = 1:length(subjects1);
[indxsubj jnk] = find([cell2mat(subjectlist(2:end,1))]==subjects1(rr));
idss1(rr,:)= indxsubj; 
end
groupdata1 = [groupdata(1,:);groupdata(idss1+1,:)]; %take data for only those subjects (keep header info)
%%% group 2
for rr = 1:length(subjects2);
[indxsubj jnk] = find([cell2mat(subjectlist(2:end,1))]==subjects2(rr));
idss2(rr,:)= indxsubj; 
end
groupdata2 = [groupdata(1,:);groupdata(idss2+1,:)]; %take data for only those subjects (keep header info)
%% Get the correct ERP values - the suffix will specify whether is latencies or amplitudes and of which peak
a1 = groupdata1(:,(~cellfun('isempty',(strfind(groupdata1(1,:),['SW',suffix])))));
a1 = cell2mat(a1(2:end,:)); % rmv headers and transform to num array
a2 = groupdata1(:,(~cellfun('isempty',(strfind(groupdata1(1,:),['LW',suffix])))));
a2 = cell2mat(a2(2:end,:)); 
a = (a1+a2)/2; % Average of short and long words
b1 = groupdata1(:,(~cellfun('isempty',(strfind(groupdata1(1,:),['SS',suffix])))));
b1 = cell2mat(b1(2:end,:)); 
b2 = groupdata1(:,(~cellfun('isempty',(strfind(groupdata1(1,:),['LS',suffix])))));
b2 = cell2mat(b2(2:end,:)); 
b = (b1+b2)/2;%average of short and long symbols
%difference between a and b
dif = a-b; 
%%%%%%%%%%%%%%%%%%%%% group 2
aa1 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['SW',suffix])))));
aa1 = cell2mat(aa1(2:end,:)); % rmv headers and transform to num array
aa2 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['LW',suffix])))));
aa2 = cell2mat(aa2(2:end,:)); 
aa = (aa1+aa2)/2; % Average of short and long words
bb1 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['SS',suffix])))));
bb1 = cell2mat(bb1(2:end,:)); 
bb2 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['LS',suffix])))));
bb2 = cell2mat(bb2(2:end,:)); 
bb = (bb1+bb2)/2;%average of short and long symbols
%difference between a and b
difdif = aa-bb; 
% rename: 
aL=a;bL=b;difL=dif;
aLaL=aa;bLbL=bb;difLdifL=difdif;
%% PLOT - the Computed group Mean and SE for each channel in order
% Bars according to channels specified in Input
% Define values to plot 
data1 = eval(values2plot);
data2 = eval([values2plot,values2plot]);
for l = 1:length(chanlabels);
    col = find(strcmp([headerchans{:}],cell2mat(chanlabels(l))));%index of col. of data that corresponds to input channels
    data2plot(l,1)= mean(data1(:,col));
    data2plot(l,2)= mean(data2(:,col));
%     errorbar2plot(l,1) = std(data1(:,col))/sqrt(length(data1)); 
%     errorbar2plot(l,2) = std(data2(:,col))/sqrt(length(data2));
end

%% Average hemispheres
  hemisphere2plot(1,:) = mean(data2plot(1:7,:));
  hemisphere2plot(2,:) = mean(data2plot(8:14,:));
 % SE for first seven channels (left hemisphere) and last seven channels(right hemisphere)
     errorbar2plot(1,1) = std(mean(data1(:,1:7),2))/sqrt(length(data1));   
     errorbar2plot(2,1) = std(mean(data1(:,8:14),2))/sqrt(length(data1));   
  % SE for first seven channels (left hemisphere) and last seven
   % channels(right hemisphere) for group 2 
     errorbar2plot(1,2) = std(mean(data2(:,1:7),2))/sqrt(length(data2));   
     errorbar2plot(2,2) = std(mean(data2(:,8:14),2))/sqrt(length(data2));  

%% find group name for legend and plot titles
 if  isempty(find(subjects1<100,1))==1 && ~isempty(find(300>subjects1,1))==1 && ~isempty(find(subjects1>200,1))==1;
     groupname1 = ['CntrlAge (n ',num2str(size(subjects1,2)), ')'];
 elseif ~isempty(find(subjects1<100,1))==1  && ~isempty(find(subjects1>300,1))==1;
     groupname1 =  ['Dyslectics (n ',num2str(size(subjects1,2)), ')'];
 elseif ~isempty(find(subjects1>300,1))==1  && ~isempty(find(subjects1<400,1))==1;
     groupname1 =  ['DyslxCntrl (n ',num2str(size(subjects1,2)), ')'];
elseif ~isempty(find(subjects1<100,1))==1
     groupname1 =  ['PretestLSS (n ',num2str(size(subjects1,2)), ')'];
elseif    ~isempty(find(subjects1>100,1))==1 && ~isempty(find(subjects1<300,1))==1;
     groupname1 =  ['PretestVWR group (n ',num2str(size(subjects1,2)), ')'];
elseif    ~isempty(find(subjects1>400,1))==1 && ~isempty(find(subjects1<500,1))==1;
     groupname1 =  ['PostLSS (n ',num2str(size(subjects1,2)), ')'];
elseif    ~isempty(find(subjects1>500,1))==1
     groupname1 =  ['PostVWR (n ',num2str(size(subjects1,2)), ')'];
 end
 % grp 2
 if  isempty(find(subjects2<100,1))==1 && ~isempty(find(300>subjects2,1))==1 && ~isempty(find(subjects2>200,1))==1;
     groupname2 = ['CntrlAge(n ',num2str(size(subjects2,2)), ')'];
elseif ~isempty(find(subjects2<100,1))==1  && ~isempty(find(subjects2>300,1))==1;
     groupname2 =  ['Dyslectics (n ',num2str(size(subjects2,2)), ')'];
elseif ~isempty(find(subjects2>300,1))==1  && ~isempty(find(subjects2<400,1))==1;
     groupname2 =  ['DyslxCntrl (n ',num2str(size(subjects2,2)), ')'];
elseif ~isempty(find(subjects2<100,1))==1
     groupname2 =  ['PretestLSS (n ',num2str(size(subjects2,2)), ')'];
elseif    ~isempty(find(subjects2>100,1))==1 && ~isempty(find(subjects2<300,1))==1;
     groupname2 =  ['PretestVWR (n ',num2str(size(subjects2,2)), ')'];
elseif    ~isempty(find(subjects2>400,1))==1 && ~isempty(find(subjects2<500,1))==1;
     groupname2 =  ['PostLSS (n ',num2str(size(subjects2,2)), ')'];
elseif    ~isempty(find(subjects2>500,1))==1
     groupname2 =  ['PostVWR (n ',num2str(size(subjects2,2)), ')'];
end
%% plot bars 
nbars =  1:2;
 ph = bar(nbars,hemisphere2plot,1,'grouped');
%  ph = bar(1:3,[[0 0];hemisphere2plot],1,'grouped');

set(ph(1), 'FaceColor',[1 1 1 ])
set(ph(2), 'FaceColor',[0 0 0 ])
set(gca, 'XTick',[1 2]);
set(gca,'box','off')
legend([ph(1) ph(2)],groupname1,groupname2, 'Location', 'NorthEast');
set(legend,'Visible','on','FontName','Calibri','FontSize',10);
axis tight
hemisphereLabels = {'LeftHemisphere','RightHemisphere'};
%% adjust ticks
%   set(gca, 'yGrid','on' )
 
    %%%%%%%%if values are latencies     
    if strcmp(values2plot,'difL')== 1;
         Ylim = [min(min(hemisphere2plot))-20 max(max(hemisphere2plot))+ 20];
         set(gca, 'YLim', Ylim, 'YTick',[round(Ylim(1)):5:round(Ylim(2))],'XTickLabel',hemisphereLabels);
     elseif strcmp(values2plot,'aL')== 1 ||  strcmp(values2plot,'bL')== 1;
          %select range of peak for scaling of y axis
            if strcmp(ERP,'P1')== 1;
                 Ylim = [100 175];
            elseif strcmp(ERP,'N1')== 1;
                 Ylim = [200 275];
            elseif strcmp(ERP,'P2')== 1;
                 Ylim = [300 375];
            end
%          Ylim = [min(min(hemisphere2plot))-20 max(max(hemisphere2plot))+ 80];
         set(gca,'YLim',Ylim,'YTick',[0:10:Ylim(2)],'XTickLabel',hemisphereLabels);
    %%%%%%%%if values are amplitudes     
    elseif  strcmp(values2plot,'dif')==1 
         set(gca, 'YLim', [0 10], 'YTick',[0:1:10],'XTickLabel',hemisphereLabels);
    elseif strcmp(values2plot,'a')== 1 ||  strcmp(values2plot,'b')== 1;
         set(gca, 'YLim', [0 25],'YTick',[0:5:25],'XTickLabel',hemisphereLabels);
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
    eh1=errorbar(nbars-width/.75,hemisphere2plot(:, 1), errorbar2plot(:, 1),...
        'Marker', 'none','Color', 'k', 'LineStyle', 'none');
    %errorbar_tick(eh1,0.075,'UNITS');
    eh2=errorbar(nbars+width/.75,hemisphere2plot(:, 2), errorbar2plot(:, 2),...
     'Marker', 'none','Color', 'k', 'LineStyle', 'none');
      %errorbar_tick(eh2,0.075,'UNITS');
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
%% title
 titlename = ['Group ',ERP,' ',description];
 set(gcf,'Name', titlename)
set(gca,'Title',text('String',titlename,'Color','k','FontName','Calibri','FontSize',12,'FontWeight','bold'));
%set(gca, 'Position', [(xlim(1)+ xlim(2)/35),(ylim(2)-ylim(2)/20)]);
 
%% axis labels        
    xlim = get(gca, 'xlim');ylim = get(gca,'Ylim');
    xlbl = xlabel('hemispheres');
    set(gca,'xlim',[xlim(1)-0.2 xlim(2)+0.2]) % adjust position of bars
    set(ylbl,'Position',[0.65,(ylim(2)-5),0],'Rotation',360);
 
    
%     set(ylbl,'Position',[xlim(1),(ylim(2)-ylim(2)/20),0],'Rotation',360);
    set(xlbl,'FontName','Calibri','FontSize',12);
    
     hold on
    plot(get(gca,'Xlim'),[ylim(1) ylim(1)],'color','k') % horiz line at x axis


%% Save plot
set(gcf,'Color',[1 1 1]); 
        DIROUTPUT =  'H:\GORKA\Dissertation_Manuscripts\2_Longitudinal_ERP';
         filename = [strtok(groupname1),'Vs',strtok(groupname2),'_',ERP,'-','hemispheres','_',values2plot];
                    newfolder = 'BarGraphs';
                    newdir = [DIROUTPUT,'\',newfolder];
                    mkdir(DIROUTPUT,newfolder);
                    cd (newdir)
              if  isempty(dir ([filename,'*']))==1;   
%                     saveas (gcf,strrep(filename,'-',''),'fig');
                    saveas (gcf,filename, 'tiff');
              else filename = [filename,'C'];
%                     saveas (gcf,strrep(filename,'-',''),'fig');
                    saveas (gcf,filename, 'tiff'); 
              end
%                      
 %export_fig (sprintf([(filename)]), '-tiff', '-cmyk', '-r300')    

 close (gcf);
cd ..
     


                          
