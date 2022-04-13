%%%%% TOPOGRAPHICAL MAPS OF ACTIVITY
%================================================================
%%  Define directory 
close all
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PD';
%% Input: subject code (groupnNo + subjectNo) and electrodes 
   prompt={'Define group-subject code (1 to 522)','Define channels of interest(chans)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???','16,22:30,53,59:64'};
   options.Resize='on';
   options.WindowStyle='modal';
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN = cell2mat(answer(1)); NN = str2num(NN); %#ok<ST2NM>
   chans=cell2mat(answer(2)); chans = str2num(chans); %#ok<ST2NM>

%% Define filenames. Including group directory and name of group (to use as figurename )

for N = NN; %loop through subjects
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    TABLENAME = 'PreLexi';
    figGroupName(1) = {TABLENAME};
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        TABLENAME = 'PreSchool';
        figGroupName(2) = {TABLENAME};
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        TABLENAME = 'CtrlAge';
        figGroupName(3) = {TABLENAME};  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        TABLENAME = 'CtrlDys';
        figGroupName(4) = {TABLENAME};
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        TABLENAME = 'PostDys';
        figGroupName(5) = {TABLENAME};
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        TABLENAME = 'PostSch';
        figGroupName(6) = {TABLENAME};
        end
  end
  
cd (DIRINPUT)
 %Search in current Dir files 

if ~isempty(dir(FILES))
filename = dir(FILES); 
filename = filename.name;

load (filename); % load the matlab file

% Now EEG variable is loaded

%%   Get EEG.data for each of the experimental conditions
%First find the index of the epochs containing the events specified 
% Out: one variable for each type of event (condition)
% -------------------------------------------------------------------------
eventIndx = [21 22 23 24];
    for l = 1:length(eventIndx)%Find epoch indexes looping through event types 
    E = struct2cell(EEG.event); 
    [r, col] = find(cell2mat(E(1,:,:))==eventIndx(1,l));% find epochs for event type
    epIndx = cell2mat(squeeze(E(4,:,col)));% rows of epIndx are epoch number with the event defined
        if eventIndx(1,l) == 21 % Create one variable for each type of event searched 
            EEG_SW = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 22
            EEG_LW = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 23
            EEG_SS = EEG.data(:,:,epIndx);
        elseif eventIndx(1,l) == 24
            EEG_LS = EEG.data(:,:,epIndx);
        end
    end
% Topographic activity plots  !!   ======================== 

 %Define conditions to loop
  conditions = ['EEG_SW'; 'EEG_LW';'EEG_SS';'EEG_LS'] ;   
  figurename = [filename(1:4), '-topographical map of activity'];

  figure (2);
  set(gcf,'name',figurename);

for c = 1:size(conditions,1);
    data2use = eval(conditions(c,:)); % data contains EEG for each condition
  % Topographic plot of activity 
    times2plot = 0:100:600;
     clim = [-10 10];
      if            c == 1 %Define name of conditions
             strCond = 'ShortWords';
         elseif     c == 2 
              strCond = 'LongWords';
         elseif     c == 3
              strCond = 'ShortSymbols';
          elseif    c == 4 
              strCond = 'LongSymbols'; 
      end
  
    for timei=1:length(times2plot)
        % convert time in ms to index
        [junk,timeidx] = min(abs(EEG.times-times2plot(timei)));
        % plot in subplot (position defined by time in relation to condit)
        subplot(4,length(times2plot),timei+c*length(times2plot)-length(times2plot));
        if timei == 1; 
             text (-2,0,strCond,'EdgeColor', 'black') ;
        end
        
        topoplot(squeeze(mean(data2use(:,timeidx,:),3)),EEG.chanlocs,'plotrad',.53,'maplimits',clim );
        title([ 'ERPs at ' num2str(round(EEG.times(timeidx))) 'ms' ], 'FontSize',8)
        grid off
    end

    
end
    colorbar('Position',[0.9500 0.1100 0.015 0.1577]);
    set(gcf, 'Position', get(0,'Screensize')); % Maximize figure
    % Save to file in Output Dir 
    cd (DIROUTPUT)
 saveas (gcf,figurename, 'fig');
 saveas (gcf,figurename, 'tiff')
 close gcf
 cd (DIRINPUT)    
  
else 
           fprintf('File %s not found\n',['subject',' ',FILES(2:4)]);
end
end
% %  end