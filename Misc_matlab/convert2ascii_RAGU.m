%% Convert data to ASCII to import in RAGU
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Define plot inputs and format';
   numlines=1;
   defaultanswer = {'1:21,302:320,201:220'};
   options.Resize='on';
   options.WindowStyle='modal';
    
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN=cell2mat(answer(1));NN= str2num(NN);
%--------------------------------------------------------------------------
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_RAGU\ascii';
%% load EEG per subject
% Find subjects Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  

DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Data VWR Responses excluded';
 for N = NN; 
  if N < 100
    groupname = 'PreLexi';
    allgroupname(1) = {groupname};
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg_noR.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg_noR.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg_noR.mat'];  
        if  N >= 100 &&  N < 200  
        groupname = 'PreSchool';
        allgroupname(2) = {groupname};
        elseif  N >=200 && N<300
        groupname = 'CtrlAge';
        allgroupname(3) = {groupname};  
        elseif N >=300 && N<400   
        groupname = 'CtrlDys';
        allgroupname(4) = {groupname};
        elseif N >=400 && N<500
        groupname = 'PostDys';
        allgroupname(5) = {groupname};
        elseif N >=500 && N<600
        groupname = 'PostSch';
        allgroupname(6) = {groupname};
        end
  end
 
cd (DIRINPUT) % 
listFiles = dir(FILES); %Search in current Dir files 
srow = find(NN==N);
    for  J = 1:length(listFiles); %J contains the list of the files 
        filename = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename
    end

if ~isempty(dir(filename));
%% Load matlab file with EEG variable (per subject)
            load (filename)
            eventIndx = [21 22 23 24];
            conditions = {'SW','LW','SS', 'LS'};
    cd (DIROUTPUT); 
    
    for c = 1:length(conditions);
        data2shuffle = eval(['EEG','_',cell2mat(conditions(c))]);
        data2shuffle =  double(mean(data2shuffle,3))';% average trials and transpose to match RAGU formar
        data2shuffle = data2shuffle(:,1:64);%keep only scalp channels
        newfilename = [filename(1:4),'_',conditions{c}];
        save([newfilename,'.asc'],'data2shuffle','-ascii');
    end
%     % THIS SECTIONS WAS USED WHEN THE EEG STRUCT IS LOADED
%        for l = 1:length(eventIndx);%Find epoch indexes looping through event types 
%             E = struct2cell(EEG.event); 
%             [r, col] = find(cell2mat(E(1,:,:))==eventIndx(1,l));% find epochs for event type
%             epIndx = cell2mat(squeeze(E(4,:,col)));% rows of epIndx are epoch number with the event defined
%                 if eventIndx(1,l) == 21 % Create one variable for each type of event searched 
%                     SW = EEG.data(:,:,epIndx);SW = double(mean(SW,3));
%                     SW = SW';
%                     newfilename = [filename(1:4),'_',conditions{1}];
%                     save([newfilename,'.asc'],'SW','-ascii');
%                  elseif eventIndx(1,l) == 22
%                     LW = EEG.data(:,:,epIndx);LW = double(mean(LW,3));
%                     LW = LW';
%                     newfilename = [filename(1:4),'_',conditions{2}];
%                     save([newfilename,'.asc'],'LW','-ascii');
%                 elseif eventIndx(1,l) == 23
%                     SS = EEG.data(:,:,epIndx);SS = double(mean(SS,3));
%                     SS = SS';
%                     newfilename = [filename(1:4),'_',conditions{3}];
%                     save([newfilename,'.asc'],'SS','-ascii');                    
%                 elseif eventIndx(1,l) == 24
%                     LS = EEG.data(:,:,epIndx);LS = double(mean(LS,3));
%                     LS = LS';
%                     newfilename = [filename(1:4),'_',conditions{4}];
%                     save([newfilename,'.asc'],'LS','-ascii');
%                 end
%         end
     cd (DIRINPUT);
      
end
 end

 