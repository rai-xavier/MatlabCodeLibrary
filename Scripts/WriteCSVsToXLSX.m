src = {};
src{1,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles\FullData Validation\OutputCSVs\ErrorTable.csv';
src{1,2} = 'Interp';
src{2,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles-Raw\FullData Validation\OutputCSVs\ErrorTable.csv';
src{2,2} = 'Raw';
dst = 'C:\wrk\Ripple\Deliverables\ToolsOutput ErrorTables.xlsx';
for ii=1:length(src)
    T = readtable(src{ii});
    x1(:,ii) = T.AvgAbsError;
    x2(:,ii) = T.AvgPercentAbsError;
    x3(:,ii) = T.FinalAbsError;
    [~,fn,~] = fileparts(src{ii,1});
    writetable(T,dst,'Sheet',src{ii,2});
end
%%
% close 1 2 3
figure(1);clf
boxplot(x1)
xticklabels(src(:,2))
title('AvgAbsError')
saveas(gcf, 'C:\wrk\Ripple\Deliverables\Box_AvgAbsError.png')

figure(2);clf
boxplot(x2)
xticklabels(src(:,2))
title('AvgPercentAbsError')
saveas(gcf, 'C:\wrk\Ripple\Deliverables\Box_AvgPercentAbsError.png')

figure(3);clf
boxplot(x2)
xticklabels(src(:,2))
title('FinalAbsError')
saveas(gcf, 'C:\wrk\Ripple\Deliverables\Box_FinaltAbsError.png')

