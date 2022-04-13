%% PLOT pre-stimulus alpha  in PO7 and PO8 channels
%=========================================================

%Check trials

 junk = struct2cell(EEG.event);
 events = cell2mat(reshape(junk(1,1,:),1,length(junk)));
  find(events==12)
%%
  figure; pop_erpimage(EEG,1, [25],[[]],'PO7',10,1,{ '21'},[],'type' ,'yerplabel','\muV',...
      'erp','on','limits',[0 1500] ,'cbar','on','spec',[0.5 60] ,'topo', { [25] EEG.chanlocs EEG.chaninfo } );
  
%%
 erpimage( mean(EEG.data([25], :),1), eeg_getepochevent( EEG, {'21'},[],'type'),...
     linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PO7', 10, 1 , 'yerplabel', '\muV', 'erp', 'on',...
     'limits',[0 1000 NaN NaN NaN NaN NaN NaN] , 'cbar', 'on', 'spec',[0.5 60]);
 
 %% 
 %%
 erpimage( mean(EEG.data([25], :),1),linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'PO7', 10, 1 , 'yerplabel', '\muV', 'erp', 'on',...
     'limits',[0 1000] , 'cbar', 'on', 'spec',[0.5 60]);
%% Plot spectrum 
for tr = 1;
    bin = EEG.data(chns,startpt:endpt,tr);
       srate = 256; nyquist = srate/2;    N = length(bin);   frequencies = linspace(0,nyquist,N/2+1);     
       frequencies2plot = frequencies(1:find(frequencies==50));
