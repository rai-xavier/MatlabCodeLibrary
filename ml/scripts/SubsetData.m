%% RMS
dock('ClassRMS'); clf
NumBins = 20;
MinRMSBin = 2;
SubsetIdx = [];
for n = 1 : length(ClassMap)
    % subset class
    classidx = find(HLabels == n);
    % calculate rms
    ClassRMS = cellfun(@(x) rms(x(classidx,:),2), HData, 'UniformOutput',false);
    % plot histogram
    subplot(4,2,n)
    h = histogram(ClassRMS{1},NumBins);
    xline(mean(ClassRMS{1}),'k')
    title(ClassMap{n})
    xlabel('RMS')
    ylabel('# windows')
    % subset using rms-distribution
    binedges = h.BinEdges(2:end);
    binedges = binedges(logical(h.Values));
    MinRMS = binedges(MinRMSBin);
    xline(MinRMS,'r')
    classminrmsidx = ClassRMS{1} >= MinRMS;
    SubsetIdx = [SubsetIdx;classidx(classminrmsidx)];
    disp('')
end

%% Class (maintain class balance)
SubsetIdx = SubsetMaintainBalance(IDCol,SubsetVal);
HData = cellfun(@(x) x(SubsetIdx,:),HData,'UniformOutput',false);
HLabels = HLabels(SubsetIdx);

%% Regression (maintain class balance)

% discretize
numbins = 6;
[hdata,edges] = histcounts(HLabels,numbins);
HLabelsDscrt = discretize(HLabels,edges);

% same proportion of each bin
SubsetProportion = 0.3;
uLabels = unique(HLabelsDscrt);
SubsetIdx = {};
for jj=1:length(uLabels)
    idx_class = HLabelsDscrt == uLabels(jj);
    idx_class = find(idx_class);
    idx_subset = randperm(length(idx_class),round(SubsetProportion*length(idx_class)));
    idx_class_subset = idx_class(idx_subset);
    SubsetIdx{end+1,1} = idx_class_subset;
end
SubsetIdx = cell2mat(SubsetIdx);
HData = cellfun(@(x) x(SubsetIdx,:),HData,'UniformOutput',false);
HLabels = HLabels(SubsetIdx);
HGroups = HGroups(SubsetIdx);

%% Class (equally balanced groups)
TotalNumSamples = 7000;
NumGroups = length(GroupMap);
NumOfEachClassFromEachGroup = round( TotalNumSamples / NumGroups );

[HData,HGroupsExt,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HGroupsExt, NumOfEachClassFromEachGroup);
HGroups = HGroups(SubsetIdx);
HLabels = HLabels(SubsetIdx);