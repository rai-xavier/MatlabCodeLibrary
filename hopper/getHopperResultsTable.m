function ResultsTable = getHopperResultsTable(HopperTable)

ResultsTable = struct; rowidx=1;
AllFeats = HopperTable.Properties.RowNames;
AllTypes = HopperTable.Properties.VariableNames;
for jj=1:length(AllTypes)
    for kk=1:height(HopperTable)
        for mm=1:2
		   switch mm
                case 1; train = 'Resub';
                case 2; train = 'KFold';
            end
			HSVM = HopperTable.(AllTypes{jj})(kk);
            Metrics = HSVM.([train 'Metrics']);
            if isempty(Metrics); continue ;end
            ResultsTable.Training(rowidx,1) = {train};
            ResultsTable.ModelType(rowidx,1) = AllTypes(jj);
            ResultsTable.Feat(rowidx,1) = AllFeats(kk);
            ResultsTable.WinSz(rowidx,1) = HSVM.ModelInfo.WindowSize;
			if contains(AllTypes{jj},'REG')
				MetricsVars = {'RSquared','RMSE','MeanAbsError','MaxAbsPercentError','MeanAbsPercentError'};
			else
				MetricsVars = {'Accuracy'};
			end
            for nn=1:length(MetricsVars)
                ResultsTable(end,1).(MetricsVars{nn}) = Metrics(nn);
            end
			rowidx=rowidx+1;
        end
    end
end
ResultsTable = struct2table(ResultsTable);
ResultsTable = sortrows(ResultsTable,MetricsVars{1},'ascend');
return
end