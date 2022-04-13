% SPLIT AND PLOT AVERAGES  (in non interpolated subjects)
% ============================================
% Split: file in events (21, 22,23,24)
% Plot: averages of 21 & 22 versus average of 23 & 24
% Input/output directory: "Averages"folder
% Input files: sXXX-vwr-ICA-pruned-br-lp-refAvg.set
% Output files:  sXXX-vwr-ICA-pruned-br-lp-refAvg-e21.set
                % sXXX-vwr-ICA-pruned-br-lp-refAvg-e22.set
                % (...) 
                % PLOT : sXXX-wordsVsSymbols.fig
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
    if  G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_LEXI';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Pretest\Pretest_school';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_age';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Control\Control_dyslexia';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_LEXI';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\Dyslexie_Posttest\Posttest_school';
    end
    
cd (DIRNAME);

for N = N; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
         [FILES] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br-lp-refAvg-'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-lp-refAvg'];
        [FILES] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br-lp-refAvg-'];
    end
    
%Enter the filename of the file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];

%%% Check if the file exist in the current folder and if it is there
%%% process it else gives a line that it is not found and goes to the next
%%% file
if ~isempty(dir(FILENAME1))
    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename',FILENAME1);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );



FILENAME1 = [FILENAME, '.set'];


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

 eeglab redraw
 % -----------------------------------------------
   
FILES = [FILES '*e2*.set'];
FILES = [dir(FILES)]; %Search in current Dir files 

eeglab

for  J = 1:length(FILES); %J contains the list of the files containing'
  FILENAME2 = [FILES(J).name]; %Use the dimension name of each element of the list J as filename


 

EEG = pop_loadset('filename',FILENAME2);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
eeglab redraw

end
%Plot average of words (addavg) substract average of symbols(subavg)
%Insert the number of the corresponding dataset
% They follow the order: words 21,22 [1 2] ,symbols 23,24 [3 4]
FIGURENAME = FILENAME2(1:4);
FIGURENAME = [FIGURENAME, '-wordsVsSymbols'];
[erp1 erp2 erpsub time sig] = pop_comperp( ALLEEG, 1, [1 2] ,[3 4] ,'addavg','on',...
    'addstd','off','subavg','on','diffavg','off','diffstd','off','chans',[1:64] ,...
    'alpha',0.01,'ylim', [-20 20],'tplotopt',{'ydir' 1 'colors', {{'k' 'linewidth' 2},{'k--' 'linewidth' 2}}, 'title', FIGURENAME});
%save figure in matlab fig format
saveas (gcf,FIGURENAME, 'fig');
%remove 4 active datasets (to load those of second subject in the list)
ALLEEG = pop_delset(ALLEEG, [1:4]);
close figure 2
eeglab redraw

 %------------------------------------------------
 else 
     fprintf('File %s not found\n',FILENAME1);
end

end
end

