counter = diff(floor(SourceFile.HallCount));
counter_locs = find(logical(counter));
counter_spaces = diff(counter_locs);
counter_locs = [0;counter_locs];

for j =2 : (length(counter_locs)-1)
    
    leftbound = counter_locs(j-1)+1;
    midpt = counter_locs(j);
    rightbound = counter_locs(j+1)-1;
    
    leftbin = [ leftbound midpt];
    rightbin = [ midpt rightbound ];
    
    margin=0.25;
    istart = ceil(margin*range(leftbin) + leftbound);
    istop = floor(rightbound - margin*range(rightbin));
    if (istart-istop+1) >= WinSz; continue ;end
    
    % channel data
    rawseg={};
    rawseg{1} = SourceFile.Volt(istart:istop);
    rawseg{2} = SourceFile.Amp(istart:istop);
    HData{end+1,1} = window_data(rawseg{1},WinSz,StepSz);
    HData{end,2} = window_data(rawseg{2},WinSz,StepSz);
    
    % peak count label
    timeidx = window_data(istart:istop,WinSz,StepSz);
    counterlogical = logical(sum(timeidx == midpt,2));
    counterlabel = zeros(length(counterlogical),1);
    counterlabel(counterlogical) = counter(midpt);
    HLabels{end+1,1} = counterlabel;
    if not(length(counterlabel) == size(HData{end,1}))
        error('numwin mismatch')
    end
    HGroups{end+1,1} = repmat(fn,length(counterlabel),1);
end