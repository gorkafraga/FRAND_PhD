close all 
clear all
%%
dirinput = 'Z:\fraga\EEG_Gorka\Presentation Log Files';
%filename = '001_vwr.txt';
DIROUTPUT = 'H:\GORKA\Statistical Analysis\FRAND_SPSS\ERP Analysis Responses Excluded\MS3 analysis_longitudinal';
%----------------------------------------------------
%% Search
 cd (dirinput)
 files = '*_vwr.txt';
 
%Search in current Dir files 
listFiles = dir(files); %Search in current Dir files 
RTgroup = cell(length(listFiles),4);
for  J = 1:length(listFiles); %J contains the list of the files 
  filename = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

if ~isempty(dir(filename))

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
% for l = 1:length(hits)
%        if ~strcmp(hits(l,2),'0')==1 
%            hits(l,2)={'1'};
%        end
% end
%% Average hit RTs per condition

%convert'hits'to num array with 3 decimals
hitsnum = zeros(length(hits),1);
for L = 1:length(hits); 
     junk = hits{L,2}; 
     if ~strcmp(junk,'0')== 1;
         if length(junk)== 3;
             junk = ['0',junk];
         end
         temp = str2num(junk);
         hitsnum(L) = temp;
     end       
end

 c21 = hitsnum(strcmp(hits(:,1),'21'));
    RT21 = mean(c21);
 c22 = hitsnum(strcmp(hits(:,1),'22')); 
    RT22 = mean(c22);       
 c23 =  hitsnum(strcmp(hits(:,1),'23')); 
    RT23 = mean(c23);      
 c24 =  hitsnum(strcmp(hits(:,1),'24')); 
    RT24 = mean(c24);
          
    RTs = [RT21,RT22,RT23, RT24];
%  c21 = hits((strcmp(hits(:,1),'21')),:); 
%    count21 = length(find(str2num(cell2mat(c21(:,2)))));
%  c22 = hits((strcmp(hits(:,1),'22')),:); 
%    count22 = length(find(str2num(cell2mat(c22(:,2)))));        
%  c23 = hits((strcmp(hits(:,1),'23')),:); 
%    count23 = length(find(str2num(cell2mat(c23(:,2)))));        
%   c24 = hits((strcmp(hits(:,1),'24')),:); 
%    count24 = length(find(str2num(cell2mat(c24(:,2)))));    
%    
%  count = [count21,count22,count23,count24];
   
%% Include in group array

RTgroup(J,:) = num2cell(RTs);

clear count
clear c21 c22 c23 c24
else 
     fprintf('File %s not found\n',filename);
end
end
filenames = str2mat(listFiles.name);for f = 1:length(filenames); subjects{f,:}=filenames(f,1:3);end
RTgroup = [subjects,RTgroup]; % include subject number
cd (DIROUTPUT)
    save ('HitsGroupRT', 'RTgroup');
    xlswrite('HitsGroupRT', RTgroup);
