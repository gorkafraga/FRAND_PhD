%%%%% PEAK DETECTION AFTER REMOVING RESPONSES
%================================================================
% PEAKS : P1 and N1 (N200)
% P1 time range (Maurer GFP based:  55 -163 ms after stimulus onset)
                % Currently used: 50 - 180 ms
% N1 time range (Maurer GFP based:  164 - 273 ms after stimulus onset)
                % currently used: 175 - 325 ms
%----------------------------------------------------------------
% Electrode subset is user defined in popup
% Save the avg amplitude of each electrodes in excel
% Output format: subjects as rows. As columns: (channels / condition) x 2 (latencies and amplitudes)
%-----------------------------------------------------------------
% Channels of interest indexes:
%-----------------------------------------------------------------
% Codes for subsets of electrode (to enter in popup)
    % Default '16,22:30,53,59:64' Includes temporal,parietal and occipital
    % Including all tp, cp, o,p and PO: [16:32,56:64]
    % Parieto/Occipital channels: [23:26,28,30,60:63]labels: P9,PO7,PO3,POz, PO4,PO8,P10,P7, P8,Iz
     %Temporal Channels: [16,53] labels:  TP7,TP8.
     % Occipital channels: [27, 29, 64]O1,Oz,O2 
     % All channels except frontal ones:  [12:32,48:64] 
     
%%  Define directory 
clear all
close all
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD_noR_manual';
%% Input: subject code (groupnNo + subjectNo) and electrodes 
   prompt={'Define group-subject code (1 to 522)','Define channels of interest(chans)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???','16,22:30,53,59:64'};
   options.Resize='on';
   options.WindowStyle='modal';
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN = cell2mat(answer(1)); NN = str2num(NN); %#ok<ST2NM>
   chans=cell2mat(answer(2)); chans = str2num(chans); %#ok<ST2NM>

%% Define filenames. Including group directory and name of group (to use as figurename )

for N = NN; %loop through subjects
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    TABLENAME = 'PreLexi';
    figGroupName(1) = {TABLENAME};
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        TABLENAME = 'PreSchool';
        figGroupName(2) = {TABLENAME};
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        TABLENAME = 'CtrlAge';
        figGroupName(3) = {TABLENAME};  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        TABLENAME = 'CtrlDys';
        figGroupName(4) = {TABLENAME};
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        TABLENAME = 'PostDys';
        figGroupName(5) = {TABLENAME};
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        TABLENAME = 'PostSch';
        figGroupName(6) = {TABLENAME};
        end
  end
  
cd (DIRINPUT)
 %Search in current Dir files 

if ~isempty(dir(FILES))
filename = dir(FILES); 
filename = filename.name;

load (filename); % load the matlab file
filename = strrep(filename,'refAvg', 'refAvg_noR');
% Now EEG variable is loaded

%%  REMOVE RESPONSES FROM EEG.data for each of the experimental conditions
%  First find the index of the epochs containing the events specified 
% Output: one variable for each type of event (condition)
% -------------------------------------------------------------------------
    eventIndx = [21 22 23 24];
    for l = 1:length(eventIndx)%Find epoch indexes looping through event types 
    E = struct2cell(EEG.event); 
    [r, col] = find(cell2mat(E(1,:,:))==eventIndx(1,l));% find epochs for event type
    ep =cell2mat(squeeze(E(4,:,col)));% rows of epIndx are epoch number with the event defined
    [r1, col1] = find(cell2mat(E(1,:,:))==12);% find epochs for event type
    rIndx = cell2mat(squeeze(E(4,:,col1)));%
	    epIndx = setdiff(ep,rIndx); % take only epoch without responses
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

%% Peak detection
cd (DIROUTPUT)

% Prepare output arrays 
   % HEADERS
        conditions = ['EEG_SW'; 'EEG_LW';'EEG_SS';'EEG_LS'] ;   
        values = ['amp';'lat'];
        headerN1 = cell(1,1);
        headerN1(1,1) = {'subject'};
        headerP1=headerN1;
        headerP2 = cell(1,1);
        headerP2(1,1) = {'subject'};
        for c = 1:size(conditions,1);
            sufc = conditions(c,end-1:end);
            for v = 1:size (values,1); 
                sufv = values(v,:);
                for ch = 1:length(chans); 
                headerP1 = cat(2,headerP1,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_P1',sufv]});
                headerP2 = cat(2,headerP2,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_P2',sufv]});
                headerN1 = cat(2,headerN1,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_N1',sufv]});
                end
            end
        end

%  Define time boundaries and indexes for each peak:
P1timeboundaries = [50 180] ;
  [valsp1,P1timeidx(1)] = min(abs(EEG.times-P1timeboundaries(1)));
  [valsp12,P1timeidx(2)] = min(abs(EEG.times-P1timeboundaries(2)));
N1timeboundaries = [175 325];
  [valsn1,N1timeidx(1)] = min(abs(EEG.times-N1timeboundaries(1)));
  [valsn12,N1timeidx(2)] = min(abs(EEG.times-N1timeboundaries(2)));
P2timeboundaries = [250 400] ;
  [valsP2,P2timeidx(1)] = min(abs(EEG.times-P2timeboundaries(1)));
  [valsp32,P2timeidx(2)] = min(abs(EEG.times-P2timeboundaries(2)));
% Define arrays that will contain info for all subjects
    P1 = cell(1,1);
    N1 = cell(1,1);
    P2 = cell(1,1);

     for c = 1:size(conditions,1);% loop through conditions
          data2use = eval(conditions(c,:)); % data contains EEG for each condition
          % Get peak latencies and amplitudes
           % uses mean activity of data for one condition during the times specified and averaging all trials 
            [P1amp,P1maxtimeidx]= max(mean(data2use(chans,P1timeidx(1):P1timeidx(2),:),3),[],2);
            [P2amp,P2maxtimeidx]= max(mean(data2use(chans,P2timeidx(1):P2timeidx(2),:),3),[],2);
            [N1amp,N1maxtimeidx]=max(-1*(mean(data2use(chans,N1timeidx(1):N1timeidx(2),:),3)),[],2);
            % Latencies converted to ms
            P1lat = EEG.times(P1maxtimeidx+P1timeidx(1)-1);
            P2lat = EEG.times(P2maxtimeidx+P2timeidx(1)-1);
            N1lat = EEG.times(N1maxtimeidx+N1timeidx(1)-1);
            %Define name of conditions
            if        c == 1; strCond = 'ShortWords';
             elseif   c == 2 ; strCond = 'LongWords';
             elseif   c == 3 ;strCond = 'ShortSymbols';
             elseif   c == 4 ; strCond = 'LongSymbols'; 
            end

%% Plot selected channels
for ch = 1:length(chans)
   figure('units','normalized','outerposition',[0 0 1 1]);
      %plot average activity
      plot(EEG.times, mean(data2use(chans(ch),:,:),3)); hold on;
      set(gca,'YLim', [-40 40],'XLim',[-500, 1500]) 
      xlabel('Time (ms)'), ylabel('Voltage (\muV)')
      line([200;200],[-40 40], 'linewidth',1,'LineStyle', ':','color', 'k');
     % add peaks
      scatter(P1lat(ch),P1amp(ch))
      scatter(N1lat(ch),-N1amp(ch));
      scatter(P2lat(ch),P2amp(ch))
     % title
      set(gca,'Title',text('String',[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond],'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  %%%%%%%%%%%%%%%%
%%%%% DECIDE WHETHER THE PEAK DETECTION IS CORRECT
 
  prompt={'P1','N1','P2'};
   name='Confirm peak latencies or manually adjust';
   numlines=1;
   defaultanswer = {num2str(P1lat(ch)),num2str(N1lat(ch)),num2str(P2lat(ch))};
   options.Resize='on';
   options.WindowStyle='modal';
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
    
if strcmp (answer{1},num2str(P1lat(ch))) && strcmp (answer{2},num2str(N1lat(ch))) && strcmp (answer{3},num2str(P2lat(ch))); % If input boxes differ from the auto detection recompute peaks
        p = 'y';
 else   p = 'n';
end
 while p== 'n'      
       close (gcf)
         % PLOT BASE FIGURE
         figure('units','normalized','outerposition',[0 0 1 1]);
         % Latencies converted to ms
              %Define name of conditions
              %plot average activity
              plot(EEG.times, mean(data2use(chans(ch),:,:),3)); hold on;
              set(gca,'YLim', [-40 40],'XLim',[-500, 1500]) 
              xlabel('Time (ms)'), ylabel('Voltage (\muV)')
              line([200;200],[-40 40], 'linewidth',1,'LineStyle', ':','color', 'k');
             % add peaks
             
          % RECOMPUTE THE PEAKS WITH NEW VALUES   
            [crapP1 indexP1] = min(abs(EEG.times-str2double(answer{1})));
             temp= mean(data2use(chans,indexP1,:),3);
             P1amp(ch)= temp(ch);
                        P1lat(ch) = EEG.times(indexP1);
             

            [crapN1 indexN1] = min(abs(EEG.times-str2double(answer{2})));
              temp2= mean(data2use(chans,indexN1,:),3);
             N1amp(ch)= temp2(ch);
                        N1lat(ch) = EEG.times(indexN1);

            [crapP2 indexP2] = min(abs(EEG.times-str2double(answer{3})));
               temp3 = mean(data2use(chans,indexP2,:),3);
                   P2amp(ch)= temp3(ch);
                        P2lat(ch) = EEG.times(indexP2);
                    
          scatter(P1lat(ch),P1amp(ch))
          scatter(N1lat(ch),-N1amp(ch));
          scatter(P2lat(ch),P2amp(ch))

%          if ~strcmp (answer{1},num2str(P1lat(ch)));
%             [crap index] = min(abs(EEG.times-str2double(answer{1}))-50);  [crap2 index2] = min(abs(EEG.times-str2double(answer{1}))+50); % 2nd index contains the input latencie + 50 ms
%             [P1amp(ch),P1maxtimeidx(ch)]= max(mean(data2use(ch,index:index2,:),3),[],2);
%                         P1lat(ch) = EEG.times(P1maxtimeidx(ch)+index-1);
%                         scatter(P1lat(ch),-P1amp(ch))
%          elseif ~strcmp (answer{2},num2str(N1lat(ch)));
%             [crap index] = min(abs(EEG.times-str2double(answer{2})));
%             [N1amp(ch),N1maxtimeidx(ch)]=max(-1*(mean(data2use(ch,index,:),3)),[],2);
%                         N1lat(ch) = EEG.times(N1maxtimeidx(ch)+index-1);
%                         scatter(N1lat(ch),-N1amp(ch));
%           elseif ~strcmp (answer{3},num2str(P2lat(ch)));
%             [crap index] = min(abs(EEG.times-str2double(answer{2})));
%             [P2amp(ch),P2maxtimeidx(ch)]= max(mean(data2use(ch,index,:),3),[],2);
%                         P2lat(ch) = EEG.times(P2maxtimeidx(ch)+index-1);
%                         scatter(P2lat(ch),P2amp(ch))
%          end
%           
               % title
              set(gca,'Title',text('String',[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond],'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
               % ask   again
                    prompt={'P1','N1','P2'};
                   name='Confirm peak latencies or manually adjust';
                   numlines=1;
                   defaultanswer = {num2str(P1lat(ch)),num2str(N1lat(ch)),num2str(P2lat(ch))};
                   options.Resize='on';
                   options.WindowStyle='modal';
                   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
                if strcmp (answer{1},num2str(P1lat(ch))) && strcmp (answer{2},num2str(N1lat(ch))) && strcmp (answer{3},num2str(P2lat(ch)));
                        p = 'y';
                 else   p = 'n';
                end
 end

close (gcf)
 end
end       
       
% %% Save plots   
%                     newfolder = [filename(1:4),'_PLOTS'];
%                     newdir = [DIROUTPUT,'\',newfolder];
%                     mkdir(DIROUTPUT,newfolder);
%                     cd (newdir)
%     % saveas (gcf,[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond], 'fig');
%                     
%         saveas (gcf,[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond], 'tiff');
%         close (gcf);
%         cd (DIROUTPUT)
%             end
% 
%     % Concatenate conditions in array
%          P1amp = P1amp';
%          P1 = cat(2,P1,num2cell(P1amp));
%          P1 = cat(2,P1,num2cell(P1lat));
%    
%          N1amp = N1amp';
%          N1 = cat(2,N1,num2cell(N1amp));
%          N1 = cat(2,N1,num2cell(N1lat));
%          
%          P2amp = P2amp';
%          P2 = cat(2,P2,num2cell(P2amp));
%          P2 = cat(2,P2,num2cell(P2lat));
% 
%     end
%      P1(1,1) = {N};
%      P1 = [headerP1;P1];
%      N1(1,1) = {N};
%      N1  = [headerN1;N1];
%      P2(1,1) = {N};
%      P2 = [headerP2;P2];
%   
%      
% % Save variables in matfile: 
%  cd (DIROUTPUT)
%    save(filename, 'P1', 'P2','N1', 'EEG_SW','EEG_LW','EEG_SS','EEG_LS')
% 

 else 
            fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
 end
 end

