clear all
close all
%%%%% CHECK FOR RESPONSES LATENCIES AND NUMBER. ALSO EPOCHS WITH RESPONSES
% %%%%% CREATES 2 LISTS IN EXCEL:
% %%%%% sXXX-responses: (variable 'responses' in script)
%             1- Latencies of each response per event. 
%             2- Number of epochs with multiple responses (per event)
%             3- Number of epochs with single response( per event)
%             4- Total of 2 & 3
% %%%%% sXXX-resp-stats: (varible 'resp-stats'in script)
%               1- Average latency of all responses per event.
%               2- SD of latencies per event
%               3- Number of responses per event
%               4- Total number of responses,avg,SD
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5)'; 'Define Subjects (1:22)'};
   name='Input subject and group';
   numlines=1;
   defaultanswer = {'?','??'};
   options.Resize='on';
   options.WindowStyle='modal';
   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2num(G); 
   n=cell2mat(answer(2));n = str2num(n);
   
%--------------------------------------------------------------------------

for G = G; %Select group folder in which it will make the count
    if  G == 0 
        GROUPNAME = 'Pretest_dyslexia';
        elseif G == 1
         GROUPNAME = 'Pretest_school';
        elseif G == 2
        GROUPNAME = 'Control_school';
        elseif G == 3
        GROUPNAME = 'Control_dyslexia';  
        elseif G == 4
        GROUPNAME = 'Posttest_dyslexia';
        elseif G == 5
        GROUPNAME = 'Posttest_school';
    end;
[DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Responses';    
DIROUT = DIRNAME;
cd (DIRNAME )

 groupstats = cell(4,6); 
  groupstats(1,1:6) = {GROUPNAME,'21','22','23','24','total'};
  groupstats(2:4,1) = {'MeanLat','SD','nR'}';
  allsubstats = cell(1,16);
  allsubstats(1,1:16) = {'s','21M','SD','n','22M','SD','n','23M','SD','n','24','SD','n','total','SD','n'};
 
FILE = ['s',num2str(G),'*resp-stats.xls'];
% for N = n; 
%   if N < 10
%      [FILENAME] =['s',num2str(G),'0',num2str(N),'-resp-stats'];
%     elseif N >=10 && N<100   
%     [FILENAME] =['s',num2str(G),num2str(N),'-resp-stats'];
%   end

% FILENAME1 = [FILENAME, '.xls'];
FILES = [dir(FILE)]; %Search in current Dir files 

 for  r = 1:length(FILES);% r contains the list of the files containing'
      FILENAME = [FILES(r).name]; %Use the dimension name of each element of the list J as filename

%  if ~isempty(dir(FILENAME1))

%%%% Get info from subject file and add it to array containing all subjects
%------------------------------------------------------------------------

respstats = xlsread (FILENAME);
% for  r = 1:length(N);

    allsubstats(1+r,1) = {FILENAME(1:4)};
    allsubstats(1+r,2) = {respstats(2,2)};
    allsubstats(1+r,3) = {respstats(3,2)};
    allsubstats(1+r,4) = {respstats(4,2)};
    allsubstats(1+r,5) = {respstats(2,3)};
    allsubstats(1+r,6) = {respstats(3,3)};
    allsubstats(1+r,7) = {respstats(4,3)};
    allsubstats(1+r,8) = {respstats(2,4)};
    allsubstats(1+r,9) = {respstats(3,4)};
    allsubstats(1+r,10) = {respstats(4,4)};
    allsubstats(1+r,11) = {respstats(2,5)};
    allsubstats(1+r,12) = {respstats(3,5)};
    allsubstats(1+r,13) = {respstats(4,5)};
    allsubstats(1+r,14) = {respstats(2,1)};
    allsubstats(1+r,15) = {respstats(3,1)};
    allsubstats(1+r,16) = {respstats(4,1)};

   
end;



SWlats= cell2mat(allsubstats(2:end,2));
SWlats(isnan(SWlats))=[];
SWn= cell2mat(allsubstats(2:end,4));
SWn(isnan(SWn))=[];
LWlats= cell2mat(allsubstats(2:end,5));
LWlats(isnan(LWlats))=[];
LWn= cell2mat(allsubstats(2:end,7));
LWn(isnan(LWn))=[];
SSlats= cell2mat(allsubstats(2:end,8));
SSlats(isnan(SSlats))=[];
SSn= cell2mat(allsubstats(2:end,10));
SSn(isnan(SSn))=[];
LSlats= cell2mat(allsubstats(2:end,11));
LSlats(isnan(LSlats))=[];
LSn= cell2mat(allsubstats(2:end,13));
LSn(isnan(LSn))=[];
TOTALlats= cell2mat(allsubstats(2:end,14));
TOTALlats(isnan(TOTALlats))=[];
TOTALn= cell2mat(allsubstats(2:end,16));
TOTALn(isnan(TOTALn))=[];



groupstats(2,2) = { mean(SWlats)};
groupstats(3,2) = { std(SWlats)};
groupstats(4,2) = { mean(SWn)};
groupstats(2,3) = { mean(LWlats)};
groupstats(3,3) = { std(LWlats)};
groupstats(4,3) = { mean(LWn)};
groupstats(2,4) = { mean(SSlats)};
groupstats(3,4) = { std(SSlats)};
groupstats(4,4) = { mean(SSn)};
groupstats(2,5) = { mean(LSlats)};
groupstats(3,5) = { std(LSlats)};
groupstats(4,5) = { mean(LSn)};
groupstats(2,6) = { mean(TOTALlats)};
groupstats(3,6) = { std(TOTALlats)};
groupstats(4,6) = { mean(TOTALn)};


   
    %%%==================================================================
    %%% Go to common folder ('Responses') and save there outpuf for each S
    cd (DIROUT); 
    FILEOUT = [GROUPNAME, '-stats'];   
    FILEOUT2 = [GROUPNAME, '-Allsubstats'];
     % save as excel file
    xlswrite(FILEOUT, groupstats)
    xlswrite(FILEOUT2,allsubstats)
    
    
    %   % % %====================================================================
%   clear ALLEEG
%   clear EEG
%   clear latencies
%   eeglab redraw


end

