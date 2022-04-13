% ================================================================================
%GRAND AVERAGE - PLOT OF INDIVIDUAL CHANNELS (Amplitude/time) 
%-------------------------------------------------------------
% Input: mat file with EEG struct variable containing all EEG data
% It does peak detection to label the peaks in the plot.
% User defines in popup: Channels and subjects to average. 
% Saves .fig and .tiff in DIROUTPUT (write below)
% Variable: 'eventIndx' contains experimental conditions to avg data. Each
% condition is saved in an individual variable per each subject. Then the
% group averages are computed and one group variable per condition created.
%-------------------------------------------------------------------------
%% Define output directory 
clear all
close all
%----------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)','Electrodes to plot','Color(1) or Black&White (0)?','with significance(1) or without significance(0)?'};
   name='Define plot inputs and format';
   numlines=1;
   defaultanswer = {'401,403:411,413:419,421','P9,P7,P5,PO7,PO3,O1,O2,PO4,PO8,P6,P8,P10','1','0'};
   options.Resize='on';
   options.WindowStyle='modal';
    
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   NN=cell2mat(answer(1));NN= str2num(NN);
   labels=answer{2}; labels = strrep(labels,',', ' ');
   plotcolor=answer{3}; plotcolor=str2num(plotcolor);
   withsig=answer{4}; withsig=str2num(withsig);

 % make a cell array with the channel labels from answer one in each cell 
          % Trim off any leading & trailing blanks & Locate white-spaces
            labels=strtrim(labels); spaces=isspace(labels);
           % Build the cell array
            idx=0;
            while sum(spaces)~=0
                idx=idx+1; chanlabels{idx}=strtrim(labels(1:find(spaces==1,1,'first')));
                labels=strtrim(labels(find(spaces==1,1,'first')+1:end)); spaces=isspace(labels);
            end
            chanlabels{idx+1}=labels;
%--------------------------------------------------------------------------
%% Define output folder
% if plotcolor == 1;
%     [DIROUTPUT] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\GrandAvgs\Color';    
% elseif plotcolor == 0;
%     [DIROUTPUT] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\GrandAvgs\BlackAndWhite';    
% end
DIROUTPUT = 'H:\GORKA\Dissertation_Manuscripts\1_VisualSpecializationForWordsInDyslecticAndTypicallyReadingChildren';
%% Find subjects Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  
 for N = NN; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    FIGURENAME = 'PreLexi';
    figGroupName(1) = {FIGURENAME};
      
    if N < 10 
       FILES =['s','00',num2str(N),'*refAvg.mat'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*refAvg.mat'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*refAvg.mat'];  
        if  N >= 100 &&  N < 200  
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school\';
        FIGURENAME = 'PreSchool';
        figGroupName(2) = {FIGURENAME};
        elseif  N >=200 && N<300
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age\';
        FIGURENAME = 'CtrlAge';
        figGroupName(3) = {FIGURENAME};  
        elseif N >=300 && N<400   
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia\';  
        FIGURENAME = 'CtrlDys';
        figGroupName(4) = {FIGURENAME};
        elseif N >=400 && N<500
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI\';
        FIGURENAME = 'PostDys';
        figGroupName(5) = {FIGURENAME};
        elseif N >=500 && N<600
        DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school\';
        FIGURENAME = 'PostSch';
        figGroupName(6) = {FIGURENAME};
        end
  end
   
% Get full file name by searching in directory relevant files. 
%  and load ALL files in eeglab. 
cd (DIRINPUT) % 
listFiles = dir(FILES); %Search in current Dir files 
srow = find(NN==N);

for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

    if ~isempty(dir(FILENAME1))
 %% Load matlab file with EEG variable (per subject)
 load (FILENAME1)
 nchans = EEG.nbchan;
 times = EEG.times;
 chanlocs = EEG.chanlocs;   
%%  REMOVE RESPONSES FROM EEG.data for each of the experimental conditions
%  First find the index of the epochs containing the events specified 
% Output: one variable for each type of event (condition)
% -------------------------------------------------------------------------
    eventIndx = [21 22 23 24];
    for l = 1:length(eventIndx)%Find epoch indexes looping through event types 
        E = struct2cell(EEG.event); 
        [r, col] = find(cell2mat(E(1,:,:))==eventIndx(1,l));% find epochs for event type
        ep =cell2mat(squeeze(E(4,:,col)));% rows of epIndx are epoch number with the event defined
        [r1, col1] = find(cell2mat(E(1,:,:))==12);% find epochs for event type
        rIndx = cell2mat(squeeze(E(4,:,col1)));%
        epIndx = setdiff(ep,rIndx); % take only epoch without responses
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

%% save individual in group cell array with the averages
group_SW{srow,:}= mean(EEG_SW(:,:,:),3);
    emptyCells = cellfun('isempty', group_SW);
    group_SW(all(emptyCells,2),:) = []; 
group_LW{srow,:}= mean(EEG_LW(:,:,:),3);
    emptyCells = cellfun('isempty', group_LW);
    group_LW(all(emptyCells,2),:) = [];
group_words{srow,:} = (mean(EEG_SW(:,:,:),3)+mean(EEG_LW(:,:,:),3))/2;
%
group_SS{srow,:}= mean(EEG_SS(:,:,:),3);
  emptyCells = cellfun('isempty', group_SS);
    group_SS(all(emptyCells,2),:) = [];
group_LS{srow,:}= mean(EEG_LS(:,:,:),3);
    emptyCells = cellfun('isempty', group_LS);
    group_LS(all(emptyCells,2),:) = [];
group_symbols{srow,:} = (mean(EEG_SS(:,:,:),3)+mean(EEG_LS(:,:,:),3))/2;
%
group_diff{srow,:} = [(mean(EEG_SW(:,:,:),3)+mean(EEG_LW(:,:,:),3))/2]-[(mean(EEG_SS(:,:,:),3)+mean(EEG_LS(:,:,:),3))/2];
%% Save arrays with subject as row time seconds as columns and a 3rd dimension for channels


    else 
           fprintf('File %s not found\n',FILENAME1);
    end
clear EEG
end
cd .. 
cd .. 
end
 %return to previous folder

%% get data 2 plot from group
  % Average each channel 
for k = 1:nchans;
  for rr = 1:length(group_SW); 
      rowdata = group_SW{rr,:};
      chandata(k,:) = rowdata(k,:); 
      data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_SW(k,:)=mean(data2average,1);%contains average of one channel
end
 for k = 1:nchans
  for rr = 1:length(group_LW); 
      rowdata = group_LW{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_LW(k,:)=mean(data2average,1);%contains average of one channel
 end
 for k = 1:nchans
  for rr = 1:length(group_SS); 
      rowdata = group_SS{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_SS(k,:)=mean(data2average,1);%contains average of one channel
 end
 for k = 1:nchans
  for rr = 1:length(group_LS); 
      rowdata = group_LS{rr,:};
      chandata(k,:) = rowdata(k,:); 
     data2average (rr,:)= chandata(k,:); 
  end
  groupEEG_LS(k,:)=mean(data2average,1);%contains average of one channel
 end
 %% Grand averages 
groupEEGwords = ((groupEEG_SW + groupEEG_LW)/2);
groupEEGsymbols = ((groupEEG_SS + groupEEG_LS)/2);
% name figure with the group names used
figGroupName(cellfun('isempty',figGroupName)) = [];
figGroupName=unique(figGroupName);
figGroupName = [sprintf('%s-',figGroupName{1:end-1}),figGroupName{end}];

%% PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:length(chanlabels);
     for l = 1:size(chanlocs,2);
     if strcmp(chanlocs(l).labels, chanlabels(k))==1         
%% (IF selected in pop up) GET T tests and select the significant areas
             if withsig == 1
                   ylims = [-20 20];
                    for le=1:length(group_diff);   
                        temp = cell2mat(group_diff(le));
                        temp = temp(l,:);
                        groupDiff(le,:)=temp;
                   end
                % tttest to check if the difference is different from zero, if you want to test between two samples, % change first [] with a matrix
                [h,tp] = ttest(groupDiff,[],[],[],1);
                % FDR correction for multiple t-tests
                 tFDR = mafdr(tp);
                % Recode FDR q values to 0 and 1
                %p < 0.001
                big = find(tFDR>0.001);
                small = find(tFDR<=0.001);
                bintFDR(big)=0;
                bintFDR(small)=1;
                %p < 0.01
                big2 = find(tFDR>0.01);
                small2 = find(tFDR<=0.01);
                bintFDR2(big2)=0;
                bintFDR2(small2)=1;
                %p < 0.05
                 big3 = find(tFDR>0.05);
                small3 = find(tFDR<=0.05);
                bintFDR3(big3)=0;
                bintFDR3(small3)=1;
               % p without correction
                bigt = find(tp>0.05);
                smallt = find(tp<=0.05);
                bint(bigt)=0;
                bint(smallt)=1;

                % and then just add this to your plot:
                                hold on
                                  for i =1:length(times)
                                      if bintFDR(i)==1
                                       sig = rectangle('Position',[times(i),ylims(1)+2,5,bintFDR(i)],'FaceColor','k','EdgeColor','k');
                                       uistack(sig, 'top');
                                      elseif bintFDR2(i)==1
                                       sig2 = rectangle('Position',[times(i),ylims(1)+2,5,bintFDR2(i)],'FaceColor',[0.2 0.2 0.2],'EdgeColor',[0.2 0.2 0.2]);
                                        uistack(sig2, 'top');    
						               elseif bint(i) == 1;
                                        sigt = rectangle('Position',[times(i),ylims(1)+2,5,bint(i)],'FaceColor','r','EdgeColor','r');
                                        uistack(sigt, 'top');  
                                      elseif bintFDR3(i)==1
                                       sig3 = rectangle('Position',[times(i),ylims(1)+2,5,bintFDR3(i)],'FaceColor', [0.7 0.7 0.7],'EdgeColor',[0.7 0.7 0.7]);
                                        uistack(sig3, 'top');   
                                      else
                                          continue
                                      end
                                  end
                              
                              
             end
%% Peak Detection (only to show label in the plot)
                 %  Define time boundaries and indexes for each peak:
                P1timeboundaries = [50 180] ;
                  [valsp1,P1timeidx(1)] = min(abs(times-P1timeboundaries(1)));
                  [valsp12,P1timeidx(2)] = min(abs(times-P1timeboundaries(2)));
                N1timeboundaries = [175 325];
                  [valsn1,N1timeidx(1)] = min(abs(times-N1timeboundaries(1)));
                  [valsn12,N1timeidx(2)] = min(abs(times-N1timeboundaries(2)));
                P2timeboundaries = [250 400] ;
                  [valsP2,P2timeidx(1)] = min(abs(times-P2timeboundaries(1)));
                  [valsp32,P2timeidx(2)] = min(abs(times-P2timeboundaries(2)));
                %%% get peak values for words and symbols
                 conditions = {'groupEEGwords';'groupEEGsymbols'};
     
             for c = 1:size(conditions,1);% loop through conditions
                 
                              data2use = eval(cell2mat(conditions(c,:))); % data contains EEG for each condition
                              % Get peak latencies and amplitudes
                               % uses mean activity of data for one condition during the times specified and averaging all trials 
                                [P1amp(c),P1maxtimeidx]= max(mean(data2use(l,P1timeidx(1):P1timeidx(2),:),3),[],2);
                                [P2amp(c),P2maxtimeidx]= max(mean(data2use(l,P2timeidx(1):P2timeidx(2),:),3),[],2);
                                [N1amp(c),N1maxtimeidx]=max(-1*(mean(data2use(l,N1timeidx(1):N1timeidx(2),:),3)),[],2);
                                % Latencies converted to ms
                                P1lat(c) = times(P1maxtimeidx+P1timeidx(1)-1);
                                P2lat(c) =times(P2maxtimeidx+P2timeidx(1)-1);
                                N1lat(c) = times(N1maxtimeidx+N1timeidx(1)-1);      
                   
%% plot averages and mark the peaks (per condition)
               % define lines format based on input
               if plotcolor == 0;
                    plot(times,groupEEGwords(l,:),'Color','k','LineWidth', 2);hold on;
                    plot(times,groupEEGsymbols(l,:),'Color','k','LineStyle',':','LineWidth', 2);
               elseif plotcolor ==1;
                    plot(times,groupEEGwords(l,:),'Color','b','LineWidth', 1.75);hold on;
                    plot(times,groupEEGsymbols(l,:),'Color','r','LineWidth', 1.75);
               end
                scatter(P1lat(c),P1amp(c),'Marker','.','MarkerEdgeColor','k');
                scatter(N1lat(c),-N1amp(c),'Marker','.','MarkerEdgeColor','k');
                scatter(P2lat(c),P2amp(c),'Marker','.','MarkerEdgeColor','k');           
%% Edit main ticks and limits

        %%% Include ticks every 100 ms after 0 and label: % -1500,0,200(N2comp),500,1500
%         L = [1:1600];
%         X = L(1:100:length(L))-1;
        X = 0:100:times(end);
        XTick = [-500,X];
        s = size(XTick);
        XTickLabel = cell(1,s(2));
        XTickLabel(2)= {0};
        XTickLabel(4)= {200};
        XTickLabel(7)= {500};
        XTickLabel(12)= {1000};
        XTickLabel(17)= {1500};
        set(gca,'XTick', XTick,'XTickLabel',XTickLabel)
        set(gca,'YMinorTick','off','XMinorTick','on')
        ylims = [-20 20];
        xlims = [min(times) max(times)];
        set(gca,'XLim',xlims,'Ylim',ylims);
        box off
        %% X and Y labels
        xlbl = xlabel('[ms]'); ylbl = ylabel('[\muV]');
        set(xlbl,'Position',[(xlims(2)-xlims(2)/20),(ylims(1)-ylims(1)/6),0]);
        set(ylbl,'Position',[(xlims(1)+ xlims(2)/20),(ylims(2)-ylims(2)/8),0],'Rotation',360);

%% channel label & legend
        %------------------------------
        % legend (make invisible for now) 
        legend('Words', 'Symbols', 'Location', 'NorthEast')
        set(legend,'Visible','off');
        % 
        chname = [chanlocs(l).labels];
         txt= text(xlims(2)-(xlims(2)/20), ylims(2)-(ylims(2)/8),chname,'FontSize', 14);
            end
%% Label the peaks
 % Label is positioned 1.75 higher (or lower depending on polarity)to the peak 
 % with largest amplitude. Distance along the x axis set in relation to the
 % differences in latencies of the peak ('tracing'a triangle and h^2=c^2+c^2 )
            A = [P1lat(find(P1amp==max(P1amp)));P1amp(find(P1amp==max(P1amp)))];% peak with highest amplitude
            B = [P1lat(find(P1amp==min(P1amp)));P1amp(find(P1amp==min(P1amp)))];
            cath1 =10*( A(2)-B(2));cath2 = (max(A(1),B(1))-min(A(1),B(1)));
            hyp = sqrt(cath1^2 + cath2^2);
            C =double([(min(A(1),B(1)) + hyp/2),A(2)+1.75]); % C is 1(lowest latency + half the distance to the other lateny) 2(highest amplitude + 2)
            text (C(1),C(2),'P1','FontSize',10,'Color',[0.4 0.4 0.4]);
            %%%%%
             A = [P2lat(find(P2amp==max(P2amp)));P2amp(find(P2amp==max(P2amp)))];
             B = [P2lat(find(P2amp==min(P2amp)));P2amp(find(P2amp==min(P2amp)))];
            cath1 =10*( A(2)-B(2));cath2 = (max(A(1),B(1))-min(A(1),B(1)));
            hyp = sqrt(cath1^2 + cath2^2);
            C = double([(min(A(1),B(1)) + hyp/2),A(2)+1.75]);
            text (C(1),C(2),'P2','FontSize',10,'Color',[0.4 0.4 0.4]);
               %%%%%
            A = [N1lat(find(N1amp==max(N1amp)));N1amp(find(N1amp==max(N1amp)))];
            B = [N1lat(find(N1amp==min(N1amp)));N1amp(find(N1amp==min(N1amp)))];
            cath1 =10*( A(2)-B(2));cath2 = (max(A(1),B(1))-min(A(1),B(1)));
            hyp = sqrt(cath1^2 + cath2^2);
            C = double([(min(A(1),B(1)) + hyp/2),A(2)+1.75]);
            text (C(1),-C(2),'N1','FontSize',10,'Color',[0.4 0.4 0.4]);
            
  %% make box without ticks
         L0 = line(xlims,[0 0],'Color', 'k','LineWidth',.1,'LineStyle',':');
        % change  font size of labels and ticks
        set(get(gca,'XLabel'),'FontSize',12);
        set(get(gca,'YLabel'),'FontSize',12);
        set(gca,'FontSize', 10); % to change general size (tick labels)
        set(gcf,'Color',[1 1 1] )  % white background
     end
     end 
    
%% Save to file in Output Dir 
if withsig == 1
         figGroupName = [figGroupName,'_Sig_'];
end
 nsubjects = length(group_SS);
figurename = [figGroupName,num2str(nsubjects),'ss','-',cell2mat(chanlabels(k))];
set(gcf,'Name',figurename);
cd (DIROUTPUT)
%   saveas (gcf,figurename, 'fig');
%   saveas (gcf,figurename, 'tiff')

set(gcf, 'Position', get(0,'Screensize')); 
 export_fig (sprintf([(figurename)]), '-tiff', '-cmyk', '-r300')    
close gcf
end 




 