%%%%% EXPORT PEAK values to Excel sheet. 
%%% Load multiple subjects and save in Excel table
%%  Define directory and output array
clear all
close all
%% Input: subject code (groupnNo + subjectNo) and electrodes 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'401,403:411,413:419,421'};
   options.Resize='on';
   options.WindowStyle='modal';
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN = cell2mat(answer(1)); NN = str2num(NN); %#ok<ST2NM>


%% Define filenames. Including group directory and name of group (to use as figurename )
DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD_noR_long';
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD_noR_long';

for N = NN; %loop through subjects
  if N < 100
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];   
  end
%% Load data
cd (DIRINPUT)

%Search in current Dir files 
if ~isempty(dir(FILES))

filename = dir(FILES); 
filename = filename.name;
load (filename); % load the matlab file

cd (DIROUTPUT);
srow = find(NN==N);
%% reshuffle columns to display first amplitudes and then latencies
    %Horiz concat. of subject no, data of amplitudes and data of latencies
    P1resh = [P1(:,1),P1(:,(~cellfun('isempty',(strfind(P1(1,:),'amp'))))),...
                        P1(:,(~cellfun('isempty',(strfind(P1(1,:),'lat')))))];
                    
    P2resh = [P2(:,1),P2(:,(~cellfun('isempty',(strfind(P2(1,:),'amp'))))),...
                        P2(:,(~cellfun('isempty',(strfind(P2(1,:),'lat')))))];
    
    N1resh = [N1(:,1),N1(:,(~cellfun('isempty',(strfind(N1(1,:),'amp'))))),...
                        N1(:,(~cellfun('isempty',(strfind(N1(1,:),'lat')))))];
 
 % get  headers  (same for all subjects)
   hP1 = P1resh(1,:);
   hP2 = P2resh(1,:);
   hN1 = N1resh(1,:);

   % get subject value and concatenate
   valuesP1 = P1resh(2,:);
   valuesP2 = P2resh(2,:);
   valuesN1 = N1resh(2,:);
%% save in group array   
   groupP1(srow,:) = valuesP1;
   groupP2(srow,:) = valuesP2;
   groupN1(srow,:) = valuesN1;
   
 else 
            fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
 end
end
    groupP1 = [hP1;groupP1];
    groupP2 = [hP2;groupP2];
    groupN1 = [hN1;groupN1];
% 
 cd (DIROUTPUT) 
   save('groupP1', 'groupP1');
   save('groupP2', 'groupP2');
   save('groupN1', 'groupN1');
   xlswrite('groupP1.xls',groupP1);
   xlswrite('groupP2.xls',groupP2);
   xlswrite('groupN1.xls',groupN1);
