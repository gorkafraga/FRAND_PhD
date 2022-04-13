
clear all


% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 % Re-epoch files after re-ref to average using Maurer epoch length
 % Uncomment Last part and comment first to take interated files
 %-------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%---------------------------------------------------------
% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
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
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\';
    end

DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\GrandAverages_MaurerEpoch'; 
cd (DIRNAME);
cd ([DIRNAME 'Averages']);

for N = [N]; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
    end
 
%Enter the filename of the file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
%%% EPOCH WITH MAURER EPOCH LENGTH (-125 1125);
EEG = pop_epoch( EEG, { '21','22','23','24' }, [-0.125 1.125]);
%%%REMOVE BASELINE activity first baseline removal. Do a 2nd after ICA
   EEG = pop_rmbase( EEG, [-125 0]);
%%%Save epoched files
FILENAME2 = [FILENAME '-EpMaurer'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME2, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME2,DIROUTPUT);

% ==========================REFERENCE AVG
% % RE-REFERENCE to AVERAGE of the 64 electrodes
%   FILENAME3 = [FILENAME2 '-refAvg64'];
%  EEG = pop_reref( EEG, [],'exclude',[65:70] );
%  EEG = pop_saveset (EEG, FILENAME3,DIROUTPUT);
% eeglab redraw;


else 
     fprintf('File %s not found\n',FILENAME1);
end;
end;
% 
% %%%%% Do the same with the files with interpolation
% 
% cd ([DIRNAME 'Interpolation']);
% for N = [N]; 
%     if N < 10
%     [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-interp-lp-refAvg'];
%     elseif N >=10 && N<100   
%     [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-interp-lp-refAvg'];
%     end
%  
% %Enter the filename of the file with the extension included, e.g
% FILENAME1 = [FILENAME, '.set'];
% 
% %%% Check if the file exist in the current folder and if it is there
% %%% process it else gives a line that it is not found and goes to the next
% %%% file
% if ~isempty(dir(FILENAME1))
%     
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename',FILENAME1);
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% %%% EPOCH WITH MAURER EPOCH LENGTH (-125 1125);
% EEG = pop_epoch( EEG, { '21','22','23','24' }, [-0.125 1.125]);
% %%%REMOVE BASELINE activity first baseline removal. Do a 2nd after ICA
%    EEG = pop_rmbase( EEG, [-125 0]);
% %%%Save epoched files
% FILENAME2 = [FILENAME '-EpMaurer'];
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME2, 'overwrite', 'on');
% EEG = pop_saveset (EEG, FILENAME2,DIROUTPUT);
% 
% % ==========================REFERENCE AVG
% % RE-REFERENCE to AVERAGE of the 64 electrodes
%   FILENAME3 = [FILENAME2 '-refAvg64'];
%  EEG = pop_reref( EEG, [],'exclude',[65:70] );
%  EEG = pop_saveset (EEG, FILENAME3,DIROUTPUT);
%  
% else 
%      fprintf('File %s not found\n',FILENAME1);
% end
% end


end