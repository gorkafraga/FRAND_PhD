clear all


% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 %Rereference to average of 64 channels after ICA and Lowpass of 30 Hz 
 %-------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)

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
    if  G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\Averages';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\Averages';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\Averages';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\Averages';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\Averages';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\Averages';
    end

cd (DIRNAME);

for N = N; 
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



FILENAME1 = [FILENAME, '.set'];


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

end
end

