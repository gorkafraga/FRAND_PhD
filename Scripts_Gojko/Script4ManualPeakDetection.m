%% SCRIPT FOR PEAK DETECTION
%%
% vectors with experimental conditions and events
condition = {'a'; 'av'; 'av200'};

% Vector with channel names
Channels={'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2'};

% Number of electrodes
Nel =64;

% Time range around the peak for mean amplitude
range = 25;

int=1;   % 1 = interactive 0 = automatic

% Loop through subjects 
for N = p:q
% Loop through conditions 
for c = 1:3

    % Choose the files to load (if l=1 long epochs, if l=0 short epochs)
    if l==1
        if N <10   
            [FileName]=['s00',num2str(N),'-mmn-',condition{c,1}];
            [FileNam]=['s00',num2str(N),'-mmn-',condition{c,1},'-sphint'];
        elseif N >=10 && N<100   
            [FileName]=['s0',num2str(N),'-mmn-',condition{c,1}];
            [FileNam]=['s0',num2str(N),'-mmn-',condition{c,1},'-sphint'];
        elseif N >99
            [FileName]=['s',num2str(N),'-mmn-',condition{c,1}];
            [FileNam]=['s',num2str(N),'-mmn-',condition{c,1},'-sphint'];
        end
    elseif l==0
        if N <10 
            [FileName]=['s00',num2str(N),'-mmn-',condition{c,1},'-se'];
            [FileNam]=['s00',num2str(N),'-mmn-',condition{c,1},'-se-aphint'];
        elseif N >=10 && N<100   
            [FileName]=['s0',num2str(N),'-mmn-',condition{c,1},'-se'];
            [FileNam]=['s0',num2str(N),'-mmn-',condition{c,1},'-se-aphint'];
        elseif N >99
            [FileName]=['s',num2str(N),'-mmn-',condition{c,1},'-se'];
            [FileNam]=['s',num2str(N),'-mmn-',condition{c,1},'-se-aphint'];
        end
    end
    
    % Switch to folder with files
    if N < 100
        cd 'D:\EEG Data\pretest\MMN\LEXI Group';
    elseif N > 100 && N < 150
        cd 'D:\EEG Data\pretest\MMN\School Group';
    elseif N > 200 && N < 250
        cd 'D:\EEG Data\control\MMN\School Group';
    elseif N > 300 && N < 350
        cd 'D:\EEG Data\control\MMN\IWAL Group';
    elseif N > 400 && N < 450
        cd 'D:\EEG Data\posttest\MMN\LEXI Group';
    elseif N > 500 && N < 550
        cd 'D:\EEG Data\posttest\MMN\School Group';    
    end
    
    F1=[FileNam,'.mat'];
    F2=[FileName,'.mat'];
    % Loads file with interpolated electrodes if it exists, if not loads the
    % one without interpolated electrodes, else prints that file is not
    % found
    if ~isempty(dir(F1))
        load (F1)
        FILENAME=F1;
    else
        if ~isempty(dir(F2))
            load (F2)
            FILENAME=F2;
        else
            fprintf('File %s not found\n',FileName);
        end
    end
    
    if ~isempty(dir(F1)) || ~isempty(dir(F2))
            
        % Go through the sampling points and find latencies that are
            % approximately 50 and 250ms to search for MMN and 500 and
            % 800ms to search for Late Negativity
            for i=1:length(time)
                if c==3   
                    if time(1,i)> 249 && time(1,i)<251
                    s1=i;
                    elseif time(1,i)>449 && time(1,i)<451
                    e1=i;
                    elseif time(1,i)> 699 && time(1,i)<701
                    s2=i;
                    elseif time(1,i)>999 && time(1,i)<1001
                    e2=i;
                    end
                else
                    if time(1,i)> 49 && time(1,i)<51
                    s1=i;
                    elseif time(1,i)>249 && time(1,i)<251
                    e1=i;
                    elseif time(1,i)> 499 && time(1,i)<501
                    s2=i;
                    elseif time(1,i)>799 && time(1,i)<801
                    e2=i;
                    end
                end
            end
        
        % Make a matrix in whichfirst column will contain peak latencies,
        % second peak amplitudes, and third average amplitudes
        mmn =zeros(Nel,3);
        
        %Loop through electrodes
        for k =1:Nel
            time1=time/1000;            
            g=figure(1);
            set(g,'name',[num2str(k),'. ',Channels{1,k}],'numbertitle','off');
            set(g,'units','normalized','outerposition',[0 0 1 1]);
            plot(time1,AvgDeviant(k,:),time1,AvgStandard(k,:))
            set(gca,'XLim',[-0.5 1.2],'XTick',-0.5:0.1:1.2,'YDir','reverse','Ylim', [-8 8],'Ytick',-8:1:8)
            xlabel('Time [seconds]');
            ylabel('Potential [\muV]');
            drawaxis(gca, 'x',0,'y',0)

            h=figure(2);
            set(h,'name',[num2str(k),'. ',Channels{1,k}],'numbertitle','off');
            set(h,'units','normalized','outerposition',[0 0 1 1]);
            plot(time1,AvgDifference(k,:))
            set(gca,'XLim',[-0.5 1.2],'XTick',-0.5:0.1:1.2,'YDir','reverse','Ylim', [-8 8],'Ytick',-8:1:8)
            xlabel('Time [seconds]');
            ylabel('Potential [\muV]');
            drawaxis(gca, 'x',0,'y',0)
        
            pause
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% diff

            disp(['Electrode: ',Channels{k}]);


            signal=-AvgDifference(k,:);
            signal_analysis=signal(s1:e1);
            peak_amplitude=max(signal_analysis)
            peak_latency_ind=min(find(signal_analysis==peak_amplitude)+s1);
            peak_latency=time(peak_latency_ind);
            [mm1,windst_ind]=min(abs(time-(peak_latency-range)));
            [mm2,winden_ind]=min(abs(time-(peak_latency+range)));
            avg_amplitude=sum(signal_analysis(windst_ind-s1:winden_ind-s1))/((winden_ind-s1)-(windst_ind-s1)+1);       
            
            if int==1
            w=figure(3);
            clf
            set(w,'name',[num2str(k),'. ',Channels{1,k}],'numbertitle','off');
            set(w,'units','normalized','outerposition',[0 0 1 1]);
            plot(time,-signal);
            hold on
            plot(peak_latency,-peak_amplitude,'o');
            set(gca,'XLim',[-500 1200],'XTick',-500:100:1200,'YDir','reverse','Ylim', [-8 8],'Ytick',-8:1:8)
            xlabel('Time [seconds]');
            ylabel('Potential [\muV]');
            drawaxis(gca, 'x',0,'y',0)
            
            p=input('Peak ok? (y/n)','s');     
            
            while p=='n'

                temp=input('peak latency = ');
                [mm,peak_latency_ind]=min(abs(time-temp));
                [mm1,windst_ind]=min(abs(time-(temp-range)));
                [mm2,winden_ind]=min(abs(time-(temp+range)));
                peak_latency=time(peak_latency_ind);
                peak_amplitude=signal_analysis(peak_latency_ind-s1);
                avg_amplitude=sum(signal_analysis(windst_ind-s1:winden_ind-s1))/((winden_ind-s1)-(windst_ind-s1)+1);       
                w=figure(3);
                clf
                set(w,'name',[num2str(k),'. ',Channels{1,k}],'numbertitle','off');
                set(w,'units','normalized','outerposition',[0 0 1 1]);
                plot(time,-signal);
                hold on
                plot(peak_latency,-peak_amplitude,'o');
                set(gca,'XLim',[-500 1200],'XTick',-500:100:1200,'YDir','reverse','Ylim', [-8 8],'Ytick',-8:1:8)
                xlabel('Time [seconds]');
                ylabel('Potential [\muV]');
                drawaxis(gca, 'x',0,'y',0)
                p=input('Peak ok? (y/n)','s');         
            end
            end         

               mmn(k,1)=peak_latency;
               mmn(k,2)=-peak_amplitude;
               mmn(k,3)=-avg_amplitude;
               plot(peak_latency,-peak_amplitude,'r+'); 

        end
  
        % Adds variables with peak information to the file
        save(FILENAME,'-append','mmn')
    else
       continue
    end

end
end                     