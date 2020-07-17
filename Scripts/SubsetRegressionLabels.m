numbins = 6;
SubsetProportion = 0.3;
[hdata,edges] = histcounts(HLabels,numbins);
hdatanorm = hdata/max(hdata);
HLabelsDscrt = discretize(HLabels,edges);
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