clear all
close all

% SCRIPT FOR PROCESSING VWR FILES
% =========================87654321=======================================================
 %%%%% Saves each step in a different dataset and file
 % Search for raw bdf files organized by group(G) and subject (N) number.
  %(except subjects 009,019,107,117 which have diff order of trials)
 % Loads chan location from txt file and removes 2 extra ext channels.
 % Band-pass Filter ---------> Interpolate channels must be done after this
 % Resample to 256 Hz
 % Rename events, epoch and baseline removal
 
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_age)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
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
   G=cell2mat(answer(1));G = str2num(G); 
   N=cell2mat(answer(2));N = str2num(N);
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
        DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';
        elseif G == 1
        DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school';
        elseif G == 2
        DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age';
        elseif G == 3
        DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia';  
        elseif G == 4
        DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI';
        elseif G == 5
        [DIROUTPUT] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school';
    end
    
DIRNAME = 'Z:\fraga\Raw\Raw_VWR';
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
    
EEG = pop_biosig( FILENAME1, 'channels',[1:72], 'ref',[69,70]);

EEG.setname=FILENAME;
EEG = pop_saveset (EEG, FILENAME, DIROUTPUT);
eeglab redraw;
 
%Remove last 2 external (ext 7&8) electrodes 
EEG = pop_select (EEG, 'channel', 1:70); 
%Load the channel locations file, specify BESA coordinates 
EEG = pop_chanedit(EEG,'load','Z:\fraga\EEG_Gorka\Analysis_EEGlab11\ChannelsLocationFiles\channelsThetaPhi-2extRemoved.elp','besa'); 

%Save dataset with channel locations loaded.
FILENAME2 = [FILENAME '-ch_rej']; 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME2, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME2,DIROUTPUT);
eeglab redraw;

%--------------------------------------------------
%Basic FIR filter ---> Bandpass filter, first lowpass then highpass filter
%Lowpass filter - keeps data under 70 Hz
  EEG = pop_eegfilt( EEG, 0, 70);
% %Highpass filter - keeps data above 1 Hz (takes long time)
 EEG = pop_eegfilt( EEG, 1, 0);
 
%Save dataset with band pass filter.
FILENAME3 = [FILENAME2 '-bp'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME3, 'overwrite', 'on');
EEG = pop_saveset (EEG,FILENAME3,DIROUTPUT);
eeglab redraw;
%-------------------------------------------------------------------
%Downsample to 256 Hz 
EEG = pop_resample(EEG, 256);
%Save downsampled.
FILENAME4 = [FILENAME3 '-256Hz'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME4, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME4,DIROUTPUT);
eeglab redraw;
%--------------------------------------------------
%Recall the events with Script >>> 
 %(exception subjects 009,019,107,117 they have order as even subjects)

isodd = mod (N,2);
if  ( G== 0 && (N == 9 || N==  19)) || (G==1 && ( N == 7 || N == 17));
   run Z:\fraga\Scripts_Matlab_exHDD\rename_events_in_vwr_for_even_subjects.m
elseif isodd == 0; 
   run Z:\fraga\Scripts_Matlab_exHDD\rename_events_in_vwr_for_even_subjects.m
elseif  isodd~=0;
   run Z:\fraga\Scripts_Matlab_exHDD\rename_events_in_vwr_for_odd_subjects.m

end
%%%EPOCHING in VWR experiment, epochs of 2.5 sec(remove comment to run)
   EEG = pop_epoch( EEG, { '21','22','23','24' }, [-0.5 1.550]);
%%%REMOVE BASELINE activity first baseline removal. Do a 2nd after ICA
   EEG = pop_rmbase( EEG, [-500 0]);
%%%Save epoched files
FILENAME5 = [FILENAME '-Epoched'];
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', FILENAME5, 'overwrite', 'on');
EEG = pop_saveset (EEG, FILENAME5,DIROUTPUT);
eeglab redraw;

else 
     fprintf('File %s not found\n',FILENAME1);
end
end
end

