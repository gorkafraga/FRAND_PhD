%Interpolate channels: chan = numbers of channels to be interpolated
DIRNAME = EEG.filepath;
cd(DIRNAME)
% load('info.mat')
% subject=str2num(EEG.setname(2:4));
% info(subject).name = [EEG.datfile]; %= EEG.filename;
FILENAME = EEG.datfile; %GF
%Fill in the number of the channels to interpolate
%=======================================================================
% POPUP WINDOW TO ENTER CHANNELS
% -------------------------------------------------------------------------
   prompt={'Define channels to interpolate in active dataset '};
   name='Input Channels';
   numlines=1;
   defaultanswer = {'?????'};
   options.Resize='on';
   options.WindowStyle='modal';

   
   answer=inputdlg(prompt,name,numlines,defaultanswer,options);
   EXCHAN = cell2mat(answer(1)); EXCHAN = str2num(EXCHAN);
%--------------------------------------------------------------------------
BADCHAN = EXCHAN; 
% info(subject).noch = num2str(BADCHAN);
FILENAME1 = strrep (FILENAME, '.fdt', '-interp.fdt');
%change filename1 
EEG =pop_interp(EEG, BADCHAN, 'spherical');
%Save 'info' (takes some time)
% cur=pwd;
% cd(DIRNAME)
% save('info.mat','info');
% cd(cur)
%Save dataset
EEG = pop_saveset (EEG, FILENAME1,DIRNAME);
eeglab redraw;