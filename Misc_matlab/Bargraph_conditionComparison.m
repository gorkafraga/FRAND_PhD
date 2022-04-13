% Bar graphs of ERP values
% Channels : 'TP7,PO7,PO3,P9,P7,P5,O1,Iz,Oz,POz,O2,P6,P8,P10,PO4,PO8,TP8'
clear all
close all
%--------------------------------------------------------------------------
%% Pop up for Input of subjects and values to plot
   prompt={'Define ERP component',...
       'Select channels','select subjects', 'condition1: a(word amp),b(symb amp),aL(word lats),bL(symb lats)',...
       'condition2: a(word amp),b(symb amp),aL(word lats),bL(symb lats)'};
   name='Define subjects and output values to plot';
   numlines=1;
   defaultanswer = {'N1','P9,P7,P5,PO7,PO3,O1,O2,PO4,PO8,P6,P8,P10','1:21,302:320','a','b'};
   options.Resize='on';
   options.WindowStyle='modal';

   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   ERP =cell2mat(answer(1));
   labels=answer{2}; labels = strrep(labels,',', ' ');
    subjects1=cell2mat(answer(3));subjects1 = str2num(subjects1);
   condition1=cell2mat(answer(4));
   condition2=cell2mat(answer(5));
  
  % make a cell array with the channel labels from answer one in each cell 
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
groupdata= eval(['group',ERP]);
%% small bug with P2 naming
if strcmp(ERP,'P2')==1; % P2 appears as P3 in the columns (temporal arrangement)
       ERP = 'P3';
end
%
% suffix with the values to plot specified in input (to search in header)
if (strcmp(condition1,'a')==1 || strcmp(condition1,'b')==1) && (strcmp(condition2,'a')==1  || strcmp(condition2,'b')==1);
    suffix = ['_',ERP,'amp'];
elseif (strcmp(condition2,'aL')==1 || strcmp(condition2,'bL')==1)  && (strcmp(condition2,'aL')==1  || strcmp(condition2,'bL')==1); 
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
groupdata(all(emptyCells,2),:) = []; 
[rows cols ] = size(groupdata);
%% select subjects selected for plot
subjectlist = groupdata(:,1);% control subjects
for rr = 1:length(subjects1);
[indxsubj jnk] = find([cell2mat(subjectlist(2:end,1))]==subjects1(rr));
idss(rr,:)= indxsubj; 
end
groupdata1 = [groupdata(1,:);groupdata(idss+1,:)]; %take data for only those subjects (keep header info)
% %%% group 2
% for rr = 1:length(subjects2);
% [indxsubj jnk] = find([cell2mat(subjectlist(2:end,1))]==subjects2(rr));
% idss2(rr,:)= indxsubj; 
% end
% groupdata2 = [groupdata(1,:);groupdata(idss2+1,:)]; %take data for only those subjects (keep header info)
%% Get the correct ERP values
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
% %%%%%%%%%%%%%%%%%%%%% group 2
% aa1 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['SW',suffix])))));
% aa1 = cell2mat(aa1(2:end,:)); % rmv headers and transform to num array
% aa2 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['LW',suffix])))));
% aa2 = cell2mat(aa2(2:end,:)); 
% aa = (aa1+aa2)/2; % Average of short and long words
% bb1 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['SS',suffix])))));
% bb1 = cell2mat(bb1(2:end,:)); 
% bb2 = groupdata2(:,(~cellfun('isempty',(strfind(groupdata2(1,:),['LS',suffix])))));
% bb2 = cell2mat(bb2(2:end,:)); 
% bb = (bb1+bb2)/2;%average of short and long symbols
% %difference between a and b
% difdif = aa-bb; 
% % rename: 
 aL=a;bL=b;difL=dif;
% aLaL=aa;bLbL=bb;difLdifL=difdif;
%% PLOT - the Computed group Mean and SE for each channel in order
% Bars according to channels specified in Input
% Define values to plot 
data1 = eval(condition1);
 data2 = eval(condition2);
for l = 1:length(chanlabels);
    col = find(strcmp([headerchans{:}],cell2mat(chanlabels(l))));%index of col. of data that corresponds to input channels
    data2plot(l,1)= mean(data1(:,col));
    data2plot(l,2)= mean(data2(:,col));
    errorbar2plot(l,1) = std(data1(:,col))/sqrt(length(data1));
    errorbar2plot(l,2) = std(data2(:,col))/sqrt(length(data2));
end
%% find group and conditions name for legend and plot titles
 if isempty(find(subjects1<100,1))==1 && ~isempty(find(300>subjects1,1))==1 && ~isempty(find(subjects1>200,1))==1;
     groupname1 = ['Control group (n =',num2str(size(subjects1,2)), ')']; 
     else 
     groupname1 = ['Dyslectic group (n =',num2str(size(subjects1,2)), ')'];
 end
 if  strcmp(condition1,'a')==1; condname1 = 'word';
 else condname1 = 'symbol'; 
 end
  if  strcmp(condition2,'a')==1; condname2 = 'word';
 else condname2 = 'symbol'; 
 end
%  if  isempty(find(subjects2<100,1))==1 ~isempty(find(300>subjects2,1))==1 && ~isempty(find(subjects2>200,1))==1;
%      groupname2 = ['Control group (n =',num2str(size(subjects2,2)), ')'];
%      else 
%      groupname2 =  ['Dyslectic group (n =',num2str(size(subjects2,2)), ')'];
%  end
%% plot bars 
nbars =  1:length(chanlabels);
ph = bar(nbars,data2plot,1,'grouped');
set(ph(1), 'FaceColor',[1 1 1 ])
set(ph(2), 'FaceColor',[.3 .3 .3 ])
set(gca, 'TickDir','out')
set(gca,'box','off')
legend([ph(1) ph(2)],condname1,condname2, 'Location', 'NorthEast')
   % modify ticks
%   set(gca, 'yGrid','on' )
    %%%%%%%%if values are latencies     
%     if strcmp(condition,'difL')== 1;
%          Ylim = [min(min(data2plot))-50 max(max(data2plot))+ 50];
%          set(gca, 'YLim', Ylim, 'YTick',[0:15:Ylim(2)],'XTickLabel',chanlabels);
    if strcmp(condition1,'aL')== 1 || strcmp(condition2,'aL')== 1 || strcmp(condition1,'bL')== 1 || strcmp(condition2,'bL')== 1;
         Ylim = [min(min(data2plot))-50 max(max(data2plot))+ 100];
         set(gca,'YLim',Ylim,'YTick',[0:15:Ylim(2)],'XTickLabel',chanlabels);
    %%%%%%%%if values are amplitudes     
%     elseif  strcmp(values2plot,'dif')==1 
%          set(gca, 'YLim', [0 10], 'YTick',[0:1:10],'XTickLabel',chanlabels);
    elseif strcmp(condition1,'a')== 1 || strcmp(condition2,'a')== 1 || strcmp(condition1,'b')== 1 || strcmp(condition2,'b')== 1;
         set(gca, 'YLim', [0 25],'YTick',[0:5:25],'XTickLabel',chanlabels);
    end
   
    xlabel('Electrodes'), ylabel('Voltage (\muV)')
    if strcmp(ERP,'N1')==1
%         && [strcmp(values2plot,'dif')==1 || strcmp(values2plot,'a')==1 || strcmp(values2plot,'b')==1]%If we plot N1 AMPLITUDESse negative values in y axis ticks
%         if  strcmp(values2plot,'dif')==1;
%                 set(gca,'YTickLabel',[0:-1:-10]);
%         else
                set(gca,'YTickLabel',[0:-5:-25]);
%         end
    else
    end
%% error bars (adjust to width of bar)
hold on;
 width= (get(ph(1), 'BarWidth'))/10;
    eh1=errorbar(nbars-width/.75,data2plot(:, 1), errorbar2plot(:, 1),...
        'Marker', 'none','Color', 'k', 'LineStyle', 'none');
    eh2=errorbar(nbars+width/.75,data2plot(:, 2), errorbar2plot(:, 2),...
     'Marker', 'none','Color', 'k', 'LineStyle', 'none');
  
%% Title containing group and size 
%  if strcmp(values2plot,'a')==1; description = 'amplitudes for word stimuli';
%      elseif  strcmp(values2plot,'b')==1; description = 'amplitudes for symbol stimuli';
%      elseif strcmp(values2plot,'dif')==1; description =  'amplitudes for word-symbol differences';
%      elseif strcmp(values2plot,'aL')==1; description =  'latencies for word stimuli';
%      elseif  strcmp(values2plot,'bL')==1; description = 'latencies for symbol stimuli';
%      elseif strcmp(values2plot,'difL')==1; description =  'latencies for word-symbol differences';  
%  end
if (strcmp(condition1,'a')==1 || strcmp(condition1,'b')==1) && (strcmp(condition2,'a')==1  || strcmp(condition2,'b')==1);
    description = ['Amplitudes',' ', condname1, '-',condname2];
elseif (strcmp(condition2,'aL')==1 || strcmp(condition2,'bL')==1)  && (strcmp(condition2,'aL')==1  || strcmp(condition2,'bL')==1); 
    description = ['Latencies',' ', condname1, '-',condname2];
end

 titlename = [groupname1,' ',ERP,' ',description];
    set(gca,'Title',text('String',titlename,'Color','k'));
  
        
        
% %% Save plot
%         DIROUTPUT = pwd;
%                     newfolder = 'bar plots';
%                     newdir = [DIROUTPUT,'\',newfolder];
%                     mkdir(DIROUTPUT,newfolder);
%                     cd (newdir)
%                     titlename=strrep(titlename,'=','');
%                     titlename=strrep(titlename,'-','');
%                     saveas (gcf,titlename,'fig');
%                     saveas (gcf,titlename,'tiff');
% %                     close (gcf);
%                     cd ..
%      


                          
