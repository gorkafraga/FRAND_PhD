% Number of events, per type. And number of components rejected.

cd D:/raw_bdf_dyslexia

subjects = {'003' '004' '005' '006' '007' '008' '010' '011' '012' '013' '014' '015' '017' '201' '202' '203' '204' '206' '207' '208' '209' '210'};

eeglab

% initializing a text document:
fid=fopen('number_of_events_and_components.txt','w');

% collumn titles:
variable_labels={'Part';'21';'22';'23';'24'; 'Total'; 'Comp'};

% printing the column titles:
for vari=1:length(variable_labels)
    fprintf(fid,'%s\t',variable_labels{vari});
end

% jump to a new-line:
fprintf(fid,'\n');

for j=1:length(subjects)
    
    % printing the subject number:
    fprintf(fid,'%s\t',subjects{j});
    
    filename = strcat('s', subjects{j}, '-VWR_ICA-mrkd-rej.set');
    
     %loading data set:
    EEG = pop_loadset('filename',filename,'filepath','D:\\raw_bdf_dyslexia\\');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % initializing variables: 
        number_of_21 = 0;
        number_of_22 = 0;
        number_of_23 = 0;
        number_of_24 = 0;
        number_rejected_components = 64 - length(EEG.icaweights(:,1));
        total_number_of_events = length(EEG.event);
    
    % counting the number of events, per type:
    for k = 1:length(EEG.event)
        
        if EEG.event(k).type == 21
            number_of_21 = number_of_21 + 1;
        elseif EEG.event(k).type == 22
            number_of_22 = number_of_22 + 1;
        elseif EEG.event(k).type == 23
            number_of_23 = number_of_23 + 1;
        elseif EEG.event(k).type == 24
            number_of_24 = number_of_24 + 1;
        end
        
    end
    
    % writing data in text document:
    fprintf(fid,'%g\t',number_of_21);
    fprintf(fid,'%g\t',number_of_22);
    fprintf(fid,'%g\t',number_of_23);
    fprintf(fid,'%g\t',number_of_24);
    fprintf(fid,'%g\t',total_number_of_events);
    fprintf(fid,'%g\t',number_rejected_components);
    fprintf(fid,'\n'); % end-of-line 
    
    % clearing study:
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

end

% closing text file:
fclose(fid);