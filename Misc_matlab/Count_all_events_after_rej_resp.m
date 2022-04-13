clear all
close all

% COUNT THE No of EVENTS IN EPOCHED DATA AFTER REJ RESPONSE TRIALS 
% LET OP!: only counts after removing epochs with event 12 (resp)NOT after inspection of epochs
% Works for all files after cleaning of epochs (included those with interp chan) 
% Output is txt file for each subject (also will keep info about interp) 
% Output is sorted by event numbers in ascendent order 21 22 23 24
%--------------------------------------------------------------------------
% POPUP WINDOW TO ENTER THE GROUP AND SUBJECT INPUT
% -------------------------------------------------------------------------
   prompt={'Define Group folder G(0 to 5) '};
   name='Input group';
   numlines=1;
   defaultanswer = {'?'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   G=cell2mat(answer(1));G = str2double(G); 

%--------------------------------------------------------------------------
for G = G; %Select group folder in which it will make the count
    if  G == 0 
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_dyslexia\RejEpochs&ICA';
        elseif G == 1
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Pretest\Visual_word_analysis\Pretest_school\RejEpochs&ICA';
        elseif G == 2
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_school\RejEpochs&ICA';
        elseif G == 3
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Control\Visual_word_analysis\Control_dyslexia\RejEpochs&ICA';  
        elseif G == 4
        DIRNAME = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_dyslexia\RejEpochs&ICA';
        elseif G == 5
        [DIRNAME] = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab\Dyslexie_Posttest\Visual_word_analysis\Posttest_school\RejEpochs&ICA';
    end;

cd (DIRNAME);
eeglab;

% dir('*EpClean*')
    
FILES = [dir('*rejResp*.set')]; %Search in current Dir files 'epclean'
for  J = 1:length(FILES); %J contains the list of the files containing 'epclean'.
      
  FILENAME1 = [FILES(J).name]; %Use the dimension name of each element of the list J as filename
  EEG = pop_loadset(FILENAME1, DIRNAME);
  % Counter of epochs for each event:    
    codes=zeros(5,1); 
    counts=codes;
    counter=1;

    if ~isempty(dir(FILENAME1));

        for e = 1:length(EEG.event)
            check=sum(EEG.event(e).type==codes);             
            if check==0
                codes(counter)=EEG.event(e).type;
                counter=counter+1;
            end

        end

        for e = 1:length(EEG.event)
            for i=1:5
                if codes(i)==EEG.event(e).type
                    counts(i)=counts(i)+1;
                end
            end
        end
         X=[codes' ; counts' ];

        DIRNAME2 = [DIRNAME, '\Trials_rej_resp'];
        FILENAME3 = strrep (FILENAME1, 'rejResp.set', 'count_resp_rej.txt');
            Y = X'; %transpose X 
            Y = sortrows(Y); %sort the transpose X according to first column (event number)
            COUNT = Y'; % transpose again this sorted matrix to have X sorted by event no (ascendent order)
            dlmwrite(fullfile(DIRNAME2,FILENAME3), COUNT); 
            
   %%%%%% =======NOW SAVE ALL IN ONE TXT FILE nice and tidy
            cd (DIRNAME2)
   
          % Empty  array to fill in subjects and trials per event 
            Responses = zeros (23,5);
            Events = [21,22,23,24];
            % Events = num2cell(Events);
            Responses(1,2:5) = Events; %% event names as headers

            % Load each textfile and take the relevant values 
            % Loop
            ListTexts= [dir('s*.txt')];
            for  k = 1:length(ListTexts); 
                textfile = ListTexts(k).name;
                % subject number in first column
                 sNo = textfile(:,2:4);
                Responses(1+k,1)= str2num(sNo); 
                % Write the number of trials in the next rows
                sCount = load (textfile);
                sCount = sCount(2,2:5);
                Responses(1+k,2:5) = sCount;
                %save to txt file in same folder 
                dlmwrite('Responses.txt',Responses)
            end 
    
    
    end
end
end


clear all
close all
 