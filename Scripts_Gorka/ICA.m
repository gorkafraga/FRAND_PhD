
clear all


% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 %%%%% (Saves each step in a different dataset and file)
 %Search for files organized by group(G) and subject (N) number.
 % Loads the files after epoch cleaning and: 
 % Run Independent Component Analysis (ICA) (runica algorithm) 
 % Remove baseline activity (second baseline removal)
 % ReReference to average of 64 electrodes??? (now is commented)
 %-------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
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
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
      DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school';
    end

cd (DIRNAME);

for N = N; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-Epoched_EpClean'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-Epoched_EpClean'];
    end
    
%Enter the filename of the file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%INDEPENDENT COMPONENT ANALYSIS - runica algorithm
 EEG = pop_runica( EEG, 'runica', 'chanind', [1:64], 'extended', 1);
 %save after ICA
 FILENAME2 = strrep (FILENAME,'Epoched_EpClean','ICA');
 EEG = pop_saveset (EEG, FILENAME2,DIRNAME);
 eeglab redraw;
else 
     fprintf('File %s not found\n',FILENAME1);
end


end
end

