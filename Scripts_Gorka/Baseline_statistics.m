%%%%%%% BASELINE COMPARISON: 
% Obtain amplitudes of the individual baselines using some data points before 
% stimulus onset.
% Number of Data Points and Electrode subset are user defined in popup
% window when running the script.
% Save the avg amplitude of those points and electrodes in an excel sheet that can be
% exported to SPSS. 
% Output format: subjects as rows. As columns: channels / condition
% (words/symbols)

%%%%%COI (channel of interest) subset for VWR: 
% Parieto/Occipital channels: P9,PO7,PO3,POz, PO4,PO8,P10
% channel codes:  24, 25,26,30,63,62,61
% Occipital channels: O1,Oz,O2
% channel codes: 27, 29, 64
clear all
close all
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% ------------------------Define directories
DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Baseline Comparison';
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Baseline Comparison\Baseline_stats';
cd (DIRNAME);
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)','Define Electrode subset(codes)', 'Define n data points to use'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??','24, 25,26,30,63,62,61', '5'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
   COI=cell2mat(answer(3));COI = str2num(COI);
   DP=cell2mat(answer(4));DP = str2num(DP);


%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
        TABLENAME = 'Pretest_dyslexia';
        elseif G == 1
        TABLENAME = 'Pretest_school';
        elseif G == 2
        TABLENAME = 'Ctrl_school';
        elseif G == 3
         TABLENAME = 'Ctrl_dyslexia';
        elseif G == 4
        TABLENAME = 'Post_dyslexia';
        elseif G == 5
        TABLENAME = 'Post_school';
    end
    
%%% ========= Create  array with channel labels and conditions as columns
stats = cell (1,1+length(COI)*4);

%%% label of columns: COI + ending depending on condition (SW,LW,SS,LS) 
    for l = 1:length(COI)
        labels = textread('Z:\fraga\EEG_Gorka\Analysis_EEGlab\ChannelLabels.txt', '%s','delimiter', '\t');
        C = labels(COI(l));
        stats(1,1+l) = {[cell2mat(C),'-SW']};
    end
    for l = 1:length(COI)
        labels = textread('Z:\fraga\EEG_Gorka\Analysis_EEGlab\ChannelLabels.txt', '%s','delimiter', '\t');
        C = labels(COI(l));
        stats(1,(1+length(COI))+l) = {[cell2mat(C),'-LW']};
    end
    for l = 1:length(COI)
        labels = textread('Z:\fraga\EEG_Gorka\Analysis_EEGlab\ChannelLabels.txt', '%s','delimiter', '\t');
        C = labels(COI(l));
        stats(1,(1+2*length(COI))+l) = {[cell2mat(C),'-SS']};
    end
    for l = 1:length(COI)
        labels = textread('Z:\fraga\EEG_Gorka\Analysis_EEGlab\ChannelLabels.txt', '%s','delimiter', '\t');
        C = labels(COI(l));
        stats(1,(1+3*length(COI))+l) = {[cell2mat(C),'-LS']};
    end

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
cd (DIRNAME)
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
     sIndex = find (N==n);%give index of n in N, that is the subject index within all taken subjects
    % number of data points specified are taken prior to stimulus onset
    points = Sonset-DP;     
    points = points: Sonset;
   % subject number in first column 
    stats(1+sIndex,1) = {FILENAME1(1:4)};
  % now save channels averages in the corresponding columns
     if ~isempty(strfind(FILENAME1,'e21'))
        for l = 1:length(COI);
          stats( 1+ sIndex,1+l)  = {mean(AvgEl(COI(l),points))};
         end
         
     elseif ~isempty(strfind(FILENAME1,'e22'))
         for l = 1:length(COI);
           stats( 1+ sIndex,(1+length(COI))+l)  = {mean(AvgEl(COI(l),points))};
         end
                
     elseif ~isempty(strfind(FILENAME1,'e23'))
         for l = 1:length(COI);
           stats( 1+ sIndex,(1+2*length(COI))+l)  = {mean(AvgEl(COI(l),points))};
         end
                             
     elseif ~isempty(strfind(FILENAME1,'e24'))
         for l = 1:length(COI);
           stats( 1+ sIndex,(1+3*length(COI))+l)  = {mean(AvgEl(COI(l),points))};
         end
         
     end
    
    suffix = ['-',num2str(length(COI)),'ch',num2str(DP),'points'];
   
cd (DIROUTPUT);
xlswrite ([TABLENAME suffix], stats);
cd (DIRNAME)
else 
        fprintf('File %s not found\n',FILENAME1);
  end
end
end
end

