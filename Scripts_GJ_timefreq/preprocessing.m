% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Pre-processing of multiple subjects. 

cd D:/raw_bdf_dyslexia

subjects = {'211' '212' '213' '214' '218'};

for j=1:length(subjects)
    
    subjects = {'211' '212' '213' '214' '218'};
    
    eeglab
    
    filename = strcat('D:\raw_bdf_dyslexia\s', subjects{j}, '-vwr.bdf');
    
    % reading in data with the mastoids as reference:
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_biosig(filename, 'ref',[69 70] ,'blockepoch','off');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname', subjects{j},'gui','off'); 
    
    % rejecting channels EXT7 and EXT8 and reading in channel locations:
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',subjects{j},'gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    EEG = pop_select( EEG,'channel',{'Fp1' 'AF7' 'AF3' 'F1' 'F3' 'F5' 'F7' 'FT7' 'FC5' 'FC3' 'FC1' 'C1' 'C3' 'C5' 'T7' 'TP7' 'CP5' 'CP3' 'CP1' 'P1' 'P3' 'P5' 'P7' 'P9' 'PO7' 'PO3' 'O1' 'Iz' 'Oz' 'POz' 'Pz' 'CPz' 'Fpz' 'Fp2' 'AF8' 'AF4' 'AFz' 'Fz' 'F2' 'F4' 'F6' 'F8' 'FT8' 'FC6' 'FC4' 'FC2' 'FCz' 'Cz' 'C2' 'C4' 'C6' 'T8' 'TP8' 'CP6' 'CP4' 'CP2' 'P2' 'P4' 'P6' 'P8' 'P10' 'PO8' 'PO4' 'O2' 'EXG1' 'EXG2' 'EXG3' 'EXG4' 'EXG5' 'EXG6'});
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    EEG=pop_chanedit(EEG, 'load',{'C:\\Users\\acer\\Desktop\\Dyslexia internship\\data_analysis\\channelsThetaPhi-2extRemoved.elp' 'filetype' 'besa'});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % saving a back-up:
    filename_bu1 = strcat('s', subjects{j}, '-VWR_ref-rej-Ch.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',filename_bu1,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % low-pass filtering (100Hz):
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfilt( EEG, 0, 100, [], [0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    
    % saving a back-up:
    filename_bu2 = strcat('s', subjects{j}, '-VWR_ref-rej-Ch_Lp100.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',filename_bu2,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % high-pass filtering (1Hz):
    filename_bu3 = strcat('D:\\raw_bdf_dyslexia\\s', subjects{j} , '-VWR_ref-rej-Ch_Lp100-Hp1.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfilt( EEG, 1, 0, [], [0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew', filename_bu3,'gui','off'); 

    % downsampling:
    filename_bu4 = strcat('D:\\raw_bdf_dyslexia\\s', subjects{j} , '-VWR_ref-rej-Ch_Lp100-Hp1_Ds512.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 512);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew', filename_bu4,'gui','off'); 
    
    % unloading datasets:
    close all
    clear all

end