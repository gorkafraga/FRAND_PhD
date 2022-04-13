clear all
close all

% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
% Input are files: 009 019 107 & 117 after bp filter
% Resample to 256Hz
% Rename events, epoch (-500 1550) and remove baseline [-500 0]
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%--------------------------------------------------------------------------
% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'0? 1?','009? 019? 107? 117?'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2double(N);
%------------------------------------------------------------------------
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

cd (DIRNAME);
eeglab;
for N = N; 
  if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ch_rej-bp'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ch_rej-bp'];
  end
    
%Enter the filename of the .bdf file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];

if ~isempty(dir(FILENAME1))
    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%%% Checks if the file exist in the current folder and if it is there
%%% it gives a line saying that it is not found and goes to the next
%%% file

    
EEG.setname=FILENAME;
%Downsample to 256 Hz 
EEG = pop_resample(EEG, 256);
%Save downsampled.
FILENAME2 = [FILENAME '-256Hz'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME2, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME2,DIRNAME);
eeglab redraw;
%--------------------------------------------------
%Recall the events with Script >>> 

% isodd = mod (N,2);
% if isodd == 0; 
   run Z:\fraga\Scripts_Matlab\rename_events_in_vwr_for_even_subjects.m
 
% else
%    run Z:\fraga\Scripts_Matlab\rename_events_in_vwr_for_odd_subjects.m
% 
% end
%--------------------------------------------------
%%%EPOCHING in VWR experiment, epochs of 2.5 sec(remove comment to run)
   EEG = pop_epoch( EEG, { '21','22','23','24' }, [-0.5 1.550]);
%%%REMOVE BASELINE activity, same in all experiments 
   EEG = pop_rmbase( EEG, [-500 0]);
%%%Save epoched files
FILENAME3 = strrep (FILENAME,'ch_rej-bp','Epoched');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME3, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME3,DIRNAME);


else 
     fprintf('File %s not found\n',FILENAME1);
end
end
end

