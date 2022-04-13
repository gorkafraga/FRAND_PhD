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
%-------------------------------------------------------------------------
%% Define output directory 
clear all
close all
[DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\GrandAverages';    
% -------------------------------------------------------------------------
%% Pop up for Input of group and subjects 
   prompt={'Define group-subject code (1 to 522)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'???'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   n=cell2mat(answer(1));n =str2num(n);

%--------------------------------------------------------------------------
%% Define subjects. Including group directory and name of group (to use as figurename )
%  n = abc Group directory defined by a. b & c define subject number.  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

 for N = n; 
  if N < 100
    DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI\';
    FIGURENAME = 'PreLexi';
    figGroupName(1) = {FIGURENAME};
      
    if N < 10 
       FILES =['s','00',num2str(N),'*e2*.set'];
    elseif N >=10 && N<100   
       FILES =['s','0',num2str(N),'*e2*.set'];
    end
  elseif N >=100
        FILES =['s',num2str(N),'*e2*.set'];  
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
   
%% Get full file name by searching in directory relevant files. 
%  and load ALL files in eeglab. 
cd (DIRINPUT) % 
listFiles = dir(FILES); %Search in current Dir files 

for  J = 1:length(listFiles); %J contains the list of the files 
  FILENAME1 = [listFiles(J).name]; %Use the dimension name of each element of the list J as filename

    if ~isempty(dir(FILENAME1))

      EEG = pop_loadset('filename',FILENAME1);
      [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
       eeglab redraw

    else 
           fprintf('File %s not found\n',FILENAME1);
    end

end
cd .. 
cd .. 
end
 %return to previous folder 

 
%
 %%
figGroupName(cellfun('isempty',figGroupName)) = [];
figGroupName=unique(figGroupName);
figGroupName = [sprintf('%s-',figGroupName{1:end-1}),figGroupName{end}];
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
    TITLE = [figGroupName '-' nsubj 'ss'];
 
 % PLOT SW&LW versus SS&LS showing significance (0.01) in all channels
 cd (DIRNAME) 
[erp1 erp2 erpsub time sig] = pop_comperp( ALLEEG, 1, datadd ,datsub ,'addavg','on',...
    'addstd','off','subavg','on','diffavg','off','diffstd','off','chans',[1:64] ,...
    'ylim', [-20 20],'tplotopt',{'showleg', 'on','ydir', 1,'colors', {{'k' 'linewidth' 2},{'k--' 'linewidth' 2}}, 'title', TITLE});
% White background color 
set(2,'Color', [1,1,1]);
%save figure in matlab fig format
saveas (gcf,TITLE, 'fig');
saveas (gcf,TITLE, 'tiff')

eeglab redraw
%%% Now plot with significance:
 TITLE2 = [figGroupName '-' nsubj 'ss-sig'];
[erp1 erp2 erpsub time sig] = pop_comperp( ALLEEG, 1, datadd ,datsub ,'addavg','on',...
    'addstd','off','subavg','on','diffavg','off','diffstd','off','chans',[1:64] ,...
    'alpha',0.01,'ylim',[-20 20],'tplotopt',{'showleg', 'on','ydir' 1 'colors', {{'k' 'linewidth' 2},{'k--' 'linewidth' 2}}, 'title', TITLE2});
% White background color 
set(2,'Color', [1,1,1]);
saveas (gcf,TITLE2, 'fig');
saveas (gcf,TITLE2, 'tiff')


%==========================================================================
%SAVE CSV FILE WITH SUBJECTS INCLUDED
     % Empty  array to fill in subject name: rows = number of subjects
cd  (DIRNAME);
%%%%%%% FIND THE FILENAMES OF USED IN THE GRAND AVERAGE (from ALLEEG)
%%%%%%% Save them in cell array and save in txt file
                
                sList = cell(25,1); % empty cell array subject List
                n = length(ALLEEG)/4;
                
            for  k = 1:length(ALLEEG); 
                 A =  ALLEEG(k).setname; 
                 sname = A(1:size(A,2)-8); % pick the info from filename
%                 % subject number in first row.Avoid repeated numbers
                 X = strcmp (sname,sList); 
                  if X==0;  % if the name is not in the list array write it
                    sList(k,:)= {sname}; 
                    blanks = cellfun('isempty', sList); % remove empty rows
                    sList(blanks)= [] ;
                 end;
                 %save to  file in same folder 
                    listname = [TITLE2 '-list.csv'];
                    fid = fopen(listname, 'wt');
                    [rows, cols] = size(sList);
                    for i=1:rows; 
                        fprintf(fid,'%s,',sList{i,1:end-1});
                        fprintf (fid,'%s\n', sList{i,end});
                    end;
                    
                    fclose(fid);
                
             end
 
            



 