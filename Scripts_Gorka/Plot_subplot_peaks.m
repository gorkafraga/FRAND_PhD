
%% Create 1 window per condition with multiple plots (channels with peaks)
%==========================================================================
% Subject: one folder per subject so loop through folders in current dir
% 
cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection\plots';
D = dir ; 
listfolders = cell(1,length(D));
 
for h = 1:length(D)
    if D(h).isdir == 1;
    listfolders(h) = {D(h).name};
    A = cellfun ('isempty', listfolders);
    listfolders(A) = [];
    end
end
listfolders(1:2)=[];
for f = 1:length(listfolders);
    
    
    DIRNAME = cell2mat(listfolders(f));
    cd(DIRNAME);
   
%%% Loop through conditions (1 plot per condition,multiple chans.per plot)
cond = {'ShortWords','LongWords', 'ShortSymbols', 'LongSymbols'}; 

for i = 1: length(cond);
   %f = figure;
   figure('name',cell2mat(cond(i))) %Figure window will display condition
    
%% Loop through plots of electrodes of interest in current folder
 
ChansOfInterest = {'TP7','P5','P7','P9','PO7','PO3','O1','Iz','Oz',...
     'POz','TP8','P6','P8','P10','PO8','PO4','O2'} ;

 
for l = 1:length(ChansOfInterest);
    ch = cell2mat(ChansOfInterest(l));
    file = dir(['*',cell2mat(cond(i)),'-',ch,'.fig']); % search in current folder for channel  

%% subplot position
 a =  subplot(5,4,l);
 set(a,'Title',text('String',ch,'Color','k'))
%% Copy first existing figure on first subplot 
% Open exiting figure 
f_c = openfig(file.name); 
 % Identify axes to be copied 
axes_to_be_copied = findobj(f_c,'type','axes'); 
% Identify the children of this axes 
chilred_to_be_copied = get(axes_to_be_copied,'children'); 
% Identify orientation of the axes 
[az,el] = view; 
% Copy the children of the axes 
copyobj(chilred_to_be_copied,a); 
% Set the limits and orientation of the subplot as the original figure 

set(a,'Xlim',get(axes_to_be_copied,'XLim')) 
set(a,'Ylim',get(axes_to_be_copied,'YLim')) 
set(a,'Zlim',get(axes_to_be_copied,'ZLim')) 
%set(a,'Title',text('String',ch,'Color','k'));
view(a,[az,el]) 
% One may set other properties such as labels, ticks etc. using the same
% Save figures in current dir
saveas (a,cell2mat(cond(i)), 'fig');
saveas (a,cell2mat(cond(i)), 'tiff')
% Close the figure 
close(f_c); 

end
end
close all
cd 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\PeakDetection\plots'
end