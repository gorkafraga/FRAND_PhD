%%%%% PEAK DETECTION IN SEPARATE BLOCKS
%================================================================
% Find P1 and N1 peaks in each block per condition 
% Plot mean amplitude of each peak for each condition( word/symbol) per
% block (x4 blocks of 40 trials)

%----------------------------------------------------------------
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
close all
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Block Variance';
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
%             DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

% Now EEG variable is loaded

%%   Get EEG.data for each of the experimental conditions
%   First find the index of the epochs containing the events specified 
% Output: one variable for each type of event (condition)
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

%% Break each condition into blocks
events = EEG.event;
for l = 1:length(eventIndx);
 % now count blocks and trials of each condition
counter =0;
trials= zeros(1,80); 
blocktrials = zeros(2,40);
    for e = 1:length (events);
         if counter<80 
            if events(e).type == eventIndx(l);
              trials(1,1+counter) = events(e).epoch;
                elseif events(e).type == 12
                    continue
            else
                continue 
            end
            counter = counter+1;
         end        
    end
    trials = trials(trials>0); % remove zeros
    %save blocks in different rows.One block finishes when the differences between 
    %two consecutive epoch indexes is bigger than 35
     for tr = 2:length(trials);
         if (trials(tr)-trials(tr-1))>35;
              blocktrials(1,1:tr-1)= trials(1:tr-1);  %1stblock
              blocktrials(2,1:length(trials(tr:end)))= trials(tr:end) ; %2ndblock
         end
     end
     % get data for each block 
     blocktrials1 = blocktrials(1,:);
     blocktrials2 = blocktrials(2,:);
 if eventIndx(l) == 21
     SW_b1 = EEG.data(:,:,blocktrials1(blocktrials1>0));
     SW_b2 = EEG.data(:,:,blocktrials2(blocktrials2>0));
 elseif eventIndx(l) == 22
    LW_b1 = EEG.data(:,:,blocktrials1(blocktrials1>0));
    LW_b2 = EEG.data(:,:,blocktrials2(blocktrials2>0));
 elseif eventIndx(l) == 23
    SS_b1 = EEG.data(:,:,blocktrials1(blocktrials1>0));
    SS_b2 = EEG.data(:,:,blocktrials2(blocktrials2>0));
 elseif eventIndx(l) == 24
    LS_b1 = EEG.data(:,:,blocktrials1(blocktrials1>0));
    LS_b2 = EEG.data(:,:,blocktrials2(blocktrials2>0));
 end
end
%% Peak detection
cd (DIROUTPUT)
% Prepare output arrays 
   % HEADERS: condition/block/value
        conditions = ['SW'; 'LW';'SS';'LS'] ;   
        blocks = ['_b1';'_b2'];
        values = ['amp';'lat'];
        headerN1 = cell(1,1);
        headerN1(1,1) = {'subject'};
        headerP1=headerN1;
        headerP2 = cell(1,1);
        headerP2(1,1) = {'subject'};
        for c = 1:size(conditions,1);
            sufc = conditions(c,:);% suffix specifying condition
            for b = 1:size (blocks,1); 
                sufb = blocks(b,:);
               for v = 1:size (values,1); 
                sufv = values(v,:);
                    for ch = 1:length(chans); 
                    headerP1 = cat(2,headerP1,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_P1',sufb,'_',sufv]});
                    headerP2 = cat(2,headerP2,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_P2',sufb,'_',sufv]});
                    headerN1 = cat(2,headerN1,{[EEG.chanlocs(chans(ch)).labels,'_',sufc,'_N1',sufb,'_',sufv]});
                    end
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
    P1_blocks = cell(1,1);
    N1_blocks = cell(1,1);
    P2_blocks = cell(1,1);
    
     for c = 1:size(conditions,1);% loop through conditions and blocks
         for b = 1:size(blocks,1);
          data2use = eval([conditions(c,:),blocks(b,:)]);% 
          
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
            if   c == 1; if b == 1; strCond = 'ShortWords_1stBlock'; elseif b==2; strCond = 'ShortWords_2ndBlock';end
             elseif   c == 2 ; if b == 1; strCond = 'LongWords_1stBlock'; elseif b==2; strCond = 'LongWords_2ndBlock';end
             elseif   c == 3 ; if b == 1; strCond = 'ShortSymbols_1stBlock'; elseif b==2; strCond = 'ShortSymbols_2ndBlock';end
             elseif   c == 4 ; if b == 1; strCond = 'LongSymbols_1stBlock'; elseif b==2; strCond = 'LongSymbols_2ndBlock';end 
            end
% 
  %% Plot peaks in selected channels
             for ch = 1:length(chans)
                 figure;
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
               
                  % Save plots                                              
                    newfolder = ['block peak plots'];
                    newsubfolder = [filename(1:4),' block peaks'];
                    newdir = [DIROUTPUT,'\',newfolder];
                    newsubdir = [DIROUTPUT,'\',newfolder,'\',newsubfolder];
                    mkdir(DIROUTPUT,newfolder);
%                     mkdir(newdir,newsubfolder);

                    cd (newdir)
                    saveas (gcf,[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond], 'fig');
                    saveas (gcf,[filename(1:4),'-', EEG.chanlocs(chans(ch)).labels,'-', strCond], 'tiff');
                    close (gcf);
                    cd (DIROUTPUT)
            end

 %% Concatenate conditions in array
         P1amp = P1amp';
         P1_blocks = cat(2,P1_blocks ,num2cell(P1amp));
         P1_blocks = cat(2,P1_blocks ,num2cell(P1lat));
   
         N1amp = N1amp';
         N1_blocks = cat(2,N1_blocks ,num2cell(N1amp));
         N1_blocks = cat(2,N1_blocks ,num2cell(N1lat));
         
         P2amp = P2amp';
         P2_blocks = cat(2,P2_blocks ,num2cell(P2amp));
         P2_blocks = cat(2,P2_blocks ,num2cell(P2lat));

         end
     end
     P1_blocks(1,1) = {N};
     P1_blocks = [headerP1;P1_blocks];
     N1_blocks(1,1) = {N};
     N1_blocks = [headerN1;N1_blocks];
     P2_blocks(1,1) = {N};
     P2_blocks = [headerP2;P2_blocks];
       
% Save variables in matfile: 
   cd (DIRINPUT)
   save(filename, 'EEG','P1_blocks', 'P2_blocks','N1_blocks','-append');
   clear P1_blocks N1_blocks P2_blocks

 else 
            fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
 end
 end

