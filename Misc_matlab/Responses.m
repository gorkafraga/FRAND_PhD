%% RESPONSE STATISTICS: individual/group/plot
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
%%  Define directory 
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Responses';
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

 for N = n; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    GROUP = 'PreLexi';
    groupnames(1) = {GROUP};
        if N < 10 
           FILES =['s','00',num2str(N),'-vwr-Epoched.set'];
        elseif N >=10 && N<100   
           FILES =['s','0',num2str(N),'-vwr-Epoched.set'];
        end
  elseif N >=100
        FILES =['s',num2str(N),'-vwr-Epoched.set'];  
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
%       [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%% Define output arrays:
% (1) respstats: avg/SD per event
% (2) responses: describes no. epoch with resps (epR) and no. of epochs with multiple
  % Define array 1 with number of responses
 header = {'TotalEpR','TotalEpMR','21','epR','epMR', '22','epR','epMR','23','epR','epMR', '24','epR','epMR'};
 responses = cell(1,length(header));%LIST with many rows as responses + headers
 responses (1,1:end) = header;
 % Define array 1 with statistics of the responses
  header2 = {'','TotalR','21','22','23','24'};
  rownames = {'avg', 'SD', 'n'};  
  respstats = cell(4, 6); 
  respstats(1,:) = header2;
  respstats(2:end,1)= rownames;
 %% Get values for Overall and Each Event separately
% OVERALL //////////////////////////////////////////////////////////////
      EEG = pop_loadset('filename',FILENAME1);
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
       eeglab redraw
        % responses(epMR)
         [epochval,allepochval] =  eeg_getepochevent(EEG, '12'); 
         R = cell2mat(allepochval);% all responses
         % TOTAL epochs with single resp and total with multiple resps
            A  = cellfun ('prodofsize', allepochval); 
               epR = find(A==1); 
               epR = length(epR);
            responses (2,1) = {epR};
               epMR = find(A>1);  % Find cells in A with more than 1 element
               epMR = length(epMR);
             responses(2,2) = {epMR}; 
          % TOTAL statistics
          respstats (2,2)= { mean(R)};
          respstats (3,2) = {std(R)};
         respstats (4,2) = {length(R)};
 % Event 21 //////////////////////////////////////////////////////////////////
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
          end;
     end;
     EEG = eeg_retrieve (ALLEEG, 1);
     
 % Event 22 /////////////////////////////////////////////////////////////
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
 % Event 23 /////////////////////////////////////////////////////////////
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
 % Event 24 /////////////////////////////////////////////////////////////
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
ALLEEG = pop_delset(ALLEEG,1:length(ALLEEG));
eeglab redraw; 
%% Save ================================================================
    %%% Go to common folder ('Responses') and save there outpuf for each S
    cd (DIROUTPUT); 
    FILEOUT = [FILENAME1(1:4),'_responses'];
    FILEOUT2 = [FILENAME1(1:4),'_respstats'];
    % save as excel file
    save (FILEOUT, 'responses');
    save (FILEOUT2, 'respstats');
%     xlswrite(FILEOUT, responses)
%     xlswrite(FILEOUT2, respstats)
    cd (DIRINPUT)
     clear responses respstats
 
    else 
           fprintf('File %s not found\n',FILENAME1);
  end
end
end
%% SCATTER PLOT (read matfiles created above)
%---------------------------------------------------------------------
cd (DIROUTPUT);
for N = n;
    if N < 100
       if N < 10 
           FILES =['s','00',num2str(N),'_responses.mat'];
        elseif N >=10 && N<100   
           FILES =['s','0',num2str(N),'_responses.mat'];
       end
    elseif N >=100; FILES =['s',num2str(N),'_responses.mat'];  
    end 
    listFiles = dir(FILES);
for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename
  if ~isempty(dir(FILENAME1))     

 PLOTNAME = [FILENAME1(1:4),'resp-plot'];
 load (FILENAME1);
 emptycells = cellfun(@isempty,responses);
 responses(emptycells)={0}; 
 respvalues = cell2mat(responses(2:end,:));
%read cols of the different events
X21 = respvalues(:,3);
 if isempty(find(X21,1)) == 1; 
     X21=0; Y21= 0;
 else X21(X21==0)= [];Y21 = 1:length(X21);
 end
X22 = respvalues(:,6);
  if isempty(find(X22,1)) == 1; 
     X22=0; Y22= 0;
 else X22(X22==0)= [];Y22 = 1:length(X22);
 end
X23 = respvalues(:,9);
  if isempty(find(X23,1)) == 1; 
     X23=0; Y23= 0;
 else X23(X23==0)= [];Y23 = 1:length(X23);
 end
X24 = respvalues(:,12);
  if isempty(find(X24,1)) == 1; 
     X24=0; Y24= 0;
 else X24(X24==0)= [];Y24 = 1:length(X24);
 end

%set the ticks for the axes in the plot
    XTick = [-500:100:1500] ;
    rmv = [1:21]; 
    rmv([2,4,6,8,10,12,14,16,18,20]) = []; 
    XTickLabel = num2cell(XTick);
    XTickLabel(rmv) = {''};

% generate scatter plots, and define axis properties and legends

scatter (X21, Y21,'filled','marker', 'o','markeredgecolor','k','markerfacecolor','w');hold on;
scatter (X22, Y22,'filled','marker', 'o','markeredgecolor','k','markerfacecolor','k');hold on; 
scatter (X23, Y23,'filled','marker', '^','markeredgecolor','k','markerfacecolor','w');hold on;
scatter (X24, Y24,'filled','marker', '^','markeredgecolor','k','markerfacecolor','k');hold on;

set(gca,'YLim', [0 50],'XLim',[-600, 1600],'XTick',XTick, 'XTickLabel',XTickLabel); 
set(gca,'Title',text('String',[FILENAME1(1:4),' responses'],'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
set(get(gca,'XLabel'),'String','time');
set(get(gca,'YLabel'),'String','response index');
legend ('shortwords', 'longwords', 'shortsymbols','longsymbols')

line([0 ; 0],[0 ;50 ], 'linewidth',1,'LineStyle', ':','color', 'k ');hold on; 

%%% save plot in current directory
        %  saveas (gcf,PLOTNAME, 'fig');
        saveas (gcf,PLOTNAME, 'tiff')
 % clear before going to next subject
    close gcf
     clear responses respstats respvalues X21 X22 X23 X24 Y21 Y22 Y23 Y24
    else 
           fprintf('File %s not found\n',FILENAME1);
  end
 close all
end 
end

