
clear all


% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 %LOw pass filter the ICA pruned data & rereference to avg of 64 channels
 %-------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%---------------------------------------------------------
% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)','Channels to exclude from Avg (interpolated)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??', '???'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
   ExChan=cell2mat(answer(3)); ExChan = str2num(ExChan);
%--------------------------------------------------------------------------

for G = G; 
    if          G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\ICApruned';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\ICApruned';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\ICApruned';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\ICApruned';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\ICApruned';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\ICApruned';
    end

cd (DIRNAME);

for N = [N]; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-interp'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-interp'];
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


 % ==========================FILTER
%Low pass filter to 30 Hz the data pruned with ICA
 EEG = pop_eegfilt( EEG, 0, 30);
 %Save file after 
 FILENAME2= strrep (FILENAME,'ICA-pruned-br-interp','ICA-pruned-br-interp-lp');
 EEG = pop_saveset (EEG, FILENAME2,DIRNAME);
 eeglab redraw;
% ==========================REFERENCE AVG
% RE-REFERENCE to AVERAGE of the 64 electrodes
  FILENAME3 = [FILENAME2 '-refAvg-ExcNoWeights'];
 EEG = pop_reref( EEG, [],'exclude',[ExChan, 65:70]);
 EEG = pop_saveset (EEG, FILENAME3,DIRNAME);

else 
     fprintf('File %s not found\n',FILENAME1);
end
end
end

