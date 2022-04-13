% Script for dyslexia internship. Gert-Jan Munneke (2012) 
% Pre-processing of multiple subjects, up to and including epoching. 

cd D:/raw_bdf_dyslexia

eeglab

%subjects = {'003' '004' '005' '006' '007' '008' '010' '011' '012' '013' '014' '015' '016' '017' '201' '202' '203' '204' '206' '207' '208' '209' '210'};
subjects = {'211' '212' '213' '214' '218'};

for j=1:length(subjects)
    
    filename = strcat('s',subjects{j},'-VWR_ref-rej-Ch_Lp100-Hp1_Ds512.set');
    
    % loading data set:
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',filename,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % recoding events:
    %if rem(str2double(subjects{j}),2) == 0 ; 
    %    run renaming_events_EVEN;
    %else
    %    run renaming_events_ODD;
    %end
    
    % epoching and saving a back-up:
    filename_bu = strcat('D:\\raw_bdf_dyslexia\\s', subjects{j} , '-VWR_epoched_-125_1125.set');
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  '21'  '22'  '23'  '24'  }, [-0.125  1.125], 'newname', subjects{j}, 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'savenew', filename_bu,'gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, [-0.125  0]);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % unloading dataset:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
end