
function ResultsTable = getClassifyResultsTable(HopperTable)
ResultsTable = struct;
AllFeats = HopperTable.Properties.RowNames;
AllTypes = HopperTable.Properties.VariableNames;
for jj=1:length(AllTypes)
    for kk=1:height(HopperTable)
        for mm=1:2
            switch mm
                case 1; train = 'Resub';
                case 2; train = 'KFold';
            end
            metrics = H.HopperModels.(AllTypes{jj})(kk).([train 'Metrics']);
            if isempty(metrics); continue ;end
            ResultsTable.Training(end+1,1) = train;
            ResultsTable.Feat(end,1) = AllFeats(kk);
            ResultsTable.(AllTypes{jj})(end,1) = metrics(4);
        end
    end
end
ResultsTable = struct2table(ResultsTable);
ResultsTable = sortrows(ResultsTable,AllTypes{1},'descend');
return
end