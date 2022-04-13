startpt = find(EEG.times==-500); % data point -500 ms 
endpt = find(EEG.times==0)-1; % data point just before 0 ms (-3.906 ms)
% chns = [16,22:27,53,59:64]; % sample channels from 1st ERP study- occipito/occipito-temporal
chns = [25,62];
tr = 1; % sample trial
chanlocfile = 'Z:\fraga\EEG_Gorka\Analysis_EEGlab11\channelsThetaPhi-2extRemoved.elp';

%% USING ERPIMAGE
chn = 25;
data = reshape(EEG_SW(chn,:,:),size(EEG_SW,2),size(EEG_SW,3));
 erpimage(data,[],[-500 525 256],'test',5,'erp','erpalpha',.05,'erpstd','coher', [9 13 0.05],'srate', 256, 'cbar', 'spec',[2 50]);
 set (gcf,'color','w');

%%
erpimage(data,[],[-500 525 256],'test',5,'cbar', 'erp','spec',[0.5 40])

 erpimage(data,[],[-500 525 256],'test',5,'cbar','erp','caxis',0.9,'spec',[0.5 60])









%% psd

for tr= 1:5;
    bin = EEG.data(chns,startpt:endpt,tr);
    figure;
    Hs = spectrum.welch;
    S1 = psd(spectrum.welch,bin(1,:),'FS',256);
    S2 = psd(spectrum.welch,bin(2,:),'FS',256);
     plot(S1,S2);hold on
    
     
    pause (0.6)
    close gcf    
end 
%% plot PRE-stimulus per trial
for tr = 2;
bin = EEG.data(chns,startpt:endpt,tr);
%  [spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
%  chanlocfile,'limits', [1,40,-60,60]);
figure;
[spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256); % no topoplots
close gcf;
figure;
ylim= [-60,60];
%myfreqs = 1:2:length(freqs);
plot(freqs,spectra(1,:),'color','b');set(gca,'Ylim', ylim);hold on
plot(freqs,spectra(2,:),'color','r');set(gca,'Ylim', ylim);hold on ;
plot([30,30], ylim,'k:'); % line low pass filter limits
plot([8,8], ylim,'k:'); % line alpha limits
plot([10,10], ylim,'k:'); % line alpha limits
%close gcf;
%figure;
% plot(1:128,bin);
% set(gca,'YLim',[-100,100]);
end
%% plot POST-stimulus per trial
for tr = 3;
bin = EEG.data(chns,(endpt+1):length(EEG.data),tr);
%  [spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
%  chanlocfile,'limits', [1,40,-60,60]);
figure;
[spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256); % no topoplots
close gcf;
plot(freqs,spectra(1,:),'color','b');hold on
plot(freqs,spectra(2,:),'color','r');
%close gcf;

%figure;
% plot(1:128,bin);
% set(gca,'YLim',[-100,100]);
end
%%
 [spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
 chanlocfile,'limits', [1,40,-60,60]);

%% plot WHOLE EPOCH per trial
for tr = 1:22;
bin = detrend(EEG.data(:,startpt:length(EEG.data),tr));
figure;
 [spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
 chanlocfile,'limits', [1,40,-60,60]);
pause (0.6);
close gcf;
end
%% plot PRESTIMULUS averaged across trials - ERP
bin = mean(EEG.data(:,startpt:endpt,:),3);
figure;
 [spectra,freqs,speccomp,contrib,specstd]= spectopo(detrend(bin),length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
 chanlocfile,'limits', [1,40,-60,60]);
%plot(1:128,avgprestim);
%set(gca,'YLim',[-10,10]);
%% plot whole epoch average across trials - ERP

bin = mean(EEG.data(1:64,:,:),3);
bin = mean(bin(:,:),1);
figure;
 [spectra,freqs,speccomp,contrib,specstd]= spectopo(bin,length(bin),256,'freq',[10,30],'mapchans',chns(end),'chanlocs',...
 chanlocfile,'limits', [1,40]);
%plot(1:length(EEG.times),avgprestim);
%set(gca,'YLim',[-40,40]);
