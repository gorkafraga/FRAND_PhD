tmp_data = zeros(70,525,311);
tmp_data = EEG.data;

ref=(tmp_data(69,:,:) + tmp_data(70,:,:))/2;
for i=1:2
    ref=[ref; ref; ref; ref; ref; ref; ref; ref];
end

flat=tmp_data(1:64,:,:)-ref;

tmp_data(1:64,:,:) =flat;

EEG.data = tmp_data;
