%%% Script for copying files to backup in BigBrother folder.

DESTINATION = 'X:\fraga\EEG_Gorka\Analysis_EEGlab11'; 
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
   N=cell2mat(answer(2));N = str2num(N);
%--------------------------------------------------------------------------
for G = G; 
    if  G == 0 
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
        [ICAfiles] =['s',num2str(G),'0',num2str(N),'*ICA.*'];
        [ICAprunedFiles] = ['s', num2str(G),'0', num2str(N),'*ICA-pruned.*']; 
        [EpCleanFiles] = ['s', num2str(G),'0', num2str(N),'*EpClean.*']; 
        
    elseif N >=10 && N<100   
        [ICAfiles] =['s',num2str(G),num2str(N),'*ICA.*'];
        [ICAprunedFiles] = ['s', num2str(G), num2str(N),'*ICA-pruned.*']; 
        [EpCleanFiles] = ['s', num2str(G),num2str(N),'*EpClean.*']; 
    end
    
    
    ICAFILES= [dir(ICAfiles)]; %Search in current Dir files 
    ICAPRUNEDFILES= [dir(ICAprunedFiles)]; 
    EPCLEANFILES = [dir(EpCleanFiles)]; 

    %%% copy ICA FILES
for  J = 1:length(ICAFILES); %J contains the list of the files containing'
  FILENAME1 = [ICAFILES(J).name]; %Use the dimension name of each element of the list J as filename
  SOURCE = [DIRNAME,'\',FILENAME1];

 if ~isempty(dir(FILENAME1)) 
   copyfile (SOURCE,DESTINATION)
 end
end

%%% copy ICAPRUNEDFILES
for  J = 1:length(ICAPRUNEDFILES); %J contains the list of the files containing'
  FILENAME1 = [ICAPRUNEDFILES(J).name]; %Use the dimension name of each element of the list J as filename
  SOURCE = [DIRNAME,'\',FILENAME1];

 if ~isempty(dir(FILENAME1)) 
   copyfile (SOURCE,DESTINATION)
 end
end
%% copy EPCLEAN
for  J = 1:length(EPCLEANFILES); %J contains the list of the files containing'
  FILENAME1 = [EPCLEANFILES(J).name]; %Use the dimension name of each element of the list J as filename
  SOURCE = [DIRNAME,'\',FILENAME1];

 if ~isempty(dir(FILENAME1)) 
   copyfile (SOURCE,DESTINATION)
 end
end
%%%%%%%
end
end
