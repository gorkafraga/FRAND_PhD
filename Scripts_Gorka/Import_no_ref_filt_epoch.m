clear all
close all

% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 % Imports all bdf files without reference electrode (loses 40 SNR)
 % Band pass filter and epoch
 % Use only to look for flat electrodes! 
 % also NOTE: renaming of events won't be correct  for subjects with "special order of blocks"
 %--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%%% make use of special directory for this check, do not use normal
%%% directories!
%---------------------------------------------------------
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
    if          G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Pretest';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Pretest';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Control';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Control';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Posttest';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Check_Flat_Electrodes\Posttest';
    end

cd (DIRNAME);
eeglab;
for N = N; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr'];
    end
    
%Enter the filename of the .bdf file with the extension included, e.g
FILENAME1 = [FILENAME, '.bdf'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
% Import using default 'none' as reference
EEG = pop_biosig( FILENAME1, 'channels',[1:72]);
% name data set
FILENAME2 = [FILENAME '-NoRef'];
EEG.setname=FILENAME;
% EEG = pop_saveset (EEG, FILENAME2, DIRNAME);
eeglab redraw;
 
%Remove last 2 external (ext 7&8) electrodes 
EEG = pop_select (EEG, 'channel', 1:70); 
%Load the channel locations file, specify BESA coordinates 
EEG = pop_chanedit(EEG,'load','Z:\fraga\EEG_Gorka\Analysis_EEGlab\ChannelsLocationFiles\channelsThetaPhi-2extRemoved.elp','besa'); 

%Save dataset with channel locations loaded.
FILENAME3 = [FILENAME2 '-ch_rej']; 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME3, 'overwrite', 'on');
% EEG = pop_saveset (EEG, FILENAME3,DIRNAME);
eeglab redraw;

%--------------------------------------------------
%Basic FIR filter ---> Bandpass filter, first lowpass then highpass filter
%Lowpass filter - keeps data under 70 Hz
  EEG = pop_eegfilt( EEG, 0, 70);
% %Highpass filter - keeps data above 1 Hz (takes long time)
 EEG = pop_eegfilt( EEG, 1, 0);
 
%Save dataset with band pass filter.
FILENAME4 = [FILENAME3 '-bp'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME4, 'overwrite', 'on');
EEG = pop_saveset (EEG,FILENAME4,DIRNAME);
eeglab redraw;
%-------------------------------------------------------------------
%Downsample to 256 Hz 
EEG = pop_resample(EEG, 256);
%Save downsampled.
FILENAME5 = [FILENAME4 '-256Hz'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME5, 'overwrite', 'on');
% EEG = pop_saveset (EEG, FILENAME5,DIRNAME);
eeglab redraw;
%--------------------------------------------------
%Recall the events with Script >>> 

isodd = mod (N,2);
if isodd == 0; 
   run Z:\fraga\Scripts_Matlab\rename_events_in_vwr_for_even_subjects.m
 
else
   run Z:\fraga\Scripts_Matlab\rename_events_in_vwr_for_odd_subjects.m

end
%%%EPOCHING in VWR experiment, epochs of 2.5 sec(remove comment to run)
   EEG = pop_epoch( EEG, { '21','22','23','24' }, [-0.5 1.550]);
%%%REMOVE BASELINE activity first baseline removal. Do a 2nd after ICA
   EEG = pop_rmbase( EEG, [-500 0]);
%%%Save epoched files
FILENAME6 = [FILENAME2 '-Epoched'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME6, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME6,DIRNAME);
eeglab redraw;

else 
     fprintf('File %s not found\n',FILENAME1);
end
end
end

