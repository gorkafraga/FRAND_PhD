close all 
clear all
%%
%Dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Log_files_pretest';
%filename = '001_vwr.txt';
DIROUTPUT = 'H:\GORKA\Statistical Analysis\FRAND_SPSS\ERP Analysis Responses Excluded\MS3 analysis_longitudinal';
%----------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'1,3:11,13:19,21,201:220,401,403:411,413:419,421'};
   options.Resize='on';
   options.WindowStyle='modal';

   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   n=cell2mat(answer(1));n = str2num(n);
   
    
for N = n; 
    dirinput = 'Z:\fraga\EEG_Gorka\Presentation Log Files';
  if N < 100
    %dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Pretest\Log_files_pretest';
        if N < 10 
           files =['00',num2str(N),'_vwr.txt'];
        elseif N >=10 && N<100   
           files =['0',num2str(N),'_vwr.txt'];
        end
  elseif N >=100
        files =[num2str(N),'_vwr.txt'];  
%         if  N >= 100 &&  N < 200  
%            % dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Pretest\Log_files_pretest';
%              elseif  N >=200 && N<300
%            % dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Control\Log_files_control';
%                elseif N >=300 && N<400   
%             %dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Control\Log_files_control';  
%             elseif N >=400 && N<500
%             %dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Posttest\Log_files_posttest';
%             elseif N >=500 && N<600
%             %dirinput = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab_old\Dyslexie_Posttest\Log_files_posttest';
%        end
  end
   
cd (dirinput)
%Search in current Dir files 
listFiles = dir(files); %Search in current Dir files 
for  J = 1:length(listFiles); %J contains the list of the files 
  filename = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

if ~isempty(dir(filename))

 subjrow=find(N==n);     
%% Read text file and arrrange in cell array 
log = textread(filename, '%s', 'delimiter','\n', 'whitespace',''); 
for r=1:length(log);    
         strng = cell2mat (log(r));
        % Trim off any leading & trailing blanks & Locate white-spaces
        strng=strtrim(strng); spaces=isspace(strng);
        % Build the cell array
        idx=0;
        while sum(spaces)~=0
            idx=idx+1; strngCells{idx}=strtrim(strng(1:find(spaces==1,1,'first')));
            strng=strtrim(strng(find(spaces==1,1,'first')+1:end)); spaces=isspace(strng);
        end
        strngCells{idx+1}=strng; %
        newlog(r,:)=strngCells;
end

%% find targets: 
i = 1;
for l = 1:length(newlog); 
    if ~strcmp(newlog(l,3),'nontarget')== 1; 
        targets(i,:)= newlog(l,:);
        i = i +1;
    else continue
    end
end
%% obtain target info

% Features: 1 True(short) False(long)
%            2 True (symbol) False (word)

hits = [targets(:,3),targets(:,8)];
% specify event type
for l = 1:length(targets);
    if (strcmp(targets(l,5),'true')==1 && strcmp(targets(l,6),'false')==1);% TF = Short words = 21
        hits(l,1)={'21'};
    elseif (strcmp(targets(l,5),'false')==1 && strcmp(targets(l,6),'false')==1);% FF = long words = 22
        hits(l,1)={'22'};
    elseif (strcmp(targets(l,5),'true')==1 && strcmp(targets(l,6),'true')==1);% TT = short symbols = 23
        hits(l,1)={'23'};
    elseif (strcmp(targets(l,5),'false')==1 && strcmp(targets(l,6),'true')==1);% TT = long symbols = 24
        hits(l,1)={'24'};
    end
end

%% If there is a response: hit = 1. If not 0 
for l = 1:length(hits)
       if ~strcmp(hits(l,2),'0')==1 
           hits(l,2)={'1'};
       end
end
%% Count hits per condition
          
 c21 = hits((strcmp(hits(:,1),'21')),:); 
   count21 = length(find(str2num(cell2mat(c21(:,2)))));
 c22 = hits((strcmp(hits(:,1),'22')),:); 
   count22 = length(find(str2num(cell2mat(c22(:,2)))));        
 c23 = hits((strcmp(hits(:,1),'23')),:); 
   count23 = length(find(str2num(cell2mat(c23(:,2)))));        
  c24 = hits((strcmp(hits(:,1),'24')),:); 
   count24 = length(find(str2num(cell2mat(c24(:,2)))));    
   
 count = [count21,count22,count23,count24];
   
%% Include in group array

countgroup(subjrow,:) = count;

clear count
clear c21 c22 c23 c24
else 
     fprintf('File %s not found\n',filename);
end
end
end
countgroup = [n',countgroup]; % include subject number
cd (DIROUTPUT)
    save ('countHitsGroup', 'countgroup');
    xlswrite('countHitsGroup', countgroup);
