
% Find in folder all xls files with respons-stats and plot all
% subjects in one file with s as rows and columns containing n of
% responses,averages,SD per event and in total

cd (DIROUT); 

FILES = dir('*stats.xls'); %Search in current Dir files 
header = {'','nT','avgT','SDT','n21','avg21', 'SD21','n22','avg22', 'SD22','n23','avg23', 'SD23','n24','avg24', 'SD24'};
allrespstats = cell(2, 16);
allrespstats(1,:) = header;

for J = 1:length(FILES); %J contains the list of the files containing'
  FILENAME = [FILES(J).name] ; %Use the dimension name of each element of the list J as filename
  allrespstats(1+J,1) = {FILENAME(2:4)};
  respstats = xlsread(FILENAME);
  %include in allrespstats: n, avg, SD from the resp-stats files
  % Total
  allrespstats(1+J,2) = { respstats(4,1)} ;
  allrespstats(1+J,3) = { respstats(2,1)} ;
  allrespstats(1+J,4) = { respstats(3,1)} ;
  %event 21
  allrespstats(1+J,5) = { respstats(4,2)} ;
  allrespstats(1+J,6) = { respstats(2,2)} ;
  allrespstats(1+J,7) = { respstats(3,2)} ;
 % event 22
 allrespstats(1+J,8) = { respstats(4,3)} ;
 allrespstats(1+J,9) = { respstats(2,3)} ;
 allrespstats(1+J,10) = { respstats(3,3)} ;
 % event 23
 allrespstats(1+J,11) = { respstats(4,4)} ;
 allrespstats(1+J,12) = { respstats(2,4)} ;
 allrespstats(1+J,13) = { respstats(3,4)} ;
 %event 24 
 allrespstats(1+J,14) = { respstats(4,5)} ;
 allrespstats(1+J,15) = { respstats(2,5)} ;
 allrespstats(1+J,16) = { respstats(3,5)} ;
end

