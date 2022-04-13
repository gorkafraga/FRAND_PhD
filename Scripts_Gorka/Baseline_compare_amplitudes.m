%%%%%%% COMPARE BASELINE EEG

clear all
close all
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
%PLOT GRAND AVERAGES: 
    %Input= group and subjects to include.
    % If subject is not found in folder it continues with the next 
    % Output = plots with words versus symbols differences: 
           % Formats: fig and Tiff
           % One version with significance and one without
%--------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject number N (1 to 22)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
   
   
% ------------------------
DIRNAME = 'C:\Users\Gorka\Desktop\Averages';
DIROUTPUT = 'C:\Users\Gorka\Desktop\baseline_stats';
cd (DIRNAME);
%--------------------------------------------------------------------------
for G = G; 
    if          G == 0 
        FIGURENAME = 'Pretest_dyslexia';
        elseif G == 1
        FIGURENAME = 'Pretest_school';
        elseif G == 2
        FIGURENAME = 'Ctrl_school';
        elseif G == 3
         FIGURENAME = 'Ctrl_dyslexia';
        elseif G == 4
        FIGURENAME = 'Post_dyslexia';
        elseif G == 5
        FIGURENAME = 'Post_school';
    end

for N = N; 
  if N < 10
     [FILES] =['s',num2str(G),'0',num2str(N),'*e2*.set'];
    elseif N >=10 && N<100   
    [FILES] =['s',num2str(G),num2str(N),'*e2*.set'];
  end
%   
% FILES = [FILES '*e2*.set'];
FILES1 = [dir(FILES)]; %Search in current Dir files 

for  J = 1:length(FILES1); %J contains the list of the files containing'
  FILENAME1 = [FILES1(J).name]; %Use the dimension name of each element of the list J as filename

 EEG = pop_loadset('filename',FILENAME1);
 [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw

end
 end


%Plot average of words (addavg) substract average of symbols(subavg)
%Insert the number of the corresponding dataset
all = size(ALLEEG); 
all = [1:all(2)];
%Index of the open datasets corresponding to conditions words/symbols(short&long)
    SW = all(1:4:length(all));
    LW = all(2:4:length(all));
    SS = all(3:4:length(all));
    LS = all(4:4:length(all));
%Sum both words conditions and substract both symbol conditions
 datadd = [SW , LW]; 
 datsub = [SS, LS];
%TITLE for the plot including the number of subjects used (as spec in N)
%Count actual number of subjects
    nsubj = size(all);
    nsubj = [nsubj(2)/4];
    nsubj = num2str(nsubj);
 %Include in Title info about group(FIGURENAME) & nSubjects
    TITLE = [FIGURENAME '-' nsubj 'subjects-nosig'];

    
%%%%%%%%%%%%%%%%%%%% 

[erp1 erp2 erpsub time sig] = pop_comperp( ALLEEG, 1, datadd ,datsub ,'addavg','on',...
    'addstd','off','subavg','on','diffavg','off','diffstd','off','chans',[1:64] ,...
    'ylim', [-20 20],'tplotopt',{'showleg', 'on','ydir', 1,'colors', {{'k' 'linewidth' 2},{'k--' 'linewidth' 2}}, 'title', TITLE});

% - --- write up in cell array TTESTS  using erp outputs
Zero = find(EEG.times==0); 
baseline1 =  erp1(:,1:Zero);
baseline2 = erp2(:,1:Zero);
Ttests = cell(1+length(EEG.chanlocs),1+Zero);
channels = [1:70];
Ttests(2:end,1) = num2cell(channels);
ISNONZERO1 = Ttests;
ISNONZERO2 = Ttests;
Ttests1= Ttests;
for c = 1:length(baseline1);    
    b1ch = baseline1(c,:);
    b2ch = baseline2(c,:);
    [h,p] = ttest2(b1ch,b2ch,0.01);
        Ttests(1+c,2:end) = {h};
    [h,p] = ttest2(b1ch,b2ch,0.01);
        Ttests1(1+c,2:end) = {h};
     [h,p] = ttest2(b1ch,0,0.01);
        ISNONZERO1(1+c,2:end) = {h}; 
     [h,p] = ttest2(b2ch,0,0.01);
        ISNONZERO2(1+c,2:end) = {h}; 
end

cd DIROUTPUT
xlswrite ([FIGURENAME 'BaselineComparison'], Ttests);
xlswrite ([FIGURENAME 'BaselineComparison1sampleT'], Ttests1);
xlswrite ([FIGURENAME 'BaselineWordsIsNonZero'], ISNONZERO1);
xlswrite ([FIGURENAME 'BaselineSymbolsIsNonZero'], ISNONZERO2);
end
    
    
      

% avgBl = mean (bl);


% 
% for ch = 1:length(baseline(:,1,1));
%      ch = baseline(c,:,:);
%     ['ch',num2str(c)] = ch; 
%     ['ch',num2str(c)]= bl(c,:,:);
%   
%  
%  ch1 = baseline (1,:,:)
%  ch1=squeeze(ch1)
%  avgch1 = mean(ch1,2)
%  
%  
% mean_to_plot = mean(diff(:,starttime:endtime),2);
% 
% 
