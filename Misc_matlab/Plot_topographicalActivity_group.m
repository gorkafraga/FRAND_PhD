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
[DIROUTPUT] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Topography';    
% -------------------------------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN=cell2mat(answer(1));NN = str2num(NN);
%% find boundaries of peaks from group peak averages 
%load Group information about peak latencies 
cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD';
grps = ['groupP1'; 'groupN1'; 'groupP3'];
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
    bounds(grp,1) = min(min(cell2mat(lats(2:end,:))));
    bounds(grp,2) = max(max(cell2mat(lats(2:end,:))));
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

  
for c = 1:size(conditions,1);
    data2use = eval(conditions(c,:)); % data contains EEG for each condition
  % Topographic plot of aclear allctivity 
     times2plot = [0,100,150,200,300,400,500];
%          for b = 1:length(bounds);
%              bounds2plot(b,:) = mean(bounds(b,:));
%         end
% %      times2plot = [0,bounds2plot',bounds2plot(end)+100 ]; 
% %        boundssorted = sort(bounds);
%        times2plot = [0,boundssorted(1,:),boundssorted(2,:),boundssorted(3,:),boundssorted(3,2)+100]

     clim = [-10 10];
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
        if timei == 1; 
             text (-2,0,strCond) ;
        end
        
%         topoplot(squeeze(mean(data2use(:,timeidx,:),3)),chanlocs,'plotrad',.53,'maplimits',clim );
          topoplot(squeeze(mean(data2use(:,timeidx,:),3)),chanlocs,'maplimits',clim );

        title([ 'ERPs at ' num2str(round(times(timeidx))) 'ms' ], 'FontSize',8)
        tit = get(gca,'Title');titpos=get(tit,'Position');
        set(tit,'Position',[titpos(1) titpos(2)+0.1 titpos(3)]);
                
        grid off
   end
 end
    colorbar('Position',[0.9500 0.1100 0.015 0.1577]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    
    %% Save to file in Output Dir 
    
    cd (DIROUTPUT)
  saveas (gcf,figurename, 'fig');
  saveas (gcf,figurename, 'tiff')
 % close gcf
 cd (DIRINPUT)   
 
 
 