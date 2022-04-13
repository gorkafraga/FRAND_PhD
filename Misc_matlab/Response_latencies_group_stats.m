clear all
close all
%%%%% Group latencies (M and SD) of false alarm responses
[DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Responses';    
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Responses\Group_responses\Group_Latencies';
cd (DIRNAME )
%-------------------------------------------------------------------------
%% Define output arrays:
% output array with all subjects of group
 header1 = {'TotalM','TotalSE','21M','21SE','22M','22SE','23M','23SE','24M','24SE','Subject'};
 allLats = cell(1,length(header1));
 allLats (1,1:end) = header1;
% output array with stats
 header = {'','Total','21SW','22LW','23SS','24LS'};
groupRlatencies = cell(1,length(header));
groupRlatencies (1,1:end) = header;
groupRlatencies (2,1) = {'Mean'};
groupRlatencies (3,1) = {'SE'};
groupRlatencies (4,1) = {'nsubjects'};
%% Input popup -------------------------------------------------------------------------
   prompt={'Define Subjects (1:522)'};
   name='Input subject and group';
   numlines=1;
   defaultanswer = {'!give only exact subjects!! it will count N for SE'};
   options.Resize='on';
   options.WindowStyle='modal';
   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
      n=cell2mat(answer(1));n = str2num(n);
      
   %--------------------------------------------------------------------------
 %Select group folder in which it will make the count
for N = n; 
  if N < 100
    GROUP = 'PreLexi';
    groupnames(1) = {GROUP};
        if N < 10 
           FILES =['s','00',num2str(N),'_respstats.mat'];
        elseif N >=10 && N<100   
           FILES =['s','0',num2str(N),'_respstats.mat'];
        end
  elseif N >=100
        FILES =['s',num2str(N),'_respstats.mat'];  
        if  N >= 100 &&  N < 200  
        GROUP = 'PreSchool';
        groupnames(2) = {GROUP};
        elseif  N >=200 && N<300
        GROUP = 'CtrlAge';
        groupnames(3) = {GROUP};  
        elseif N >=300 && N<400   
        GROUP = 'CtrlDys';
        groupnames(4) = {GROUP};
        elseif N >=400 && N<500
        GROUP = 'PostDys';
        groupnames(5) = {GROUP};
        elseif N >=500 && N<600
        GROUP = 'PostSch';
        groupnames(6) = {GROUP};
        end
  end
   

listFiles = dir(FILES); %Search in current Dir files 

%% load mat file
for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

if ~isempty(dir(FILENAME1))
      srow=find(N==n); 
    
      load (FILENAME1)
    
    allLats(1+srow,end) = {FILENAME1(2:4)};
    allLats(1+srow,1) = respstats(2,2);
    allLats(1+srow,2) = {cell2mat(respstats(3,2))/sqrt(length(n))};
    allLats(1+srow,3) = respstats(2,3);
    allLats(1+srow,4) = {cell2mat(respstats(3,3))/sqrt(length(n))};
    allLats(1+srow,5) = respstats(2,4);
    allLats(1+srow,6) = {cell2mat(respstats(3,4))/sqrt(length(n))};
    allLats(1+srow,7) = respstats(2,5);
    allLats(1+srow,8) = {cell2mat(respstats(3,5))/sqrt(length(n))};
    allLats(1+srow,9) = respstats(2,6);
    allLats(1+srow,10) = {cell2mat(respstats(3,6))/sqrt(length(n))};
    allLats(cellfun('isempty',allLats))={0};
end;
end
end


 %% GROUP STATISTICS IN array:
 
 groupRlatencies(2,2) = {mean(cell2mat(allLats(2:end,1)))};
 groupRlatencies(3,2) = {mean(cell2mat(allLats(2:end,2)))};
  groupRlatencies(2,3) = {mean(cell2mat(allLats(2:end,3)))};
 groupRlatencies(3,3) = {mean(cell2mat(allLats(2:end,4)))};
  groupRlatencies(2,4) = {mean(cell2mat(allLats(2:end,5)))};
 groupRlatencies(3,4) = {mean(cell2mat(allLats(2:end,6)))};
  groupRlatencies(2,5) = {mean(cell2mat(allLats(2:end,7)))};
 groupRlatencies(3,5) = {mean(cell2mat(allLats(2:end,8)))};
  groupRlatencies(2,6) = {mean(cell2mat(allLats(2:end,9)))};
 groupRlatencies(3,6) = {mean(cell2mat(allLats(2:end,10)))};
 
 groupRlatencies(4,2) = {length(n)};
%% save 
% name figure with the group names used
groupnames(cellfun('isempty',groupnames)) = [];
groupnames=unique(groupnames);
groupnames = [sprintf('%s-',groupnames{1:end-1}),groupnames{end}];
 
cd (DIROUTPUT); 
    newfilename = [groupnames,'_allLatencies'];
    groupnewfilename = [groupnames,'_groupRLatencies'];
   % save as excel file and mat
    save (strrep(newfilename,'-','_'), 'allLats');
    save (strrep(groupnewfilename,'-','_'), 'groupRlatencies');
    xlswrite(newfilename, allLats);
    xlswrite(groupnewfilename, groupRlatencies);

