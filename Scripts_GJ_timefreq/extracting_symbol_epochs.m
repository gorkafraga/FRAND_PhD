% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Extracting epochs that only contain symbol presentation. (events 23 and 24) 

cd D:/raw_bdf_dyslexia

eeglab

subjects = {'003' '005' '007' '008' '010' '011' '012' '015' '017' '201' '202' '203' '204' '207' '209' '211' '212' '214' '218'};

for subjectsi = 1 : length(subjects)
    
    filename = strcat('s',subjects{subjectsi},'-VWR_ICA-mrkd-rej.set');
    
    % loading data set:
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',filename,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
  
    % extracting symbol epochs:
    new_filename = strcat('s',subjects{subjectsi},'-VWR_ICA-mrkd-rej_SYMBOLS');
    EEG = pop_selectevent( EEG, 'type',[23 24] ,'deleteevents','off','deleteepochs','on','invertepochs','off');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','pruned with ICA WORDS','savenew',new_filename,'gui','off'); 
    
    % unloading dataset:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
end