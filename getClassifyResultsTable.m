
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
            ResultsTable.Feat(rowidx,1) = AllFeats(kk);
            ResultsTable.(AllTypes{jj})(rowidx,1) = metrics(4);
            rowidx=rowidx+1;
        end
    end
end
ResultsTable = struct2table(ResultsTable);
ResultsTable = sortrows(ResultsTable,AllTypes{1},'descend');
return
end