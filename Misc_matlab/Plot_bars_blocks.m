% READ variables with peak info per block. Save concatenated Excel Files
% with group info and make BAR PLOTS with group mean peak amplitude per
% block and condition
% ===============================================================================
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
     
%%  Define directory and output array
clear all
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
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';
   if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age';  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        end
  end
  
%% Load data
cd (DIRINPUT)

%Search in current Dir files 
if ~isempty(dir(FILES))

filename = dir(FILES); 
filename = filename.name;
load (filename); % load the matlab file

cd (DIROUTPUT);
srow = find(NN==N);
%% reshuffle columns to display first amplitudes and then latencies
    %Horiz concat. of subject no, data of amplitudes and data of latencies
    P1_blocks_resh = [P1_blocks(:,1),P1_blocks(:,(~cellfun('isempty',(strfind(P1_blocks(1,:),'amp'))))),...
                       P1_blocks(:,(~cellfun('isempty',(strfind(P1_blocks(1,:),'lat')))))];                 
    P2_blocks_resh = [P2_blocks(:,1),P2_blocks(:,(~cellfun('isempty',(strfind(P2_blocks(1,:),'amp'))))),...
                        P2_blocks(:,(~cellfun('isempty',(strfind(P2_blocks(1,:),'lat')))))];    
    N1_blocks_resh = [N1_blocks(:,1),N1_blocks(:,(~cellfun('isempty',(strfind(N1_blocks(1,:),'amp'))))),...
                        N1_blocks(:,(~cellfun('isempty',(strfind(N1_blocks(1,:),'lat')))))];
 
 % get  headers  (same for all subjects)
   hP1_blocks = P1_blocks_resh(1,:);
   hP2_blocks = P2_blocks_resh(1,:);
   hN1_blocks = N1_blocks_resh(1,:);

   % get subject value and concatenate
   valuesP1_blocks = P1_blocks_resh(2,:);
   valuesP2_blocks = P2_blocks_resh(2,:);
   valuesN1_blocks = N1_blocks_resh(2,:);
   
   groupP1_blocks(srow,:) = valuesP1_blocks;
   groupP2_blocks(srow,:) = valuesP2_blocks;
   groupN1_blocks(srow,:) = valuesN1_blocks;
   
 else 
            fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
 end
end
% Concatenate headers with the group array
    groupP1_blocks = [hP1_blocks;groupP1_blocks];
    groupP2_blocks = [hP2_blocks;groupP2_blocks];
    groupN1_blocks = [hN1_blocks;groupN1_blocks];
  
  % remove empty rows 
  cd (DIROUTPUT) 
  emptyCells = cellfun('isempty', groupN1_blocks);
  groupP1_blocks(all(emptyCells,2),:) = [];
  groupP2_blocks(all(emptyCells,2),:) = [];
  groupN1_blocks(all(emptyCells,2),:) = [];

%% save in MAT file and Excel sheet indicating the number of subjects and the groups 
%  belong
    subjectn = num2str(size(groupN1_blocks,1)-1);% count rows (without header) 
    subjectlist = num2str(cell2mat(groupN1_blocks(2:end,1))); % str with subjects
    grouplist=str2double(unique(subjectlist(:,1))); %#ok<ST2NM>
    groups = cell(0,0);
    for r = 1:length(grouplist);
        if      size(subjectlist,2)==2; groups(r)= {'Lexi'}; 
        elseif ~isempty(find(grouplist(r)==1))==1; groups(r)= {'Sch'}; 
        elseif ~isempty(find(grouplist(r)==2))==1; groups(r)= {'CtrlAge'};
        elseif ~isempty(find(grouplist(r)==3))==1; groups(r)= {'CtrlDys'};
        elseif ~isempty(find(grouplist(r)==4))==1; groups(r)= {'Lexi2'};
        elseif ~isempty(find(grouplist(r)==5))==1; groups(r)= {'Sch2'};
        else
        end
    end
    
    groups = cell2mat(groups); 
    save([groups,'_PEAKS_blocks.mat'],'groupP1_blocks','groupN1_blocks','groupP2_blocks'); % save in matlab file
    xlswrite([groups,'_P1blocks_',subjectn,'ss.xlsx'],groupP1_blocks,'Sheet1');
    xlswrite([groups,'_P2blocks_',subjectn,'ss.xlsx'],groupP2_blocks,'Sheet1');
    xlswrite([groups,'_N1blocks_',subjectn,'ss.xlsx'],groupN1_blocks,'Sheet1');
 
    %%%% save also in separate sheets amplitudes and latencies
     amplitudesColIdx = length(groupN1_blocks(:,(~cellfun('isempty',(strfind(groupN1_blocks(1,:),'amp'))))));%find number of cols. with amplitudes (same in all groups)
     latenciesColIdx =  groupP1_blocks(1,end-amplitudesColIdx+1:end);
     xlswrite([groups,'_P1blocks_',subjectn,'ss.xlsx'],groupP1_blocks(:,1:1+amplitudesColIdx),'amplitudes');
         xlswrite([groups,'_P1blocks_',subjectn,'ss.xlsx'],[groupP1_blocks(:,1),groupP1_blocks(:,(end-amplitudesColIdx+1):end)],'latencies');
     xlswrite([groups,'_N1blocks_',subjectn,'ss.xlsx'],groupN1_blocks(:,1:1+amplitudesColIdx),'amplitudes');
        xlswrite([groups,'_N1blocks_',subjectn,'ss.xlsx'], [groupN1_blocks(:,1),groupN1_blocks(:,(end-amplitudesColIdx+1):end)],'latencies');
     xlswrite([groups,'_P2blocks','_',subjectn,'ss.xlsx'],groupP2_blocks(:,1:1+amplitudesColIdx),'amplitudes');
       xlswrite([groups,'_P2blocks_',subjectn,'ss.xlsx'], [groupP2_blocks(:,1),groupP2_blocks(:,(end-amplitudesColIdx+1):end)],'latencies');      


%% Bar graphs of N1 amplitudes
%  % Loop: condition, block, channel: 
        conditions = ['SW'; 'LW';'SS';'LS'] ;   
        blocks = ['_b1';'_b2'];
        values = ['amp';'lat'];
    for ch = 1:length(chans);
        for c = 1:size(conditions,1);
%              sufc = conditions(c,:);% suffix specifying condition
                 for b = 1:size (blocks,1); 
%                 sufb = blocks(b,:);
                   header2find = [EEG.chanlocs(chans(ch)).labels,'_',conditions(c,:),'_N1',blocks(b,:),'_','amp'];
                   tmp = strfind(groupN1_blocks(1,:),header2find);tmp(cellfun('isempty',tmp))={0};tmp= find(cell2mat(tmp)==1);%find indexes of headers2find
                   cells2plottmp = groupN1_blocks(:,tmp);
                   cells2plot = cell2mat(cells2plottmp(2:end,:));
                   data2plot(b) = mean(cells2plot(isfinite(cells2plot)));% use "isfinite". Mean won't work if there are NaN (some subjects with no peak value-explore in averages
                   errorbar2plot (b) = std(cells2plot(isfinite(cells2plot)));
                end
                   h = bar(1,data2plot(1),.45,'grouped','FaceColor', [0.8 0.8 0.8]);hold on;
                   errorbar(1,data2plot(1),errorbar2plot(1),'k')
                   h2 = bar(2,data2plot(2),.45,'grouped', 'FaceColor',[0.6 0.6 0.6]);
                   errorbar(2,data2plot(2),errorbar2plot(2),'k')
                   set(gca, 'YLim', [0 30], 'YTick',[0:2:30],'XTick',[1 2],'XTickLabel',[1 2]);
                   xlabel('Blocks'), ylabel('Voltage (\muV)')
                   % title
                    title = [groups,' ',subjectn,'sbjcts',' ',EEG.chanlocs(chans(ch)).labels,' ',conditions(c,:),' N1 block variance'];
                    set(gca,'Title',text('String',title,'Color','k'));
                  % Save plot   
                    newfolder = 'block variance barplots';
                    newsubfolder = [groups,'_N1_blocks','_',subjectn,'ss'];
                    newdir = [DIROUTPUT,'\',newfolder];
                    newsubdir = [DIROUTPUT,'\',newfolder,'\',newsubfolder];
                    mkdir(DIROUTPUT,newfolder);
                    mkdir(newdir,newsubfolder);
                    cd (newsubdir)
                    saveas (gcf,[groups,' ',subjectn,'sbjcts',' ',EEG.chanlocs(chans(ch)).labels,' ',conditions(c,:),' N1block_amps'], 'fig');
                    saveas (gcf,[groups,' ',subjectn,'sbjcts',' ',EEG.chanlocs(chans(ch)).labels,' ',conditions(c,:),' N1block_amps'], 'tiff');
                    close (gcf);
                    cd (DIROUTPUT)
         end
   end
   