%%%MERGE FILES WITH PEAK INFO.All groups, latencies and amplituder together
%--------------------------------------------------------------------------
clear all
close all
% ------------------------Define directory to save files
DIROUTPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection';
%--------------------------Define input directory ------
DIRINPUT = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection';
cd (DIRINPUT);

  %%% ========= list excel files
   listamp = ls('*Amp.xls'); % amplitude files
   listlat = ls('*Lat.xls'); % latency files 
   for l = 1:size(listlat,1);
       listamp(l,:) = 
% Output: All_N1_(no.Channels)
% 1 . [optional] list = ls() to list the .xlsx files. You can use wildcards.
% 2. Import the files with xlsread()
% 3. Concatenate the data. One of the function you might need to use is cat() or []. Or refer to the many See Also links in cat()
% 4. Write output to excel with xlswrite()



