%% Subset Data
[hdata,edges] = histcounts(HLabels,6);
HLabelsDscrt = discretize(HLabels,edges);

% HLabels: discrete classes
hdatanorm = histcounts(HLabels)/max(hdata);
uLabels = unique(HLabels);
SubsetIdx = {};
for jj=1:length(uLabels)
    idx_class = HLabels == uLabels(jj);
    idx_class = find(idx_class);
    idx_subset = randperm(length(idx_class),round(SubsetProportion*length(idx_class)));
    idx_class_subset = idx_class(idx_subset);
    SubsetIdx{end+1,1} = idx_class_subset;
end
SubsetIdx = cell2mat(SubsetIdx);
HData = cellfun(@(x) x(SubsetIdx,:),HData,'UniformOutput',false);
HLabels = HLabels(SubsetIdx);