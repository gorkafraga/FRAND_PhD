%% SCRIPT FOR PEAK DETECTION
%%
% vectors with experimental conditions and events
condition = {'a'; 'av'; 'av200'};

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
        
        % Makes cell arrays were first column consists of peaks amplitude,
        % second of peak latency and third peak sampling point
        % Local peaks between 50 and 250ms after auditory stimulus
        EarlyPeaks=cell(64,3);
        % Local peaks between 500 and 800ms after auditory stimulus
        LatePeaks=cell(64,3);
        % Global peak between 50 and 250ms after auditory stimulus
        MMN=zeros(64,3);
        % Global peak between 500 and 800ms after auditory stimulus
        LN=zeros(64,3);
        % Go through electrodes
        for k =1:64
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
                    
                        % Search for MMN
                        
                        % Find local negative peaks between 50 and 250ms
                        [pks,locs] = findpeaks(-AvgDifference(k,s1:e1),'minpeakheight',0);
                        locs=locs+s1;
                        timelocs=time(1,locs);
                        EarlyPeaks{k,1} = -pks;
                        EarlyPeaks{k,2} = timelocs;
                        EarlyPeaks{k,3} = locs;
                        % Find maximum negative peak between 50 and 250ms
                        [Ps,ind]=sort(pks,'descend');
                        l=locs(ind);
                        t=timelocs(ind);
                        for j =1:length(Ps)
                            if -AvgDifference(k,l(1,j)-1)<= Ps(1,j)&& -AvgDifference(k,l(1,j)+1)<= Ps(1,j)
                                MMNAmp=-Ps(1,j);
                                MMNtime=t(1,j);
                                MMNlocs=l(1,j);
                                break
                            else
                                continue
                            end
                        end
                        MMN(k,1)=MMNAmp;
                        MMN(k,2)=MMNtime;
                        MMN(k,3)=MMNlocs;                            

                        % Late Negativity
                        % Find local negative peaks between 500 and 800ms
                        [pks1,locs1] = findpeaks(-AvgDifference(k,s2:e2));
                        locs1=locs1+s2;
                        timelocs1=time(1,locs1);
                        LatePeaks{k,1} = -pks1;
                        LatePeaks{k,2} = timelocs1;
                        LatePeaks{k,3} = locs1;
                        % Find maximum negative peak between 500 and 800ms
                        [Ps1,ind1]=sort(pks1,'descend');
                        l1=locs1(ind1);
                        t1=timelocs1(ind1);
                        for j =1:length(Ps1)
                            if -AvgDifference(k,l1(1,j)-1)<= Ps1(1,j)&& -AvgDifference(k,l1(1,j)+1)<= Ps1(1,j)
                                LNAmp=-Ps1(1,j);
                                LNtime=t1(1,j);
                                LNlocs=l1(1,j);
                                break
                            else
                                continue
                            end
                        end
                        LN(k,1)=LNAmp;
                        LN(k,2)=LNtime;
                        LN(k,3)=LNlocs;                            
                   clear pks pks1 locs locs1
        end
        
        % Adds variables with peak information to the file
        save(FILENAME,'-append','MMN','LN','EarlyPeaks','LatePeaks')
       
    else
       fprintf('Continuing with the next subject\n');
    end

end
end                      