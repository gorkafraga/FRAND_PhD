counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=21;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=24;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=22;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=23;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=22;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=23;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=21;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
        break;
    end
end
counter=0;
for i=1:length(EEG.urevent)
    if counter<40
        if EEG.urevent(i).type==61461
            EEG.urevent(i).type=24;
            counter=counter+1;
        elseif EEG.urevent(i).type>100
            EEG.urevent(i).type=12;    
        end
    else
       EEG.urevent(i).type=12; 
    end
end


for e = 1:length(EEG.epoch),
   
    for i = 1:length(EEG.epoch(e).eventtype)
        uri = EEG.epoch(e).eventurevent(i);
        EEG.epoch(e).eventtype(i) = {EEG.urevent(uri{1}).type}; 
    end
end

for e = 1:length(EEG.event),
    uri = EEG.event(e).urevent;
    EEG.event(e).type = EEG.urevent(uri).type(1); 
end