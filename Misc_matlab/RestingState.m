    % Get event types
    e = squeeze(struct2cell(EEG.urevent));
    typev = cell2mat(e(1,:));
    E = unique(typev);
    known = [61444,61454,61464,61465,61482,61483,61500,61504,61506,61510,61539]; 
    temp = cell(length(known),1);
    for L=1:length(known)
     temp{L} = find(typev==known(L), 1 );
    end
    unknown = typev(1:min(cell2mat(temp))-1); % "unknown" events are all before the experiment start
    t = eeg_point2lat([EEG.event.latency],[],[EEG.srate],[EEG.xmin EEG.xmax]*1000);% all data points converted to seconds
    minsUnknown = t(1:length(unknown))/60; %latencies in minutes of unknown events
    elapsed = diff(minsUnknown); % times(minutes) between two 2 consecutive events
    maxTime = max(diff(minsUnknown));% max difference
    overtwo = elapsed(elapsed>2); % more than 2 minutes between events
    %%% 
    x = minsUnknown(elapsed==max(elapsed)); % LATENCY in minutes of target unknown event(the one followed by 2 minutes before other event)
    xevent= EEG.event(elapsed==max(elapsed)); %full event information


%%%%% Some preprocessing
        %Remove last 2 external (ext 7&8) electrodes 
        EEG = pop_select (EEG, 'channel', 1:70); 
        %Load the channel locations file, specify BESA coordinates 
        EEG = pop_chanedit(EEG,'load','Z:\fraga\EEG_Gorka\Analysis_EEGlab11\channelsThetaPhi-2extRemoved.elp','besa'); 
        %Downsample to 256 Hz 
        EEG = pop_resample(EEG, 256);
% EPOCHING
        EEG.event([xevent.urevent]).type = '666';    % rename target event so it's unique (it usually appears repeated)
        EEG = pop_epoch(EEG, { '666' }, [0 120]);
        %--------------------------------------------------
        %Basic FIR filter ---> Bandpass filter, first lowpass then highpass filter
        %Lowpass filter - keeps data under 70 Hz
          EEG = pop_eegfilt( EEG, 0, 30);
        % %Highpass filter - keeps data above 1 Hz (takes long time)
         EEG = pop_eegfilt( EEG, 1, 0);

        
