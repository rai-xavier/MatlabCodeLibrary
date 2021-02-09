
function ResultsTable = getClassifyResultsTable(HopperTable)

ResultsTable = struct;rowidx=1;
AllFeats = HopperTable.Properties.RowNames;
AllTypes = HopperTable.Properties.VariableNames;
for jj=1:length(AllTypes)
    for kk=1:height(HopperTable)
        for mm=1:2
            switch mm
                case 1; train = 'Resub';
                case 2; train = 'KFold';
            end
            metrics = HopperTable.(AllTypes{jj})(kk).([train 'Metrics']);
            if isempty(metrics); continue ;end
            ResultsTable.Training(rowidx,1) = {train};
            ResultsTable.ModelType(rowidx,1) = AllTypes(jj);
            ResultsTable.Feat(rowidx,1) = AllFeats(kk);
            ResultsTable.WinSz(rowidx,1) = HopperTable.(AllTypes{jj})(kk).ModelInfo.WindowSize;
            ResultsTable.Accuracy(rowidx,1) = {metrics(1)};
            rowidx=rowidx+1;
        end
    end
end
ResultsTable = struct2table(ResultsTable);
ResultsTable = sortrows(ResultsTable,'Accuracy','descend');
return
end
