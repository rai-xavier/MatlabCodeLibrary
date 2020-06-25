
ModelFileName = '';

%% plot balance
DockFigure;
subplot(211);
    histogram(HLabels);
    xticks(unique(HLabels))
    xtickangle(45)
    ylabel('# Samples')
    title(['# Total Samples = ' num2str(length(HLabels))]);
subplot(212);
    histogram(HGroups,length(unique(HGroups)));
    xtickangle(45)
    ylabel('# Samples')
    title({'groups',['# groups = ' num2str(length(unique(HGroups)))]})
sgtitle('')

%% load model
load(ModelFileName)

%% Predict
HData = FEATURE_EXTRACTOR([],'A1',HData,[],[]);
HData = HData.NODR{1,1}.FeatureData  ;
P = predict(H.HopperModels.STA_LIN_OVO(1,1).BaseModel, HData);

%% plot confmat
CM = confusionmat(HLabels,P);
plotConfusionMatrix(CM,labelmap)
title('')

%% Group-wise Accuracy
uGroups = unique(HGroups);
GroupAccuracies = [];
for ii=1:length(uGroups)
    idx_group = HGroups == uGroups(ii);
    CM = confusionmat(HLabels(idx_group),P(idx_group));
    CM_METRICS = GET_CM_METRICS(CM);
    GroupAccuracies(ii) = CM_METRICS(1);
end
DockFigure
histogram(GroupAccuracies)
title('')