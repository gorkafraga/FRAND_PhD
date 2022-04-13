
clear all


% SCRIPT FOR PROCESSING VWR FILES
% ================================================================================
 % -> INTERPOLATE CHANNELS AFTER ICA PRUNING AND BASELINE REMOVAL 
 % + LOWPASS FILTER (30Hz) 
 % + Rereference to Avg (Exclude interpolated chans., with this ICA weights
 %              are lost because ICA matrix was computed with 64 channels)
 % * Find below a "if loop" with channels to interpolate for each subject
 %-------------------------------------------------------------------------

%%%% Group codes (G) are:   0 (Pretest_dyslexia)1 (Pretest_school) 
%%%%                        2(Control_school)   3 (Control_dyslexia) 
%%%%                        4(Posttest_dyslexia)5 (Posttest_school)
%---------------------------------------------------------
% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) ','Define Subject with Chans to interpolate N(1 to 22)'};
   name='Input subject';
   numlines=1;
   defaultanswer = {'?','??', '???'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 
   N=cell2mat(answer(2));N = str2num(N);
%    ExChan=cell2mat(answer(3)); 
%    ExChan = str2num(ExChan);ChanInterp = ExChan;
%--------------------------------------------------------------------------

for G = G; 
    if          G == 0 
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

for N = [N]; 
    if N < 10
    [FILENAME] =['s',num2str(G),'0',num2str(N),'-vwr-ICA-pruned-br'];
    elseif N >=10 && N<100   
    [FILENAME] =['s',num2str(G),num2str(N),'-vwr-ICA-pruned-br'];
    end

%Enter the filename of the file with the extension included, e.g
FILENAME1 = [FILENAME, '.set'];


% Choose the channels to interpolate for each subjects as specified in the log excel file:
for G = G; %%%%%%%%%%%%S are List of subjects with interpolated channels in each group G.
        %Below are the channels to be interpolated in each of those. 
    
    % ------------------------------Pretest Dyslexia    
    if G == 0; 
    S = [1,3,6,8,13,14,16,19,20,21,22];
         for N=N;
            if ismember(N,S)== 0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                    if N == 1; 
                       Exchan = [8, 21, 57, 61, 30];%s001 interpolate: FT7, P3, P2,P10, POz 
                    elseif N == 3;
                        Exchan = [29,27]; %s003 interpolate Oz,O1
                    elseif N == 6; 
                        Exchan = [28, 24]; %s006 interpolate Iz, P9
                    elseif N == 8; 
                        Exchan = [30]; %s008 interpolate POz 
                    elseif N == 13;
                        Exchan = [44]; %s013 interpolate FC6
                    elseif N == 14; 
                        Exchan = [44,22,63]; %s014 interpolate FC6, P5, PO4
                    elseif N == 16; 
                        Exchan = [57]; %s016 interpolate P2 
                     elseif N == 19; 
                        Exchan = [24,63,57]; %s019 interpolate P9 , PO4, P2
                     elseif N == 20; 
                        Exchan = [61]; %s020 interpolate P10 
                    elseif N == 21; 
                        Exchan = [53,30,57]; %s021 interpolate TP8 Poz & P2 
                     elseif N == 22; 
                        Exchan = [57, 61, 24, 32, 46, 45, 64, 49]; %s022 interpolate P2, P10, P9, CPz, FC2, FC4, O2, C2

                    end   
            end
         end
    %------------------------ Pretest School
   elseif G == 1; 
   S = [1,2,4,7,12,14,15,17];  
        for N=N;
            if ismember(N,S)== 0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                    if N == 1; 
                       Exchan = [29,30,64,63,27,47,57];%s101 interpolate: Oz Poz O2 PO4, O1, FCz,p2
                    elseif N == 2;
                        Exchan = [49, 58]; %s102 interpolate C2, P4 
                    elseif N == 4; 
                        Exchan = [38,63]; %s104 interpolate Fz PO4
                    elseif N == 7; 
                        Exchan = [28, 57]; %s107 interpolate Iz, P2 
                    elseif N == 12;
                        Exchan = [40];% s112 interpolate F4
                    elseif N == 14;
                        Exchan = [63]; %s114 interpolate PO4
                    elseif N == 15
                        Exchan = [8, 60]; %s115 interpolate FT7, P8
                    elseif N == 17;
                        Exchan = [28]; %s117 interpolate Iz
                        
                    end   
            end
        end
     %------------------------ Control Schoo(cr Age)
    elseif G == 2; 
      S = [6,17,18,19,20];  
        for N=N;
            if ismember(N,S)== 0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                    if N == 6; 
                       Exchan = [20];%s206 interpolate P1
                    elseif N == 17; 
                        Exchan = [20]; %s217 interpolate P1
                    elseif N == 18; 
                        Exchan = [30]; %s218 interpolate POz
                     elseif N == 19; 
                        Exchan = [30,21]; %s219 interpolate POz, P3
                    elseif N == 20;
                        Exchan = [20,31,57]; %220 interpolate P1,Pz,P2
                    end   
            end
        end
        %-------------------- Control Dyslexia 
      elseif G == 3; 
      S = [16,18];  
        for N=N;
            if ismember(N,S)== 0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                    if N == 16; 
                       Exchan = [31];%s316 interpolate Pz
                    elseif N == 18; 
                        Exchan = [24,61]; %s318 interpolate P9, P10
                    end   
            end
        end  
        %-------------------- Posttest Dyslexia
      elseif G == 4; 
      S = [4,5,7,11,13,14,18,19,21,22];  
        for N=N;
            if ismember(N,S)==0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                    if N == 4; 
                       Exchan = [26];%s404 interpolate PO3 
                    elseif N == 5; 
                        Exchan = [33]; %s405 interpolate FPz 
                    elseif N == 7; 
                        Exchan = [26]; %s407 interpolate PO3
                    elseif N == 11; 
                        Exchan = [36,44,33]; %s411 interpolate AF4,FC6,FPz
                    elseif N == 13; 
                        Exchan = [26,20]; %s413 interpolate PO3,P1
                    elseif N == 14; 
                        Exchan = [28]; %s414 interpolate Iz
                    elseif N == 18; 
                        Exchan = [26]; %s418 interpolate PO3
                    elseif N == 19; 
                        Exchan = [51,33,31,30]; %s419 interpolate C6,FPz,Pz,POz
                    elseif N == 21; 
                        Exchan = [31,26,25]; %s421 interpolate Pz,PO3
                    elseif N == 22; 
                        Exchan = [63]; %s422 interpolate PO4
                    end   
            end
        end  
        
            %-------------------- Posttest school 
      elseif G == 5; 
      S = [4,5,12,14,17,19];  
        for N=N;
            if ismember(N,S)== 0 
                fprintf('File %s does not need interpolation\n',FILENAME);
                Exchan = 0;
            else               
                   if N == 4; 
                       Exchan = [30,20,21,57];%s504 interpolate POz , P1 , P3, P2
                    elseif N == 5; 
                        Exchan = [30]; %s505 interpolate POz
                    elseif N == 12; 
                        Exchan = [26]; %s512 interpolate PO3
                    elseif N == 14; 
                        Exchan = [20]; %s514  interpolate P1
                    elseif N == 17; 
                        Exchan = [30]; %s517 interpolate POz
                    elseif N == 19; 
                        Exchan = [30]; %s519 interpolate POz
                  end   
            end
        end 
        
        
        %______________
       end
end

Badchan = Exchan;
if ~isempty(dir(FILENAME1)) && all(Badchan)

    %%% Check if the file exist in the current folder and if it is there
    %%% process it else gives a line that it is not found and goes to the next
    %%% file

    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename',FILENAME1);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    % ===============INTERPOLATE BAD CHANNELS 

    EEG =pop_interp(EEG, Badchan, 'spherical');
    FILEINTERP = strrep (FILENAME,'ICA-pruned-br','ICA-pruned-br-interp');
    EEG = pop_saveset (EEG, FILEINTERP,DIRNAME);
    eeglab redraw;


     % ==========================FILTER
    %Low pass filter to 30 Hz the data pruned with ICA
     EEG = pop_eegfilt( EEG, 0, 30);
     %Save file after 
     FILENAME2= strrep (FILEINTERP,'ICA-pruned-br-interp','ICA-pruned-br-interp-lp');
     EEG = pop_saveset (EEG, FILENAME2,DIRNAME);
     eeglab redraw;
    % ==========================REFERENCE AVG
    % RE-REFERENCE to AVERAGE of all electrodes excluding interpolated ones
      FILENAME3 = [FILENAME2 '-refAvg'];
     refchan = [1:64]; 
     refchan(Exchan) = []; % exclude the interpolated from the average(not from rereferencing)
      EEG = pop_reref( EEG, refchan,'exclude',[65:70],'keepref', 'on');
     EEG = pop_saveset (EEG, FILENAME3,DIRNAME);
    else 
     fprintf('File %s not found\n',FILENAME1);
      end
    end

end
