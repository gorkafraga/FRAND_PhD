clear all
close all
%%%%% CHECK FOR RESPONSES LATENCIES AND NUMBER. ALSO EPOCHS WITH RESPONSES
% %%%%% CREATES 2 LISTS IN EXCEL:
% %%%%% sXXX-responses: (variable 'responses' in script)
%             1- Latencies of each response per event. 
%             2- Number of epochs with multiple responses (per event)
%             3- Number of epochs with single response( per event)
%             4- Total of 2 & 3
% %%%%% sXXX-resp-stats: (varible 'resp-stats'in script)
%               1- Average latency of all responses per event.
%               2- SD of latencies per event
%               3- Number of responses per event
%               4- Total number of responses,avg,SD
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5)'; 'Define Subjects (1:22)'};
   name='Input subject and group';
   numlines=1;
   defaultanswer = {'?','??'};
   options.Resize='on';
   options.WindowStyle='modal';
   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2num(G); 
   N=cell2mat(answer(2));N = str2num(N);
   
%--------------------------------------------------------------------------

DIROUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Responses\Detected targets responses'; % Common directory where output is saved
DIRNAME = 'Z:\fraga\EEG_Gorka\Raw data\Raw VWR data\Raw_VWR';

FILENAME1 = 's201-vwr.bdf'; 

EEG = pop_biosig( FILENAME1, 'channels',[1:72], 'ref',[69,70]);
%% Get events before experiment and find resting state event ============        
    % All events: find uniques 
        e = squeeze(struct2cell(EEG.urevent));
        typev = cell2mat(e(1,:));
        E = unique(typev); 

% 61461 is stimulus event. 
% 61462 is TARGET event.and 61696 its repetition
% 61696 there are 56, contain trial stimuli and repeated stimuli
% 61699 there are responses.
% 61440 there are 1.

%Find response indexes
rid = find(typev==61699 | typev==61696);
hitRTs = cell(1,32);
for L = 1:length(rid); 
    if (typev(rid(L)-2)== 61462);
        hitRTs{L} = cell2mat(e(2,rid(L))) - cell2mat(e(2,rid(L)-2));
%     elseif (typev(rid(L)-1)== 61462);
%         hitRTs{L} = cell2mat(e(2,rid(L))) - cell2mat(e(2,rid(L)-2));
%     end
    end
end



for G = G; %Select group folder in which it will make the count
    if  G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\RejEpochs&ICA';
        elseif G == 1
         DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\RejEpochs&ICA';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Control\Visual_word_analysis\Control_school\RejEpochs&ICA';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\RejEpochs&ICA';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\RejEpochs&ICA';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\RejEpochs&ICA';
    end;



for N = N; 
  if N < 10
     [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-Epoched'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-Epoched'];
  end
 
FILENAME1 = [FILENAME, '.set'];
cd (DIRNAME);
    
if ~isempty(dir(FILENAME1))
eeglab;   
EEG = pop_loadset(FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%%%% GET THE TOTAL RESPONSES TO CREATE 'LATENCIES'ARRAY AND THEN WRITE
%%%RESPONSES PER EVENT
%------------------------------------------------------------------------
%Use 2nd output of getepoch. Better when multiple resp in epoch

 [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); 
 R = cell2mat(allepochval);% all responses
 % ---create list variables
 header = {'TotalEpR','TotalEpMR','21','epR','epMR', '22','epR','epMR','23','epR','epMR', '24','epR','epMR'};
 responses = cell(1,14);%LIST with many rows as responses + headers
 responses (1,1:end) = header;
 
  header2 = {'','TotalR','21','22','23','24'};
  rownames = {'avg', 'SD', 'n'};  
  respstats = cell(4, 6); 
  respstats(1,:) = header2;
  respstats(2:end,1)= rownames;
  % --- fill in total average, SD and n
  respstats (2,2)= { mean(R)};
  respstats (3,2) = {std(R)};
  respstats (4,2) = {length(R)};
  
 % - count total epochs with single resp and total with multiple resps
  A  = cellfun ('prodofsize', allepochval); 
   epR = find(A==1); 
   epR = length(epR);
responses (2,1) = {epR};
   epMR = find(A>1);  % Find cells in A with more than 1 element
   epMR = length(epMR);
  responses(2,2) = {epMR}; 

 % % %---------------------Event 21
 % %//////////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 21); 
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
      
       for r = 1:length(R);
           if ~find(R)==0; 
               %----save responses as rows under corresponding event column
             responses (1+r,3) = {R(r)}; % save in next column if is not zero
               A  = cellfun ('prodofsize', allepochval); % n of elements in cells of allepochval
               %----save n single response epoch 
               epR = find(A==1); 
               epRcount = length(epR);
             responses (2,4) = {epRcount}; % save in next column if is not zero
               % ---- save n of epochs with multiple responses
                MR = find(A>1);  % Find cells in A with more than 1 element
                EpMR = length(MR);
              responses(2,5) = {EpMR}; 
               % --- fill in  average, SD and n
                  respstats (2,3)= { mean(R)};
                  respstats (3,3) = {std(R)};
                  respstats (4,3) = {length(R)};
%               % ----save n Epochs in which there are multiple responses
%                 sumMR=zeros(1,length(MR));
%                 A  = cellfun ('prodofsize', allepochval);% n of elements in cells of allepochval
%                 MR = find(A>1);  % Find cells in A with more than 1 element
%                     for s = 1:length(MR); % count epochs with more than 1 elemnt 
%                         E = MR(s);% get epoch number
%                         EpMR = allepochval(E);% go to each cell with MR
%                         nMR = cellfun ('prodofsize', EpMR); % get n of multiple Rs
%                         sumMR(s) = nMR;
%                     end;
%                 sumMR = sum(sumMR);    
%              responses(2,5) = {sumMR} ;
           end;
         end;
     EEG = eeg_retrieve (ALLEEG, 1);
     
 % % %---------------------Event 22
 % %//////////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 22); 
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
      
       for r = 1:length(R);
           if ~find(R)==0; 
               %----save responses as rows under corresponding event column
             responses (1+r,6) = {R(r)}; % save in next column if is not zero
                A  = cellfun ('prodofsize', allepochval);% n of elements in cells of allepochval
             %----save n single response epoch 
               epR = find(A==1); 
               epRcount = length(epR);
             responses (2,7) = {epRcount}; % save in next column if is not zero
              % ---- save n of epochs with multiple responses
                MR = find(A>1);  % Find cells in A with more than 1 element
                EpMR = length(MR);
              responses(2,8) = {EpMR};
               % --- fill in  average, SD and n
                  respstats (2,4)= { mean(R)};
                  respstats (3,4) = {std(R)};
                  respstats (4,4) = {length(R)};
             
           end;
         end;
     EEG = eeg_retrieve (ALLEEG, 1);
      % % %---------------------Event 23
 % %//////////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 23); 
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
      
       for r = 1:length(R);
           if ~find(R)==0; 
               %----save responses as rows under corresponding event column
             responses (1+r,9) = {R(r)}; % save in next column if is not zero
                A  = cellfun ('prodofsize', allepochval);% n of elements in cells of allepochval
               %----save n single response epoch 
               epR = find(A==1); 
               epRcount = length(epR);
             responses (2,10) = {epRcount}; % save in next column if is not zero
              % ---- save n of epochs with multiple responses
                MR = find(A>1);  % Find cells in A with more than 1 element
                EpMR = length(MR);
              responses(2,11) = {EpMR}; 
               % --- fill in  average, SD and n
                  respstats (2,5)= { mean(R)};
                  respstats (3,5) = {std(R)};
                  respstats (4,5) = {length(R)};
            
           end;
         end;
     EEG = eeg_retrieve (ALLEEG, 1);
    % % %---------------------Event 24
 % %//////////////////////////////////////////////////////////////////////
    EEG = pop_selectevent (EEG, 'type', 24); 
     [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG);
     [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); %#ok<*ASGLU>
      % Save output in 'responses'which has already headers and indexes
      R = cell2mat(allepochval);
      
       for r = 1:length(R);
           if ~find(R)==0; 
               %----save responses as rows under corresponding event column
             responses (1+r,12) = {R(r)}; % save in next column if is not zero
                A  = cellfun ('prodofsize', allepochval);% n of elements in cells of allepochval
               %----save n single response epoch 
               epR = find(A==1); 
               epRcount = length(epR);
             responses (2,13) = {epRcount}; % save in next column if is not zero
              % ---- save n of epochs with multiple responses
                MR = find(A>1);  % Find cells in A with more than 1 element
                EpMR = length(MR);
              responses(2,14) = {EpMR}; 
               % --- fill in  average, SD and n
                  respstats (2,6)= { mean(R)};
                  respstats (3,6) = {std(R)};
                  respstats (4,6) = {length(R)};
           end;
         end;
     EEG = eeg_retrieve (ALLEEG, 1);
   
    %%%==================================================================
    %%% Go to common folder ('Responses') and save there outpuf for each S
    cd (DIROUT); 
    FILEOUT = strrep(FILENAME, '-vwr-Epoched', '-responses.xls');
    FILEOUT2 = strrep(FILENAME, '-vwr-Epoched', '-resp-stats.xls');
    % save as excel file
    xlswrite(FILEOUT, responses)
    xlswrite(FILEOUT2, respstats)
    clear respstats
    clear responses
    %   % % %====================================================================
%   clear ALLEEG
%   clear EEG
%   clear latencies
%   eeglab redraw
   
else 
        fprintf('File %s not found\n',FILENAME1);

end
end
end
