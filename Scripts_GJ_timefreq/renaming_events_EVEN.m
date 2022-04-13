% Script for dyslexia internship. Gert-Jan Munneke (2012)
% Renaming the events of the VWR-task for EVEN subjects.

% 61461 are all stimulus events. 
% These are renamed into:
%   21  for     "ShortWords"    [TF]
%   22  for     "LongWords"     [FF]
%   23  for     "ShortSymbols"  [TT]
%   24  for     "LongSymbols"   [FT]

% For even subjects we have the following sequence:
% FF TF FT TT FT TF TT FF

cd D:/raw_bdf_dyslexia

eeglab

subjects = {'212' '214' '218'};

for subjectsi = 1 : length(subjects)
    
    filename = strcat('s',subjects{subjectsi},'-VWR_ref-rej-Ch_Lp100-Hp1_Ds512.set');
    
    % loading data set:
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',filename,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    counter = 0;

    for i=1:length(EEG.urevent)

        if EEG.urevent(i).type ~= 61461;
            EEG.event(i).type = 12;             % non-stimulus events are coded 12
            continue                            % skips the rest of the code in the body of the loop and jumps to the next iteration
        else
            counter = counter+1;                % a stimulus event raises the counter by 1
        end

        if counter <=40;                        % the first 40 stimulus events are coded 22         for "ShortWords" [TF]
            EEG.event(i).type = 22;
        end

        if counter > 40 && counter <=80;        % the folowwing 40 stimulus events are coded 21     for "LongSymbols" [FT]
            EEG.event(i).type = 21;
        end

        if counter > 80 && counter <=120;       % the following 40 stimulus events are coded 24     for "LongWords" [FF]
            EEG.event(i).type = 24;
        end

        if counter > 120 && counter <=160;      % the following 40 stimulus events are coded 23 for "ShortSymbols" [TT]
            EEG.event(i).type = 23;
        end

        if counter > 160 && counter <=200;      % the following 40 stimulus events are coded 24     for "LongWords" [FF]
            EEG.event(i).type = 24;
        end

        if counter > 200 && counter <=240;      % the following 40 stimulus events are coded 21     for "ShortSymbols" [TT]
            EEG.event(i).type = 21;
        end

        if counter > 240 && counter <=280;      % the following 40 stimulus events are coded 23     for "ShortWords" [TF]
            EEG.event(i).type = 23;
        end

        if counter > 280 && counter <=320;      % the folowwing 40 stimulus events are coded 22     for "LongSymbols" [FT]
            EEG.event(i).type = 22;
        end

    end

    for i=1:length(EEG.urevent)

        EEG.urevent(i).type = EEG.event(i).type;    % copies the new codes to EEG.urevent.type 

    end

    % saving the dataset:
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','preprocessed and renamed','savenew',filename,'gui','off'); 
    
    
    % unloading dataset:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
end
