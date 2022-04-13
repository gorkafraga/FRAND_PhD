clear all
close all

% REJECT RESPONSE EPOCHS (CONTAINING EVENT 12) IN FILES WITH INTERPOLATED
% CHANNELS
% ================================================================================
%%%%Automatically rej trials including the event 12 (response trials)in files
    %with interpolated channels
%%%%%Manually define group code (G) and subj number (N) only those with
     %INTERPOLATED electrodes. 
% Input files are "interp-epoched"files. 
% Output files ending is "rejResp". 
%  There is a counter  desactivated at the end (use "counter_all"script)
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
   N=cell2mat(answer(2));N = str2double(N);
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\RejEpochs&ICA';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\RejEpochs&ICA';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\RejEpochs&ICA';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\RejEpochs&ICA';  
        elseif G == 4
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\RejEpochs&ICA';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\RejEpochs&ICA';
    end

cd (DIRNAME);
eeglab;

for N = N; 
  if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-interp-Epoched'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-interp-Epoched'];
  end
    
  


%Enter the filename of the .bdf file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];


%%% Checks if the file exist in the current folder and if it is there
%%% it gives a line saying that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    
FILENAME1 = [FILENAME, '.set'];

    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 ); 
    
EEG.setname=FILENAME;

%Select all epochs not containing event 12(response) and delete the rest
EEG = pop_selectevent( EEG, 'type',12,'deleteevents','off','deleteepochs','on','invertepochs','on');%Save downsampled.
FILENAME2 = [FILENAME '_rejResp'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME2, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME2,DIRNAME);
 %Counter has been commented - the events are counted with another script
%     codes=zeros(5,1);
%     counts=codes;
%     counter=1;
% 
% %     if ~isempty(dir(FILENAME1))
% 
%         for e = 1:length(EEG.event)
%             check=sum(EEG.event(e).type==codes);
%             if check==0
%                 codes(counter)=EEG.event(e).type;
%                 counter=counter+1;
%             end
% 
%         end
% 
%         for e = 1:length(EEG.event)
%             for i=1:5
%                 if codes(i)==EEG.event(e).type
%                     counts(i)=counts(i)+1;
%                 end
%             end
%         end
% 
%          X=[codes' ; counts' ];
% 
%          DIRNAME2 = [DIRNAME, '\Trials_rej_resp'];
%          FILENAME3 = strrep (FILENAME2, 'Epoched_rejResp', 'noResp.txt');
%         dlmwrite(fullfile(DIRNAME2,FILENAME3), X);
% %change dlm write. Wrong file /directory name

else 
     fprintf('File %s not found\n',FILENAME1);
    end
end
end

