% =========================================================================
% GROUP STATISTICS OF RESPONSES DURING TASK (false alarms)
% =========================================================================
clear all
close all
DIROUTPUT = 'H:\GORKA\Statistical Analysis\FRAND_SPSS\ERP Analysis Responses Excluded\MS3 analysis_longitudinal\false alarms';
%----------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???'};
   options.Resize='on';
   options.WindowStyle='modal';

   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   n=cell2mat(answer(1));n = str2num(n);
  
%--------------------------------------------------------------------------
%% Define subjects. Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%% Define output arrays:
  % Define array 1 with number of responses
 header = {'TotalR_epochs','RTrials_21','RTrials_22','RTrials_23','RTrials_24','Subject'};
 ResponseTrials = cell(1,length(header));
 ResponseTrials (1,1:end) = header;
 
 for N = n; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    GROUP = 'PreLexi';
    groupnames(1) = {GROUP};
        if N < 10 
           FILES =['s','00',num2str(N),'-*refAvg.mat'];
        elseif N >=10 && N<100   
           FILES =['s','0',num2str(N),'-*refAvg.mat'];
        end
  elseif N >=100
        FILES =['s',num2str(N),'-*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        GROUP = 'PreSchool';
        groupnames(2) = {GROUP};
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        GROUP = 'CtrlAge';
        groupnames(3) = {GROUP};  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        GROUP = 'CtrlDys';
        groupnames(4) = {GROUP};
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        GROUP = 'PostDys';
        groupnames(5) = {GROUP};
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        GROUP = 'PostSch';
        groupnames(6) = {GROUP};
        end
  end
   
cd (DIRINPUT)
%Search in current Dir files 
listFiles = dir(FILES); %Search in current Dir files 

%% load file in EEG
for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

  if ~isempty(dir(FILENAME1))
      srow=find(N==n); 
%       [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
  %% Get values for Overall and Each Event separately
   ResponseTrials (1+srow,end) = {N};
% OVERALL //////////////////////////////////////////////////////////////
      load(FILENAME1)
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
       eeglab redraw
    % Get all responses
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); 
     R = cell2mat(allepochval);% all responses
    % TOTAL epochs with single resp and total with multiple resps
     A  = cellfun ('prodofsize', allepochval); 
      RTrials = find(A>=1); 
      RTrials = length(RTrials);
    ResponseTrials (1+srow,1) = {RTrials}; % save in next column if is not zero
 % Event 21 //////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 21); 
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
     for r = 1:length(R);
           if ~find(R)==0; 
                A  = cellfun ('prodofsize', allepochval); % n of elements in cells of allepochval
               %----save response epoch s
               RTrials_21 = find(A>=1); 
               RTrials_21 = length(RTrials_21);
             ResponseTrials (1+srow,1+1) = {RTrials_21}; % save in next column if is not zero
           end;
     end;
     EEG = eeg_retrieve (ALLEEG, 1);
     
     % Event 22 //////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 22); 
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
     for r = 1:length(R);
           if ~find(R)==0; 
                A  = cellfun ('prodofsize', allepochval); % n of elements in cells of allepochval
               %----save response epoch s
               RTrials_22 = find(A>=1); 
               RTrials_22 = length(RTrials_22);
             ResponseTrials (1+srow,1+2) = {RTrials_22}; % save in next column if is not zero
           end;
     end;
     EEG = eeg_retrieve (ALLEEG, 1);
       % Event 23 //////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 23); 
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
     for r = 1:length(R);
           if ~find(R)==0; 
               A  = cellfun ('prodofsize', allepochval); % n of elements in cells of allepochval
               %----save response epoch s
               RTrials_23 = find(A>=1); 
               RTrials_23 = length(RTrials_23);
             ResponseTrials (1+srow,1+3) = {RTrials_23}; % save in next column if is not zero
           end;
     end;
     EEG = eeg_retrieve (ALLEEG, 1);
           % Event 24 //////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 24); 
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
     for r = 1:length(R);
           if ~find(R)==0; 
               A  = cellfun ('prodofsize', allepochval); % n of elements in cells of allepochval
               %----save response epoch s
               RTrials_24 = find(A>=1); 
               RTrials_24 = length(RTrials_24);
             ResponseTrials (1+srow,1+4) = {RTrials_24}; % save in next column if is not zero
           end;
     end;
     EEG = eeg_retrieve (ALLEEG, 1);

clear RTrials RTrials_21 RTrials_22 RTrials_23 RTrials_24
ALLEEG = pop_delset(ALLEEG,1:length(ALLEEG));
eeglab redraw; 


    else 
           fprintf('File %s not found\n',FILENAME1);
  end
end
 end 

 %% GROUP STATISTICS IN array:
  % Define array 1 with number of responses
 header = {'','TotalR_epochs','RTrials_21','RTrials_22','RTrials_23','RTrials_24'};
 GroupRespTrials = cell(1,length(header));
 GroupRespTrials(1,1:end) = header;
 GroupRespTrials(2,1) = {'mean'};
 GroupRespTrials(3,1) = {'SE'};
% Set blank cells to zero
for rw = 1:size(ResponseTrials,1);
    for cl=1:size(ResponseTrials,2);
        if cellfun('isempty', ResponseTrials(rw,cl)) ==1;
            ResponseTrials(rw,cl) = {0};
        end
    end
end
 data2avg = ResponseTrials(2:end,1:end-1);
 means = mean(cell2mat(data2avg));
  SE = std(cell2mat(data2avg))/sqrt(size(data2avg,1));
  GroupRespTrials(4,1) = {['ngroup =',' ']}; 
  GroupRespTrials(4,2)= {num2str(size(data2avg,1))};

for c = 1:size(data2avg,2);
  GroupRespTrials(2,1+c)= {means(c)};
  GroupRespTrials(3,1+c)= {SE(c)};
end
 
%% Save ================================================================
% name figure with the group names used
groupnames(cellfun('isempty',groupnames)) = [];
groupnames=unique(groupnames);
groupnames = [sprintf('%s-',groupnames{1:end-1}),groupnames{end}];

    %%% Go to common folder ('Responses') and save there outpuf for each S
    cd (DIROUTPUT); 
    newfilename = [groupnames,'_RespTrials'];
    groupnewfilename = [groupnames,'_StatRespTrials'];
   % save as excel file and mat
    save (strrep(newfilename,'-','_'), 'ResponseTrials');
    save (strrep(groupnewfilename,'-','_'), 'GroupRespTrials');
    xlswrite(newfilename, ResponseTrials);
    xlswrite(groupnewfilename, GroupRespTrials);

    cd (DIRINPUT)
       
  clear RTrials RTrials_21 RTrials_22 RTrials_23 RTrials_24
  close all
  
  
