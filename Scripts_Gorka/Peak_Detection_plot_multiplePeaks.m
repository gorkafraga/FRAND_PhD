%%%%%PEAK DETECTION
%================================================================
% PEAKS : P1 and N1 (N200)
% P1 time range (Maurer GFP based:  55 -163 ms after stimulus onset)
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
% Define directories
clear all
close all

DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection';

%--------------------------------------------------------------------------
%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
% -------------------------------------------------------------------------

   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)', 'Define channels of interest(COI)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??','20:31,53,57:64'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
   COI=cell2mat(answer(3));COI = str2num(COI);
 
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
    
%%% ========= Create  arrays with channel labels and conditions as columns
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
%--------------------------------------------------------------------------
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

 if ~isempty(dir(FILENAME1))
 % prepare arrays row names
 sIndex = find (N==n);%give index of n in N, that is the subject index within all taken subjects
     
 % subject number in first column 
 N1Latencies(1+sIndex,1) = {FILENAME1(2:4)};
 N1Amplitudes(1+sIndex,1) = {FILENAME1(2:4)};
  % subject number in first column 
 P1Latencies(1+sIndex,1) = {FILENAME1(2:4)};
 P1Amplitudes(1+sIndex,1) = {FILENAME1(2:4)};

 cd (DIRNAME)
 %% compute averages of all trials per electrode and data point
 
  % load file in EEGlab 
  [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
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

%% P1 component: search range 55-163 ms
%------------------------------
    for k = COI(1:end); % loop through ch of interest
%         k = 1:64;
        for i = 1:length(time);
            if time(1,i) >   50.000 && time(1,i)< 55.000; 
                s1 = i;  % starter of range
            elseif time(1,i) > 160.000 && time(1,i)< 165.000;
                e1 = i; % end of range
            end
        end
    % Search for peaks
    % Find local positive peaks 
            [pks,locs] = findpeaks(AvgEl(k,s1:e1),'minpeakheight',0);
            locs=locs+s1;
            timelocs=time(1,locs);
            P1peaks{k,1} = pks;
            P1peaks{k,2} = timelocs;
            P1peaks{k,3} = locs;
            % Find maximum positive peaks 
       if ~isempty(pks);
            [Ps,ind]=sort(pks,'descend');
            L=locs(ind);
            T=timelocs(ind);
            for j =1:length(Ps)
                if AvgEl(k,L(1,j)-1)<= Ps(1,j)&& AvgEl(k,L(1,j)+1)< Ps(1,j)
                    P1Amp = Ps(1,j);
                    P1time =T(1,j);
                    P1locs =L(1,j);
                    break
                else
                    continue
                end
            end
     
            P1{k,1}=P1Amp;
            P1{k,2}=P1time;
            P1{k,3}=P1locs;                            
     
         AmplitudesP1 = P1(:,1);
         AmplitudesP1 = AmplitudesP1';
         LatenciesP1 = P1(:,2);    
         LatenciesP1 = LatenciesP1';
        
       else
            P1{k,1}=P1peaks{k,1};
            P1{k,2}=P1peaks{k,2};
            P1{k,3}=P1peaks{k,3}; 
         
         AmplitudesP1 = P1(:,1);
         AmplitudesP1 = AmplitudesP1';
         LatenciesP1 = P1(:,2);    
         LatenciesP1 = LatenciesP1';
       end
    end
    
    % Substitute blankcells(no peak detected) by 0 in Amplitudes/Latencies
    %arrays so we can see it in the cell array (see which channels have a
    %zero peak)
        x = AmplitudesP1(COI);
        emptycells = cellfun(@isempty,x);
        x(emptycells) = {0};
    AmplitudesP1(COI) = x;
        y = LatenciesP1(COI);
        emptycells = cellfun(@isempty,y);
        y(emptycells) = {0};
    LatenciesP1(COI) = y;

%-----------------------------------
%%  N1 component: search range 175 to 300 ms 
%----------------------------------
    for k = COI(1:end);
%         k = 1:64;
        for i = 1:length(time);
            if time(1,i) >  170.000 && time(1,i)< 175.000; 
                s1 = i;  % starter of range
            elseif time(1,i) > 295.000 && time(1,i)< 300.000;
                e1 = i; % end of range
            end
        end
    % Search for peaks
    % Find local negative peaks between 140 & 280 ms
            [pks,locs] = findpeaks(-AvgEl(k,s1:e1),'minpeakheight',0);
            locs=locs+s1;
            timelocs=time(1,locs);
            N1peaks{k,1} = -pks;
            N1peaks{k,2} = timelocs;
            N1peaks{k,3} = locs;
            % Find maximum negative peaks between 140 & 280 ms
          if ~isempty(pks);
            [Ps,ind]=sort(pks,'descend');
            L=locs(ind);
            T=timelocs(ind);
            for j =1:length(Ps)
                if AvgEl(k,L(1,j)-1)< Ps(1,j)&& AvgEl(k,L(1,j)+1)< Ps(1,j)
                    N1Amp=-Ps(1,j);
                    N1time=T(1,j);
                    N1locs=L(1,j);
                    break
                else
                    continue
                end
            end
            
            N1{k,1}=N1Amp;
            N1{k,2}=N1time;
            N1{k,3}=N1locs;                            
         AmplitudesN1 = N1(:,1);
         AmplitudesN1 = AmplitudesN1';
         LatenciesN1 = N1(:,2);    
         LatenciesN1 = LatenciesN1';
        
       else
            N1{k,1}=N1peaks{k,1};
            N1{k,2}=N1peaks{k,2};
            N1{k,3}=N1peaks{k,3}; 
         
         AmplitudesN1 = N1(:,1);
         AmplitudesN1 = AmplitudesN1';
         LatenciesN1 = N1(:,2);    
         LatenciesN1 = LatenciesN1';
       end
    end
    
    
     % Substitute blankcells(no peak detected) by 0 in Amplitudes/Latencies 
    %arrays so we can see it in the cell array (see which channels have a
    %zero peak)
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
             N1Latencies(1+sIndex,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+sIndex,cols) =  AmplitudesN1(COI);
             P1Latencies(1+sIndex,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+sIndex,cols) =  AmplitudesP1(COI);
       end  
     elseif ~isempty(strfind(FILENAME1,'e22'))
         condition = 'LongWords';
         for l = 1:length(COI);
             cols = 2+length(COI):1+2*length(COI); %start column 
             N1Latencies(1+sIndex,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+sIndex,cols) =  AmplitudesN1(COI);
             P1Latencies(1+sIndex,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+sIndex,cols) =  AmplitudesP1(COI);
         end
     elseif ~isempty(strfind(FILENAME1,'e23'))
         condition = 'ShortSymbols';
         for l = 1:length(COI);
             cols = 2+2*length(COI):1+3*length(COI);
             N1Latencies(1+sIndex,cols) =  LatenciesN1(COI);
             N1Amplitudes(1+sIndex,cols) =  AmplitudesN1(COI);
             P1Latencies(1+sIndex,cols) =  LatenciesP1(COI);
             P1Amplitudes(1+sIndex,cols) =  AmplitudesP1(COI);
         end                             
     elseif ~isempty(strfind(FILENAME1,'e24'))
         condition = 'LongSymbols';
         for l = 1:length(COI);
             cols = 2+3*length(COI):1+4*length(COI);
             N1Latencies(1+sIndex,cols)=  LatenciesN1(COI);
             N1Amplitudes(1+sIndex,cols) =  AmplitudesN1(COI);
             P1Latencies(1+sIndex,cols)=  LatenciesP1(COI);
             P1Amplitudes(1+sIndex,cols) =  AmplitudesP1(COI);
         end
         
   end
     
    
       clear pks pks1 locs locs1
            
 % save to file with name   
    suffixAmp = ['-',num2str(length(COI)),'ch','-N1Amp'];
    suffixLat = ['-',num2str(length(COI)),'ch','-N1Lat'];
    suffix =  ['-',num2str(length(COI)),'ch','-N1'];
    suffixAmp2 = ['-',num2str(length(COI)),'ch','-P1Amp'];
    suffixLat2 = ['-',num2str(length(COI)),'ch','-P1Lat'];
    suffix2 =  ['-',num2str(length(COI)),'ch','-P1'];

    cd (DIROUTPUT);
    xlswrite ([TABLENAME suffixAmp], N1Amplitudes);
    xlswrite ([TABLENAME suffixLat], N1Latencies);
    xlswrite ([TABLENAME suffixAmp2], P1Amplitudes);
    xlswrite ([TABLENAME suffixLat2], P1Latencies);

%save also as matlab file
  save([TABLENAME suffix],'N1peaks')
  save([TABLENAME suffix2],'P1peaks')
 
  %% PLOTS:  average response per subject and condition (& mark peaks)
 %------------------------------------------------------------------------
 
 %Define the ticks for the axes in the plots that will be set later
    XTick = [-500:100:1500] ;
    rmv = [1:21]; 
    rmv([2,4,6,8,10,12,14,16,18,20]) = []; 
    XTickLabel = num2cell(XTick);
    XTickLabel(rmv) = {''};    
    
    %Individual plots for each of the channels of interest
    
   for k = COI(1:end);
       %Peaks in Channels of Interest
        %get peak N1 Y and X values for the plot
        XN1 = N1(k,2);% take Latency value(col2) of N1 in channel k
        YN1 = N1(k,1); % take Amplitude value (col1) of N1 in channel k 
        %get peak P1 Y and X values for the plot
        XP1 = P1(k,2);% take Latency value(col2) of N1 in channel k
        YP1 = P1(k,1); % take Amplitude value (col1) of N1 in channel k 
        % Plot data of channel k
        X = time ;
        Y = AvgEl(k,:);
        figure;
        plot(X,Y)
        %set the parameter
         %Title of the plot 
        PLOTNAME = [FILENAME1(1:4),TABLENAME,'-',condition,'-',cell2mat(labels(k))];
         % set ticks and axes 
        set(gca,'YLim', [-50 50],'XLim',[-500, 1500],'XTick',XTick, 'XTickLabel',XTickLabel); 
        set(gca,'Title',text('String',PLOTNAME,'Color','k'),'Position',[0.13 0.11 0.775 0.815]);
        set(get(gca,'XLabel'),'String','time');
        set(get(gca,'YLabel'),'String','response index');
        line([0 ; 0],[-50 50], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
        line([-500 ; 1500],[0 0], 'linewidth',1,'LineStyle', '-','color', 'k');hold on; 
        scatter (cell2mat(XN1), cell2mat(YN1),'filled','marker', 'x','markeredgecolor','k','markerfacecolor','k');hold on;
        scatter (cell2mat(XP1), cell2mat(YP1),'filled','marker', '+','markeredgecolor','k','markerfacecolor','k');hold on;
        line([200;200],[-50;50], 'linewidth',1,'LineStyle', ':','color', 'k');hold off; 
        
 % Save in new folder with subject name within the OUTPUT parent directory
        newfolder = [FILENAME1(1:4),'_plots'];
        newdir = [DIROUTPUT,'\',FILENAME1(1:4),'_plots'];
        mkdir(DIROUTPUT,newfolder);
        cd (newdir)
        saveas (gcf,PLOTNAME, 'fig');
        saveas (gcf,PLOTNAME, 'tiff');
        close (gcf);
        cd (DIROUTPUT);
   end
 
      
 
cd (DIRNAME);

else 
        fprintf('File %s not found\n',FILENAME1);
  end
end
end
end





