%% paths
thisfn = strrep(HopperModelFileName, '.mat','');
feature_string = HopperBaseModel.ModelInfo.FeatureName  ;
thisfn = [thisfn '_' feature_string];
KFoldCMPath = [thisfn '_KFoldConfusionMat.png'];
KFoldMetricsPath = [thisfn '_KFoldMetrics.mat'];

%% KFold CM
KFoldConfusionMat = HopperBaseModel.KFoldConfusionMat;
plotConfusionMatrix(KFoldConfusionMat, labelmap);
SetCMtoRAIcolors
[~,mytitle,~] = fileparts(thisfn);
mytitle = strrep(mytitle,'_','-');
title(mytitle)
saveas(gcf, KFoldCMPath)
close('all')

%% KFoldMetrics -- Classify
KFoldMetrics = HopperBaseModel.KFoldMetrics;

ResultsTable = struct;
AllFeats = H.HopperModels.Properties.RowNames;
AllTypes = H.HopperModels.Properties.VariableNames;
sz = size(H.HopperModels);
for jj=1:length(AllTypes)
    for kk=1:height(H.HopperModels)
        ResultsTable.Feat(kk,1) = AllFeats(kk);
        ResultsTable.(AllTypes{jj})(kk,1) = H.HopperModels.(AllTypes{jj})(kk).ResubMetrics(4);
    end
end
ResultsTable = struct2table(ResultsTable);
writetable(ResultsTable, ResubTableFileName);

%% KfoldMetrics -- Regression
       ResultsTable = struct;
    AllFeats = H.HopperModels.Properties.RowNames;
    AllTypes = H.HopperModels.Properties.VariableNames;
    MetricsVars = {'RSquared','RMSE','MeanAbsError','MaxAbsPercentError','MeanAbsPercentError'};
    sz = size(H.HopperModels);
    for jj=1:length(AllTypes)
        for kk=1:height(H.HopperModels)
            ResultsTable(end+1,1).Feat = AllFeats(kk);
            ResultsTable(end,1).Model = AllTypes{jj};
            Metrics = H.HopperModels.(AllTypes{jj})(kk).KFoldMetrics;
            for mm=1:length(MetricsVars)
                ResultsTable(end,1).(MetricsVars{mm}) = Metrics(mm);
            end
        end
    end
    ResultsTable(1,:) = [];
    ResultsTable = struct2table(ResultsTable);
    ResultsTable = sortrows(ResultsTable,'MeanAbsPercentError','ascend');
    writetable(ResultsTable, KFoldTableFileName);


%% Marginals
Recall = [];
Precision = [];
F1 = [];
for kk=1:length(labelmap)
    TP = KFoldConfusionMat(kk,kk);
    Recall(kk) = round(100* (TP / sum(KFoldConfusionMat(:,kk))), 2);
    Precision(kk) = round(100* (TP / sum(KFoldConfusionMat(kk,:))), 2);
    F1(kk) = 2*Recall(kk)*Precision(kk) / ( Recall(kk) + Precision(kk) );
end

%% Save KFoldMetrics + Marginals
save(KFoldMetricsPath, 'KFoldMetrics', 'labelmap', 'Recall', 'Precision', 'F1');