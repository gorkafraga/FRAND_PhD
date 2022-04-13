% Load EEGlab data set and save as Matlab file

%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???'};
   options.Resize='on';
   options.WindowStyle='modal'; 
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   n=cell2mat(answer(1));n =str2num(n);
%--------------------------------------------------------------------------
%% Define subjects. Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

 for N = n; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
     if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.set'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.set'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.set'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        end
  end

% Get full filename by searching in directory relevant files.
%  and load in eeglab. 
%===============================================================
cd (DIRINPUT) % 
listFiles = dir(FILES); %Search in current Dir files 
for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename
    if ~isempty(dir(FILENAME1))
      EEG = pop_loadset('filename',FILENAME1);
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
      newname = strrep (FILENAME1, '.set','.mat');
      newname(5:22) =[];
      save (newname, 'EEG')
       eeglab redraw
    else 
           fprintf('File %s not found\n',FILENAME1);
    end
end
%return to previous folder (two parten folders from group folder)
cd ..
cd .. 
end
%