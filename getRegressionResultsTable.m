function ResultsTable = getRegressionResultsTable(HopperTable)

ResultsTable = struct;
AllFeats = HopperTable.Properties.RowNames;
AllTypes = HopperTable.Properties.VariableNames;
MetricsVars = {'RSquared','RMSE','MeanAbsError','MaxAbsPercentError','MeanAbsPercentError'};
for jj=1:length(AllTypes)
    for kk=1:height(H.HopperModels)
        for mm=1:2
            switch mm
                case 1; train = 'Resub';
                case 2; train = 'KFold';
            end
            metrics = H.HopperModels.(AllTypes{jj})(kk).([train 'Metrics']);
            if isempty(metrics);continue;end
            ResultsTable.Training(end+1,1) = train;
            ResultsTable.Feat(end,1) = AllFeats(kk);
            for nn=1:length(MetricsVars)
                ResultsTable(end,1).(MetricsVars{nn}) = Metrics(nn);
            end
        end
    end
end
ResultsTable(1,:) = [];
ResultsTable = struct2table(ResultsTable);
ResultsTable = sortrows(ResultsTable,'MeanAbsPercentError','ascend');
return
end