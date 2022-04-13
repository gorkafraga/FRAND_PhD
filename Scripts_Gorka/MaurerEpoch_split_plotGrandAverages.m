clear all
close all
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
%PLOT GRAND AVERAGES: 
    %Input= group and subjects to include.
    % If subject is not found in folder it continues with the next 
    % Output = plots with words versus symbols differences: 
           % Formats: fig and Tiff
           % One version with significance and one without
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
        FIGURENAME = 'Pretest_dyslexia';
        elseif G == 1
        FIGURENAME = 'Pretest_school';
        elseif G == 2
        FIGURENAME = 'Ctrl_school';
        elseif G == 3
         FIGURENAME = 'Ctrl_dyslexia';
        elseif G == 4
        FIGURENAME = 'Post_dyslexia';
        elseif G == 5
        FIGURENAME = 'Post_school';
    end

%%%% split files in event .First in non interpolated data, then repeat loop 
%%% in interpolated data
[DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\GrandAverages_MaurerEpoch';    

% 
 cd (DIRNAME);
for n = N; 
    if n < 10
    [FILENAME] =['s',num2str(G),'0',num2str(n),'-vwr-ICA-pruned-br-lp-refAvg-EpMaurer'];
    elseif n >=10 && n<100   
    [FILENAME] =['s',num2str(G),num2str(n),'-vwr-ICA-pruned-br-lp-refAvg-EpMaurer'];
    end
    
    FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    

% % %---------------------Event 21
[ALLEEG, EEG, CURRENTSET] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0);
FILENAME = EEG.filename;
FILENAME1 = strrep (FILENAME,'.set','-e21.set') ;
EEG = pop_selectevent (EEG, 'type', 21); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

  clear FILENAME 
  clear FILENAME1
% % %---------------------Event 22

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e22.set') ;
EEG = pop_selectevent (EEG, 'type', 22); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 23

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e23.set') ;
EEG = pop_selectevent (EEG, 'type', 23); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 24

 EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e24.set') ;
EEG = pop_selectevent (EEG, 'type', 24); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

 clear FILENAME 
 clear FILENAME1
 %------------------------------------------------
 else 
     fprintf('File %s not found\n',FILENAME1);
end

end;
%=======now split INTERPOLATED FILES
% 
% for n = N; 
%     if n< 10
%     [FILENAME] =['s',num2str(G),'0',num2str(n),'-vwr-ICA-pruned-br-interp-lp-refAvg-EpMaurer'];
%     elseif n >=10 && n<100   
%     [FILENAME] =['s',num2str(G),num2str(n),'-vwr-ICA-pruned-br-interp-lp-refAvg-EpMaurer'];
%     end
%     
%     FILENAME1 = [FILENAME, '.set'];
% 
% %%% Check if the file exist in the current folder and if it is there
% %%% process it else gives a line that it is not found and goes to the next
% %%% file
% if ~isempty(dir(FILENAME1))
%     
% 
% % % %---------------------Event 21
% [ALLEEG, EEG, CURRENTSET] = eeglab;
% EEG = pop_loadset('filename',FILENAME1);
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0);
% FILENAME = EEG.filename;
% FILENAME1 = strrep (FILENAME,'.set','-e21.set') ;
% EEG = pop_selectevent (EEG, 'type', 21); 
% EEG = pop_editset (EEG, 'setname', FILENAME1);
% EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
% 
%   clear FILENAME 
%   clear FILENAME1
% % % %---------------------Event 22
% 
% EEG = eeg_retrieve (ALLEEG, 1);
% FILENAME = EEG.filename; 
% FILENAME1 = strrep (FILENAME,'.set','-e22.set') ;
% EEG = pop_selectevent (EEG, 'type', 22); 
% EEG = pop_editset (EEG, 'setname', FILENAME1);
% EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
%  clear FILENAME 
%  clear FILENAME1
% % % %---------------------Event 23
% 
% EEG = eeg_retrieve (ALLEEG, 1);
% FILENAME = EEG.filename; 
% FILENAME1 = strrep (FILENAME,'.set','-e23.set') ;
% EEG = pop_selectevent (EEG, 'type', 23); 
% EEG = pop_editset (EEG, 'setname', FILENAME1);
% EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
%  clear FILENAME 
%  clear FILENAME1
% % % %---------------------Event 24
% 
%  EEG = eeg_retrieve (ALLEEG, 1);
% FILENAME = EEG.filename; 
% FILENAME1 = strrep (FILENAME,'.set','-e24.set') ;
% EEG = pop_selectevent (EEG, 'type', 24); 
% EEG = pop_editset (EEG, 'setname', FILENAME1);
% EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
% 
%  clear FILENAME 
%  clear FILENAME1
%  %------------------------------------------------
%  else 
%      fprintf('File %s not found\n',FILENAME1);
% end
% end
% 

end

 