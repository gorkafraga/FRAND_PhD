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
DIROUTPUT = 'H:\GORKA\Statistical Analysis\FRAND_SPSS\ERP Analysis Responses Excluded\MS3 analysis_longitudinal';
%% Input: subject code (groupnNo + subjectNo) and electrodes 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???'};
   options.Resize='on';
   options.WindowStyle='modal';
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN = cell2mat(answer); NN = str2num(NN); %#ok<ST2NM>


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
    
srow = find(NN==N);

filename = dir(FILES); 
filename = filename.name;

load (filename); % load the matlab file
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
%% count
 trialcount = zeros(1,4);
 cond = ['EEG_SW';'EEG_LW';'EEG_SS';'EEG_LS'];
    for c = 1:size(cond,1);   
        trialcount(1,c) = size(eval(cond(c,:)),3);
    end
 
 
 
%% Save in group array
 groupcount(1,:)= [0,21,22,23,24];
 groupcount(1+srow,1)= N;
 groupcount(1+srow,2:end) = trialcount;



else 
            fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
            
end

end

%% Save count  


 cd (DIROUTPUT)

 dlmwrite('Trials_in_analysis_group.txt',groupcount)

