%%%%%PEAK DETECTION
%================================================================
% PEAKS : P1 and N1 (N200)
% P1 time range (Maurer GFP based:  55 -163 ms after stimulus onset)
                % Currently used: 50 - 180 ms
% N1 time range (Maurer GFP based:  164 - 273 ms after stimulus onset)
                % currently used: 175 - 300 ms
%-----------------------------------------------------------------------
% Electrode subset is user defined in popup
% Save the avg amplitude of each electrodes in an excel sheet that can be
% exported to SPSS. 
% Output format: subjects as rows. As columns: 
%(channels / condition) x 2 (latencies and amplitudes)

% Channels of interest indexes:
%------------------------------------------------------------
%Big subset including all tp, cp, o,p and PO: [16:32,56:64]
% Parieto/Occipital channels: P9,PO7,PO3,POz, PO4,PO8,P10,P7, P8,Iz
% channel codes:  24, 25,26,30,63,62,61,60,23,28
%Temporal Channels: TP8, TP7. Indexes: 16,53
% Temporal channel codes: 16,53
% Occipital channels: O1,Oz,O2 channel indexes: 27, 29, 64
% All except frontal ones:  12:32,48:64 
%--------------------------------------------------------------------------
% Define directory and Time range around the peak for mean amplitude
clear all
close all
eeglab
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection';
%%%%--------------------------------------------------------------------------
  range = 25;
  int=1;
%--------------------------------------------------------------------------
%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
% -------------------------------------------------------------------------

   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)', 'Define channels of interest(COI)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??','16,22:30,53,59:64'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
   COI=cell2mat(answer(3));COI = str2num(COI);
 
%% Define group
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
       DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';
       TABLENAME = 'Pretest_LEXI';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school';
        TABLENAME = 'Pretest_school';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age';
        TABLENAME = 'Ctrl_age';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia';  
        TABLENAME = 'Ctrl_dyslexia';
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI';
        TABLENAME = 'Post_LEXI';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school';
        TABLENAME = 'Post_school';
                
    end
    cd (DIRNAME);
    
%%  ========= Create  arrays with channel labels and conditions as columns
    N1Latencies = cell(1,1+length(COI)*4);
    N1Amplitudes = cell(1,1+length(COI)*4);
    P1Latencies = cell(1,1+length(COI)*4);
    P1Amplitudes = cell(1,1+length(COI)*4);
%%% label of columns: Channel name ending depending on condition
%%% (SW,LW,SS,LS) and value of peak(latency or amplitude)
    labels = textread('Z:\fraga\EEG_Gorka\Analysis_EEGlab11\ChannelLabels.txt', '%s','delimiter', '\t');
    
    for l = 1:length(COI);
        C = labels(COI(l));
         N1Latencies(1,1+l) = {[cell2mat(C),'-SW-L']};
         N1Amplitudes(1,1+l) = {[cell2mat(C),'-SW-A']};
         P1Latencies(1,1+l) = {[cell2mat(C),'-SW-L']};
         P1Amplitudes(1,1+l) = {[cell2mat(C),'-SW-A']};
    end
    for l = 1:length(COI)
        C = labels(COI(l));
       N1Latencies (1,(1+length(COI))+l) = {[cell2mat(C),'-LW-L']};
       N1Amplitudes(1,(1+length(COI))+l) = {[cell2mat(C),'-LW-A']};
       P1Latencies (1,(1+length(COI))+l) = {[cell2mat(C),'-LW-L']};
       P1Amplitudes(1,(1+length(COI))+l) = {[cell2mat(C),'-LW-A']};
    end
    for l = 1:length(COI)
        C = labels(COI(l));
        N1Latencies(1,(1+2*length(COI))+l) = {[cell2mat(C),'-SS-L']};
        N1Amplitudes(1,(1+2*length(COI))+l) = {[cell2mat(C),'-SS-A']};
        P1Latencies(1,(1+2*length(COI))+l) = {[cell2mat(C),'-SS-L']};
        P1Amplitudes(1,(1+2*length(COI))+l) = {[cell2mat(C),'-SS-A']};

    end
    for l = 1:length(COI)
        C = labels(COI(l));
        N1Latencies(1,(1+3*length(COI))+l) = {[cell2mat(C),'-LS-L']};
        N1Amplitudes(1,(1+3*length(COI))+l)= {[cell2mat(C),'-LS-A']};
        P1Latencies(1,(1+3*length(COI))+l) = {[cell2mat(C),'-LS-L']};
        P1Amplitudes(1,(1+3*length(COI))+l)= {[cell2mat(C),'-LS-A']};

    end
 

%% Loop through files with separated events (conditions)
%[contains all that follows:]
%--------------------------------------------------------------------------

for n = N; 
  if n < 10
     [FILES] =['s',num2str(G),'0',num2str(n),'*e2*.set'];
    elseif n >=10 && n<100   
    [FILES] =['s',num2str(G),num2str(n),'*e2*.set'];
  end
% FILES = [FILES '*e2*.set'];
FILES1 = [dir(FILES)]; %Search in current Dir files 

for  J = 1:length(FILES1); %J contains the list of the files containing'
  FILENAME1 = [FILES1(J).name]; %Use the dimension name of each element of the list J as filename
%defineCondition
     if ~isempty(strfind(FILENAME1,'e21'))
            condition = 'ShortWords';
        elseif ~isempty(strfind(FILENAME1,'e22'))
            condition = 'LongWords';
        elseif ~isempty(strfind(FILENAME1,'e23'))
            condition = 'ShortSymbols';
        elseif ~isempty(strfind(FILENAME1,'e24'))  
            condition = 'LongSymbols';
     end
    
 if ~isempty(dir(FILENAME1))
        
     
     
  % prepare arrays row names
 sIndex = find (N==n);%give index of n in N, that is the subject index within all taken subjects
     
 % subject number in first column 
 N1Latencies(1+n,1) = {FILENAME1(2:4)};
 N1Amplitudes(1+n,1) = {FILENAME1(2:4)};
  % subject number in first column 
 P1Latencies(1+n,1) = {FILENAME1(2:4)};
 P1Amplitudes(1+n,1) = {FILENAME1(2:4)};

 cd (DIRNAME)
 %% compute averages of all trials per electrode and data point
 
  % load file in EEGlab 
 EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

 eeglab redraw
    % Take the information on electrodes and timepoints from current EEG
        % dataset
        Electrodes=EEG.data(1:64,:,:);
        time=EEG.times;
        X=zeros(64,EEG.trials);% X=zeros(1:64,EEG.trials)gives "warning input must be scalars"
       AvgEl=zeros(64,EEG.pnts,1);%AvgEl=zeros(1:64,EEG.pnts,1)gives "warning input must be scalars"
   
% Go through eleectordes
        for k =1:64
            % Go through the sampling points per epoch
            for i=1:(EEG.pnts)
                % Go through epochs
                for j=1:(EEG.trials)
                   % For an electrode k, make a vector X with the point i for all
                   % the epochs
                   X(k,j)=Electrodes(k,i,j);     
                end
                                
                % Get an average value for the point i from all the epochs
                Y(k,1)=sum(X(k,:))/EEG.trials;

                % Makes a matrix with average values for all electrodes
                AvgEl(k,i,1) = Y(k,1);
            end
        end
       
   % stimulus onset data point number: 
     Sonset = find(EEG.times==0);
%     % number of data points specified are taken prior to stimulus onset
%     points = Sonset-DP;     
%     points = points: Sonset;

%% ====================================peak detection!========================= 


  for k = COI(1:end); % loop through ch of interest

 
        %  Define starter and ending of peak 
        for i = 1:length(time); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% P1
            if time(1,i) >   50.000 && time(1,i)< 55.000; 
                s1 = i;  % starter of range
            elseif time(1,i) > 175.000 && time(1,i)< 180.000;
                e1 = i; % end of range
            end
        end
         for i = 1:length(time);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% N1
            if time(1,i) >  170.000 && time(1,i)< 175.000; 
                s11 = i;  % starter of range
            elseif time(1,i) > 295.000 && time(1,i)< 300.000;
                e11 = i; % end of range
            end
        end
   
         
         
    %% MANUAL DETECTION AND CHECK OF PEAKS!
   % ------------------------------------------------------------
   %==== calculate peak to be checked 
    %First peak P1
            signal=AvgEl(k,:);
            signal_analysis=signal(s1:e1);
            peak_amplitude=max(signal_analysis);
            peak_latency_ind=min(find(signal_analysis==peak_amplitude)+s1);
            peak_latency=time(peak_latency_ind);
            [mm1,windst_ind]=min(abs(time-(peak_latency-range)));
            [mm2,winden_ind]=min(abs(time-(peak_latency+range)));
            avg_amplitude=sum(AvgEl(k,windst_ind:winden_ind))/((winden_ind) - (windst_ind) +1);
               
     
      %Second peak N1
            signal2=-AvgEl(k,:);
            signal_analysis2=signal2(s11:e11);
            peak_amplitude2=max(signal_analysis2);
            peak_latency_ind2=min(find(signal_analysis2==peak_amplitude2)+s11);
            peak_latency2=time(peak_latency_ind2);
            [mm11,windst_ind2]=min(abs(time-(peak_latency2-range)));
            [mm22,winden_ind2]=min(abs(time-(peak_latency2+range)));
            avg_amplitude2=sum(AvgEl(k,windst_ind2:winden_ind2))/((winden_ind2) - (windst_ind2) +1);
        % =========plot the peak
                

        %====  ask about peak   
            if int==1
            p = questdlg('peaks ok?');  
                if strcmp(p,'Cancel'); 
                    % Save image in new folder with subject name within the OUTPUT parent directory
                    newfolder = [FILENAME1(1:4),'_plots'];
                    newdir = [DIROUTPUT,'\',FILENAME1(1:4),'_plots'];
                    mkdir(DIROUTPUT,newfolder);
                    cd (newdir)
                    saveas (2,PLOTNAME, 'fig');
                    saveas (2,PLOTNAME, 'tiff');
                    close (2);
                    cd (DIROUTPUT);
                  continue
                end
            while  strcmp(p,'No')==1;
                
         %===== give latency manually if it is wrong 
               message = ['Current P1 latency is',' ', num2str(peak_latency),'.', 'What is the new latency?'];
               message2 = ['Current N1 latency is',' ', num2str(peak_latency2),'.', 'What is the new latency?'];
               prompt={message, message2};
               name='New latencies';
               numlines=1;
               defaultanswer = {'?','?'};
               options.Resize='on';
               options.WindowStyle='modal';
               answer=inputdlg(prompt,name,numlines,defaultanswer,options);
               temp =cell2mat(answer(1));temp = str2double(temp);
               temp2 =cell2mat(answer(2));temp2 = str2double(temp2);
         %==== recalculate the peak with the new latency      
               [mm,peak_latency_ind]=min(abs(time-temp));
               [mm1,windst_ind]=min(abs(time-(temp-range)));
               [mm2,winden_ind]=min(abs(time-(temp+range)));
                peak_latency=time(peak_latency_ind);
                peak_amplitude=signal(peak_latency_ind);
                %avg_amplitude=sum(signal_analysis(windst_ind-s1:winden_ind-s1))/((winden_ind-s1)-(windst_ind-s1)+1);
                
                [mmm,peak_latency_ind2]=min(abs(time-temp2));
                [mm11,windst_ind2]=min(abs(time-(temp2-range)));
                [mm22,winden_ind2]=min(abs(time-(temp2+range)));
                peak_latency2=time(peak_latency_ind2);
                peak_amplitude2=signal2(peak_latency_ind2);
                %avg_amplitude2=sum(signal_analysis2(windst_ind2-s11:winden_ind2-s11))/((winden_ind2-s11)-(windst_ind2-s11)+1);
               
        %===== plot again        
            g = figure(2);
            plot(X,Y)
            XTick = [-500:100:1500] ;
            rmv = [1:21]; 
            rmv([2,4,6,8,10,12,14,16,18,20]) = []; 
            XTickLabel = num2cell(XTick);
            XTickLabel(rmv) = {''};
            set(g,'units','normalized','outerposition',[0 0 1 1])
            PLOTNAME = [FILENAME1(1:4),TABLENAME,'-',condition,'-',cell2mat(labels(k))];
             % set ticks and axes 
            set(gca,'YLim', [-50 50],'XLim',[-500, 1500],'XTick',XTick, 'XTickLabel',XTickLabel); 
            set(gca,'Title',text('String',PLOTNAME,'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
            set(get(gca,'XLabel'),'String','time');
            set(get(gca,'YLabel'),'String','response index');
            line([0 ; 0],[-50 50], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
            line([-500 ; 1500],[0 0], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
            scatter (peak_latency, peak_amplitude,'filled','marker', '+','markeredgecolor','k','markerfacecolor','k');hold on;
            scatter (peak_latency2, -peak_amplitude2,'filled','marker', 'x','markeredgecolor','k','markerfacecolor','k');hold on;
            line([200;200],[-50;50], 'linewidth',1,'LineStyle', ':','color', 'k');hold off;   
            p = questdlg('peaks ok?');
            end
            end
           % If it is OK:
           % Save image in new folder with subject name within the OUTPUT parent directory
            newfolder = [FILENAME1(1:4),'_plots'];
            newdir = [DIROUTPUT,'\',FILENAME1(1:4),'_plots'];
            mkdir(DIROUTPUT,newfolder);
            cd (newdir)
            saveas (gcf,PLOTNAME, 'fig');
            saveas (gcf,PLOTNAME, 'tiff');
            close (gcf);
            cd (DIROUTPUT);
          % save latency and amplitude    
            P1{k,1} = peak_latency;
            P1{k,2} = peak_amplitude;
            P1{k,3} = avg_amplitude;
             LatenciesP1 = P1(:,1);
             LatenciesP1 = LatenciesP1';
             AmplitudesP1 = P1(:,2);    
             AmplitudesP1 = AmplitudesP1';
          
            N1{k,1} = peak_latency2;
            N1{k,2} = -peak_amplitude2;
            N1{k,3} = avg_amplitude2;
             LatenciesN1 = N1(:,1);    
             LatenciesN1 = LatenciesN1';
             AmplitudesN1 = N1(:,2);
             AmplitudesN1 = AmplitudesN1';
            end
   
    
    % Substitute blankcells(no peak detected) by 0 in Amplitudes/Latencies
   % (see which channels have a
   
        x = AmplitudesP1(COI);
        emptycells = cellfun(@isempty,x);
        x(emptycells) = {0};
    AmplitudesP1(COI) = x;
        y = LatenciesP1(COI);
        emptycells = cellfun(@isempty,y);
        y(emptycells) = {0};
    LatenciesP1(COI) = y;
    
        xx = AmplitudesN1(COI);
        emptycells = cellfun(@isempty,xx);
        xx(emptycells) = {0};
    AmplitudesN1(COI) = xx;
        yy = LatenciesN1(COI);
        emptycells = cellfun(@isempty,yy);
        yy(emptycells) = {0};
    LatenciesN1(COI) = yy;
    
    
    
%% now save peaks Amplitudes & Latencies in the corresponding columns
  
   % write if per condition in consecutive blocks of columns       
   if ~isempty(strfind(FILENAME1,'e21'))
        condition = 'ShortWords';
       for l = 1:length(COI);
             cols = 2:length(COI)+1;
             N1Latencies(1+n,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+n,cols) =  AmplitudesN1(COI);
             P1Latencies(1+n,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+n,cols) =  AmplitudesP1(COI);
       end  
     elseif ~isempty(strfind(FILENAME1,'e22'))
         condition = 'LongWords';
         for l = 1:length(COI);
             cols = 2+length(COI):1+2*length(COI); %start column 
             N1Latencies(1+n,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+n,cols) =  AmplitudesN1(COI);
             P1Latencies(1+n,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+n,cols) =  AmplitudesP1(COI);
         end
     elseif ~isempty(strfind(FILENAME1,'e23'))
         condition = 'ShortSymbols';
         for l = 1:length(COI);
             cols = 2+2*length(COI):1+3*length(COI);
             N1Latencies(1+n,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+n,cols) =  AmplitudesN1(COI);
             P1Latencies(1+n,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+n,cols) =  AmplitudesP1(COI);
         end                             
     elseif ~isempty(strfind(FILENAME1,'e24'))
         condition = 'LongSymbols';
         for l = 1:length(COI);
             cols = 2+3*length(COI):1+4*length(COI);
             N1Latencies(1+n,cols)=  LatenciesN1(COI);
             N1Amplitudes(1+n,cols) =  AmplitudesN1(COI);
             P1Latencies(1+n,cols)=  LatenciesP1(COI);
             P1Amplitudes(1+n,cols) =  AmplitudesP1(COI);
         end
         
   end
     
    
            
 % save to file with name   
    suffixAmp = ['-',num2str(length(COI)),'ch','-P1Amp'];
    suffixLat = ['-',num2str(length(COI)),'ch','-P1Lat'];
    suffix =  ['-',num2str(length(COI)),'ch','-P1'];
    suffixAmp2 = ['-',num2str(length(COI)),'ch','-N1Amp'];
    suffixLat2 = ['-',num2str(length(COI)),'ch','-N1Lat'];
    suffix2 =  ['-',num2str(length(COI)),'ch','-N1'];
% Write in excel. To avoid overwriting when adding new subjects info to a
% already created file. Save headers in first row and then subject info in
% corresponding row
    cd (DIROUTPUT);
    rng = sprintf('A%i', n+1);%select row according to number of subject(n)
    head = sprintf('A%i',1);
    arrays = {'P1Amplitudes','P1Latencies','N1Amplitudes', 'N1Latencies'};
    suffixes = { 'suffixAmp', 'suffixLat', 'suffixAmp2', 'suffixLat2'}; 
    
    for o = 1:length(arrays);
       array = eval(cell2mat(arrays(o)));
       header =  array(1,:);
       suf = eval(cell2mat(suffixes(o)));
       data = array(2:end,:); 
       index = ~cellfun('isempty',data(:,1));
       blanks = find(index==0);
       data(blanks,:)=[];
%        for r = 1:length(index);
%             if index(r)==0
%             data(r,:)=[];
%              else
%             end
%             index = ~cellfun('isempty',data(:,1));
%         end
        
      xlswrite ([TABLENAME suf], header,'Sheet1',head);
      xlswrite ([TABLENAME suf], data,'Sheet1',rng);
%       xlsarray = xlsread ([TABLENAME suf,'.xls']);
%       noduplicate = unique(xlsarray,'rows');
%       secondrow = sprintf('A%i', 2);
%       xlswrite ([TABLENAME suf], noduplicate,'Sheet1','A2');%rewrite sheet
    
        %save also as matlab file
      save([TABLENAME suffix],'data');
      save([TABLENAME suffix2],'data');   
   
  
    end
   



 
      
 
cd (DIRNAME);

else 
        fprintf('File %s not found\n',FILENAME1);
  end
end
end
end





