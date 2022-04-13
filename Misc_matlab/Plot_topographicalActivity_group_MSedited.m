% ================================================================================
%Group TOPOGRAPHICAL ACTIVITY MAPS
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%-------------------------------------------------------------------------
%% Define output directory 
clear all
close all
[DIROUTPUT] = 'H:\GORKA\Dissertation_Manuscripts\3_Longitudinal_ERP\Topographs';    
% -------------------------------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'1,3:11,13:19,21'};
   options.Resize='on';
   options.WindowStyle='modal';

      answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN=cell2mat(answer(1));NN = str2num(NN);
%% find boundaries of peaks from group peak averages 
%load Group information about peak latencies 
cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD_noR_MS3_longi';
grps = ['groupP1'; 'groupN1'; 'groupP2'];
%grps= ['groupP1';'groupN1'];
for grp= 1:size(grps,1);
    load (grps(grp,:));
    groupdata = eval(grps(grp,:));
    % remove blank rows
    emptyCells = cellfun('isempty',groupdata);
    groupdata (all(emptyCells,2),:) = []; 
    [rows cols ] = size(groupdata);
    % select subjects selected for plot
    subjectlist = groupdata(:,1);
    selected = NN;
    for r = 1:length(selected);
        [indxsubj jnk] = find([cell2mat(subjectlist(2:end,1))]==selected(r));
        idss(r,:)= indxsubj; 
    end
    groupdata1= [groupdata(1,:);groupdata(idss+1,:)]; %take data for only those subjects (keep header info)
    % find latencies
    lats = groupdata1(:,(~cellfun('isempty',(strfind(groupdata1(1,:),['lat'])))));
    mylats = lats(:,[1:7,11:24,28:41,45:58,62:end]); % ONly the channels in the analysis
    bounds(grp,1) = min(min(cell2mat(mylats(2:end,:))));
    bounds(grp,2) = max(max(cell2mat(mylats(2:end,:))));
    meanlat(grp,:) = mean(mean(cell2mat(mylats(2:end,:)),2));
    
end

%--------------------------------------------------------------------------
%% Define subjects. Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  
for N = NN; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    FIGURENAME = 'PreLexi';
    figGroupName(1) = {FIGURENAME};
      
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        FIGURENAME = 'PreSchool';
        figGroupName(2) = {FIGURENAME};
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        FIGURENAME = 'CtrlAge';
        figGroupName(3) = {FIGURENAME};  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        FIGURENAME = 'CtrlDys';
        figGroupName(4) = {FIGURENAME};
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        FIGURENAME = 'PostDys';
        figGroupName(5) = {FIGURENAME};
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        FIGURENAME = 'PostSch';
        figGroupName(6) = {FIGURENAME};
        end
  end
   
%% Get full file name by searching in directory relevant files. 
%  and load ALL files in eeglab. 
cd (DIRINPUT) % 
listFiles = dir(FILES); %Search in current Dir files 
srow = find(NN==N);

for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

    if ~isempty(dir(FILENAME1))
 %% Load matlab file with EEG variable
 load (FILENAME1)
 nchans = EEG.nbchan;
 times = EEG.times;
 chanlocs = EEG.chanlocs;
%       EEG = pop_loadset('filename',FILENAME1);
%       [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%        eeglab redraw
%      
%%   Get EEG.data for each of the experimental conditions
%First find the index of the epochs containing the events specified 
% Out: one variable for each type of event (condition)
% -------------------------------------------------------------------------
eventIndx = [21 22 23 24];
    for l = 1:length(eventIndx)%Find epoch indexes looping through event types 
    E = struct2cell(EEG.event); 
    [r, col] = find(cell2mat(E(1,:,:))==eventIndx(1,l));% find epochs for event type
    epIndx = cell2mat(squeeze(E(4,:,col)));% rows of epIndx are epoch number with the event defined
        if eventIndx(1,l) == 21 % Create one variable for each type of event searched 
            EEG_SW = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 22
            EEG_LW = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 23
            EEG_SS = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 24
            EEG_LS = EEG.data(:,:,epIndx);
        end
    end
    
%% save in group array the average of all trials
group_SW{srow,:}= mean(EEG_SW(:,:,:),3);
    emptyCells = cellfun('isempty', group_SW);
    group_SW(all(emptyCells,2),:) = []; 
group_LW{srow,:}= mean(EEG_LW(:,:,:),3);
    emptyCells = cellfun('isempty', group_LW);
    group_LW(all(emptyCells,2),:) = [];
group_SS{srow,:}= mean(EEG_SS(:,:,:),3);
  emptyCells = cellfun('isempty', group_SS);
    group_SS(all(emptyCells,2),:) = [];
group_LS{srow,:}= mean(EEG_LS(:,:,:),3);
    emptyCells = cellfun('isempty', group_LS);
    group_LS(all(emptyCells,2),:) = [];
    else 
           fprintf('File %s not found\n',FILENAME1);
    end
clear EEG
end
cd .. 
cd .. 
end
 %return to previous folder 

 %% get data 2 plot from group
  % Average each channel 
for k = 1:nchans
  for rr = 1:length(group_SW); 
      rowdata = group_SW{rr,:};
      chandata(k,:) = rowdata(k,:); 
      data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_SW(k,:)=mean(data2average,1);%contains average of one channel
end
 for k = 1:nchans
  for rr = 1:length(group_LW); 
      rowdata = group_LW{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_LW(k,:)=mean(data2average,1);%contains average of one channel
 end
 for k = 1:nchans
  for rr = 1:length(group_SS); 
      rowdata = group_SS{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_SS(k,:)=mean(data2average,1);%contains average of one channel
 end
 for k = 1:nchans
  for rr = 1:length(group_LS); 
      rowdata = group_LS{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_LS(k,:)=mean(data2average,1);%contains average of one channel
 end
 
 groupEEG_words=(groupEEG_SW+groupEEG_LW)/2;
 groupEEG_symbs=(groupEEG_SS+groupEEG_LS)/2;
%% PLOTS
% name figure with the group names used
figGroupName(cellfun('isempty',figGroupName)) = [];
figGroupName=unique(figGroupName);
figGroupName = [sprintf('%s-',figGroupName{1:end-1}),figGroupName{end}];
%%  

%Define conditions to loop
  conditions = ['groupEEG_words'; 'groupEEG_symbs'] ;   
  figurename = [figGroupName, '-topographical map of mean activity'];

  figure (2);
  set(gcf,'name',figurename);
  set(gcf,'Color',[1 1 1] )  

  
for c = 1:size(conditions,1);
    data2use = eval(conditions(c,:)); % data contains EEG for each condition
  % Topographic plot of activity 
        times2plot = round(meanlat'); % plot group mean latency
           
     
     clim = [-14 14];
      if            c == 1 %Define name of conditions
             strCond = 'Words';
         elseif     c == 2 
              strCond = 'Symbols';
      end
  
    for timei=1:length(times2plot)
        % convert time in ms to index
        [junk,timeidx] = min(abs(times-times2plot(timei)));
        % plot in subplot (position defined by time in relation to condit)
        subplot(4,length(times2plot),timei+c*length(times2plot)-length(times2plot));
        set(gcf,'Color',[1 1 1] )  % white background
        if timei == 1; 
             text (-2,0,strCond,'FontSize',12, 'FontWeight','bold','FontName', 'calibri') ;
        end
        
%    CREATE COLORMAP (uses RGB downloaded function to read color names)
%        mymap =[ rgb('MidnightBlue');rgb('Navy');rgb('DarkBlue');...
%                 rgb('MediumBlue');rgb('RoyalBlue');rgb('CornflowerBlue');...        
%                 rgb('White');rgb('White');...
%                 rgb('Salmon');rgb('DarkSalmon');rgb('LightCoral');...
%                 rgb('IndianRed');rgb('FireBrick');rgb('DarkRed')];    
      hismap = [0.08627451	0.184313725	0.239215686	;
                0.164705882	0.192156863	0.525490196	;
                0.223529412	0.270588235	0.639215686	;
                0.254901961	0.305882353	0.662745098	;
                0.384313725	0.380392157	0.71372549	;
                0.737254902	0.694117647	0.874509804	;
                1	1	1	;
                1	1	1	;
                0.97254902	0.631372549	0.717647059	;
                0.949019608	0.301960784	0.419607843	;
                0.933333333	0.149019608	0.215686275	;
                0.929411765	0.117647059	0.141176471	;
                0.662745098	0.109803922	0.133333333	;
                0.282352941	0.078431373	0.090196078	];

  %Plot topography
        topoplot(squeeze(mean(data2use(:,timeidx,:),3)),chanlocs,...
        'maplimits',clim,'electrodes', 'on', 'headrad', 'rim','intsquare', 'on',...
        'colormap',hismap,'style','fill');
        axis tight 
       
       title([ 'ERPs at ' num2str(round(times(timeidx))) 'ms' ], 'FontSize',12, 'FontName', 'calibri')
        tit = get(gca,'Title');titpos=get(tit,'Position');
        set(tit,'Position',[titpos(1) titpos(2)+0.01 titpos(3)]);
                
        grid off
   end
end
    colorbarYtick = {num2str(clim(1)),['+',num2str(clim(2))]};
    CB = colorbar('Position',[0.9500 0.1100 0.015 0.1577],'YTick', [clim(1),0,clim(2)],'FontName','Calibri', 'FontSize', 12);
            cbylab = get(CB,'YtickLabel'); cbylab(3,:)=  ['+',num2str(clim(2))];% add + to ylabels in colorbar
              set (CB,'YTickLabel',cbylab); 
    cbpos = get(CB,'Position'); % Get position and add text manually searching for position.
% OPTIONAL: UNCOMMENT FOR HORIZONTAL COLORBAR   
% CB = colorbar('horiz','Position',[0.7500 0.1100 0.15 0.01],'XTick', [clim(1),0,clim(2)],'FontName','Calibri', 'FontSize', 12);
%             cbxlab = get(CB,'XtickLabel'); cbxlab(3,:)=  ['+',num2str(clim(2))];% add + to ylabels in colorbar
%               set (CB,'XTickLabel',cbxlab); 
%     cbpos = get(CB,'Position'); % Get position and add text manually searching for position.
%     
   text(cbpos(1)*1.85, -cbpos(2)*28,'\muV','FontSize', 12, 'FontWeight','bold', 'FontName', 'calibri');
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    set(gcf,'Color',[1 1 1] )  % white background
%% Save to file in Output Dir   
    cd (DIROUTPUT)
 saveas (gcf,figurename, 'fig');
 saveas (gcf,figurename, 'tiff')
 
 addpath('Z:\fraga\SCRIPTS_2013\export_fig')
 export_fig (sprintf([(figGroupName),'_topo']), '-tiff', '-cmyk', '-r300')
  close gcf
 cd (DIRINPUT)   
 
 
 