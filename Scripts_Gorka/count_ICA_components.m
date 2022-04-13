               clear all
close all

% COUNT THE No ICA Components after rejecting Components by map
% Works for all files "ICA-br-pruned" (included those with interp chan) 
% Output: TXT  file for each subject and EXCEL file with all subjects as
% rows
% 

% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5)'};
   name='Input group';
   numlines=1;
   defaultanswer = {'?'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   
%--------------------------------------------------------------------------

for G = G; %Select group folder in which it will make the count
    if  G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\ICApruned';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\ICApruned';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\ICApruned';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\ICApruned';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\ICApruned';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\ICApruned';
    end;

cd (DIRNAME);
eeglab;

 %Search in current Dir files 'epclean'
    
FILES = [dir('*ICA-pruned-br.set')];
for  J = 1:length(FILES); %J contains the list of the files containing 'ICA-pruned-br'.
      
  FILENAME1 = [FILES(J).name]; %Use the dimension name of each element of the list J as filename
  % Load the dataset in EEGLAB
  EEG = pop_loadset(FILENAME1, DIRNAME);
   % Counter of components:    
    
    [C,N] = size (EEG.icaweights); 
    
     DIRNAME2 = [DIRNAME, '\ICA_count'];
     FILENAME2 = strrep (FILENAME1, 'pruned-br.set', 'comp_count.txt');        
     dlmwrite(fullfile(DIRNAME2,FILENAME2), C); 
     
     %==========================================================================
%SAVE CSV FILE WITH ALL SUBJECTS AS ROWS and ICA number in second column

cd  (DIRNAME2);% go to folder "ICA_count"
  
         % Empty  array to fill in subjects and components  
           ICAlist = zeros (25,2);
                       
            % Load each textfile and take the relevant values 
           % Loop
           ICAcounts = [dir('s*.txt')];
            for  k = 1:length(ICAcounts); 
                ICAcount = ICAcounts(k).name;
                % subject number in first column
                 ICAsname = ICAcount(1,2:4);
                 ICAlist(1+k,1)= str2num(ICAsname); 
                % Write the number of trials in the next rows
                ICAnumber = load (ICAcount);
                ICAlist(1+k,2) = ICAnumber;
                %save to txt file in same folder 
                
                dlmwrite('ICA-all.txt',ICAlist)
            end

    end
%                 
 end
      


 