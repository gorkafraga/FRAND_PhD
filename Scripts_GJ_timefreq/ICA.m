% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Pre-processing of multiple subjects: ICA. 

cd D:/raw_bdf_dyslexia

eeglab

subjects = {'211' '212' '213' '214' '218'};

for j=1:length(subjects)
    
    filename = strcat('s',subjects{j},'-VWR_epoched_-125_1125_mrkd-rej.set');
    
    % loading data set:
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',filename,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
  
    % run ICA:
    filename_bu = strcat('s',subjects{j},'-VWR_ICA.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'icatype','runica','dataset',1,'options',{'extended' 1},'chanind',[1:64] );
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',filename_bu,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    % unloading dataset:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
end