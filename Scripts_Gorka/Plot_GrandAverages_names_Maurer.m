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

%%%% split files in event .First in non interpolated data, then repeat loop 
%%% in interpolated data
[DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\GrandAverages_MaurerEpoch';    

cd (DIRNAME);
for N = N; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
    end
    
    FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    

% % %---------------------Event 21
[ALLEEG, EEG, CURRENTSET] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0);
FILENAME = EEG.filename;
FILENAME1 = strrep (FILENAME,'.set','-e21.set') ;
EEG = pop_selectevent (EEG, 'type', 21); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

  clear FILENAME 
  clear FILENAME1
% % %---------------------Event 22

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e22.set') ;
EEG = pop_selectevent (EEG, 'type', 22); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 23

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e23.set') ;
EEG = pop_selectevent (EEG, 'type', 23); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 24

 EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e24.set') ;
EEG = pop_selectevent (EEG, 'type', 24); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

 clear FILENAME 
 clear FILENAME1
 %------------------------------------------------
 else 
     fprintf('File %s not found\n',FILENAME1);
end
end
%=======now split INTERPOLATED FILES

for N = N; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-interp-lp-refAvg'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-interp-lp-refAvg'];
    end
    
    FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    

% % %---------------------Event 21
[ALLEEG, EEG, CURRENTSET] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0);
FILENAME = EEG.filename;
FILENAME1 = strrep (FILENAME,'.set','-e21.set') ;
EEG = pop_selectevent (EEG, 'type', 21); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

  clear FILENAME 
  clear FILENAME1
% % %---------------------Event 22

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e22.set') ;
EEG = pop_selectevent (EEG, 'type', 22); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 23

EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e23.set') ;
EEG = pop_selectevent (EEG, 'type', 23); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);
 clear FILENAME 
 clear FILENAME1
% % %---------------------Event 24

 EEG = eeg_retrieve (ALLEEG, 1);
FILENAME = EEG.filename; 
FILENAME1 = strrep (FILENAME,'.set','-e24.set') ;
EEG = pop_selectevent (EEG, 'type', 24); 
EEG = pop_editset (EEG, 'setname', FILENAME1);
EEG = pop_saveset (EEG,FILENAME1,DIRNAME);

 clear FILENAME 
 clear FILENAME1
 %------------------------------------------------
 else 
     fprintf('File %s not found\n',FILENAME1);
end
end
%%% now look for the event files to plot Grand averages
 for N = N; 
  if N < 10
     [FILES] =['s',num2str(G),'0',num2str(N),'*e2*.set'];
    elseif N >=10 && N<100   
    [FILES] =['s',num2str(G),num2str(N),'*e2*.set'];
  end
%   

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
    nsubj = [nsubj(2)/4;]
    nsubj = num2str(nsubj);
 %Include in Title info about group(FIGURENAME) & nSubjects
    TITLE = [FIGURENAME '-' nsubj 'subjects-nosig'];
 

 % PLOT SW&LW versus SS&LS showing significance (0.01) in all channels

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
 TITLE2 = [FIGURENAME '-' nsubj 'subjects'];
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
                
            end;
            

end

 