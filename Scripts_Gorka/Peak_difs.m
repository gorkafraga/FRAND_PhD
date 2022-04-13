
% go to directory: 

cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection\PEAKS';


%Fill in values and peak files
 prompt={'Define peak and value type'};
   name='define';
   numlines=1;
   defaultanswer = {'P1?Amplitudes?'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   F=answer;  
  
for F=F; 
 if strcmp(F,'P1Amplitudes')==1; 
     FILENAME = 'P1Amplitudes.xlsx';
 elseif  strcmp(F,'P1Latencies')==1; 
     FILENAME = 'P1Latencies.xlsx';
 elseif  strcmp(F,'N1Amplitudes')==1; 
     FILENAME = 'N1Amplitudes.xlsx';
 elseif  strcmp(F,'N1Latencies')==1; 
     FILENAME = 'N1Latencies.xlsx';
 end

%load xls file data and define arrays
 [NUMERIC,TXT,RAW]=XLSREAD(FILENAME);
 if strcmp(F, 'N1Amplitudes')==1; % multiply for -1 amplitudes of N1
     NUMERIC1 = NUMERIC*-1;
 else NUMERIC1 = NUMERIC;
 end
 
 names= RAW(2:end,1);
 channels = {'TP7','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
     'POz','TP8','P6','P8','P10','PO8','PO4','O2'} ;

colnames = {};
 for l = 1:length(channels);
     ch = channels(l);
     col = [cell2mat(ch) 'difShort'];
     col2 = [cell2mat(ch) 'difLong'];
     col3 = [cell2mat(ch) 'difAvg'];
     colnames = [colnames col col2 col3]; 
 end
 
 newfilename = [FILENAME(1:end-5),'_diff'];
  


 % loop through channels 
   D = [];
 for l = 1:length(channels);
     ch = channels(l);
   
   %define conditions
    c1 =  strcat(ch,'-SW');
    c2 =  strcat(ch,'-LW');
    c3 =  strcat(ch,'-SS');
    c4 =  strcat(ch,'-LS');
    %find indexes for conditions
    C1 = strmatch (c1,TXT); 
    C2 = strmatch (c2,TXT); 
    C3 = strmatch (c3,TXT); 
    C4 = strmatch (c4,TXT); 
    
    % average and SD short and long condition together
    AvgWords = mean(NUMERIC1(:,C1)+ NUMERIC1(:,C2));
    AvgSymbols = mean(NUMERIC1(:,C3)+ NUMERIC1(:,C4));
    SDWords = std(NUMERIC1(:,C1)+ NUMERIC1(:,C2));
    SDSymbols = std(NUMERIC1(:,C3)+ NUMERIC1(:,C4));
    % Sum words and symbols 
    Words = NUMERIC1(:,C1)+ NUMERIC1(:,C2);
    Symbols = NUMERIC1(:,C3)+ NUMERIC1(:,C4);
    
    % Compute differences: short-short,long-long,meanWrds-meanSymb
    difShorts = NUMERIC1(:,C1)- NUMERIC1(:,C3); %SW - SS
    difLongs = NUMERIC1(:,C2)- NUMERIC1(:,C4); %LW - LS
    difAvg =  Words - Symbols; %(SW+LW)- (SS+LS)

   % Save in new array;
     D = [D difShorts difLongs difAvg];
     
 end
 %save to xls file
 xlswrite(newfilename, colnames,'Sheet1', 'B1')
 xlswrite(newfilename, names, 'Sheet1', 'A2')
 xlswrite(newfilename, D, 'Sheet1', 'B2')


end


