%% SCRIPT FOR PLOTTING DIFFERENCES AND PEAKS
%%
% Vector with conditions
condition = {'a'; 'av'; 'av200'};

% Vector with channel names
Channels={'Fp1','AF7','AF3','F1','F3','F5','F7','FT7','FC5','FC3','FC1','C1','C3','C5','T7','TP7','CP5','CP3','CP1','P1','P3','P5','P7','P9','PO7','PO3','O1','Iz','Oz','POz','Pz','CPz','Fpz','Fp2','AF8','AF4','Afz','Fz','F2','F4','F6','F8','FT8','FC6','FC4','FC2','FCz','Cz','C2','C4','C6','T8','TP8','CP6','CP4','CP2','P2','P4','P6','P8','P10','PO8','PO4','O2'};

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
        fn = FileNam;
    else
        if ~isempty(dir(F2))
            load (F2)
            FILENAME=F2;
            fn=FileName;
        else
            fprintf('File %s not found\n',FileName);
        end
    end
    
    if ~isempty(dir(F1)) || ~isempty(dir(F2))
        % Go through electrodes
        for k =1:64
            % Go through the sampling points and find latencies that
            % correspond to peak latencies
            locs=zeros(1,435);
            locs1=zeros(1,435);
            lat=zeros(1,435);
            lat1=zeros(1,435);               
            for i=1:length(time)
                points=ismember(time(1,i),EarlyPeaks{k,2});
                points1=ismember(time(1,i),LatePeaks{k,2});
                point=ismember(time(1,i),MMN(k,2));
                point1=ismember(time(1,i),LN(k,2));                
                if points==1
                    locs(1,i)=i;
                elseif locs==0
                    locs(1,i)=0;
                end
                if points1==1
                    locs1(1,i)=i;
                elseif locs1==0
                    locs1(1,i)=0;
                end
                if point==1
                    lat(1,i)=i;
                elseif point==0
                    lat(1,i)=0;
                end
                if point1==1
                    lat1(1,i)=i;
                elseif point1==0
                    lat1(1,i)=0;
                end       
            end
            
            locs = locs(locs~=0);
            locs1 = locs1(locs1~=0);
            lat = lat(lat~=0);
            lat1 = lat1(lat1~=0);
            time1=time/1000;
            
            f=figure(1);
            set(f,'name',fn,'numbertitle','off');
            set(f,'units','normalized','outerposition',[0 0 1 1]);
            h=subplot(8,8,k);
            plot(time1,AvgDifference(k,:));
            drawnow
            set(gca,'XLim',[-0.5 1.2],'XTick',-0.5:0.1:1.2,'YDir','reverse','Ylim', [-8 8],'Ytick',-8:1:8)
            drawaxis(gca, 'x',0,'movelabels',0)
            hold on;
            plot(time1(locs),EarlyPeaks{k,1},'k^','markerfacecolor',[1 0 0]); hold on;
            plot(time1(locs1),LatePeaks{k,1},'k^','markerfacecolor',[1 0 0]);
            title([num2str(k),'. ',Channels{1,k}])
            expandAxes(h)            
        end
      
        saveas (f,[fn,'-peaks'], 'fig');
        close(f)
        
        clear locs locs1 time1 points points1
    else
       fprintf('Continuing with the next subject\n');
    end

end
end