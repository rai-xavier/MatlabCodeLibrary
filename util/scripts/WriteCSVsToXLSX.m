dst = 'C:\wrk\Ripple\Deliverables\ToolsOutput ErrorTables NewError.xlsx';

%%
src = {};
src{1,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles\FullData Validation\OutputCSVs-NewError\ErrorTable.csv';
src{1,2} = 'InterpLabels-AbsError';
src{2,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles-Raw\FullData Validation\OutputCSVs-NewError\ErrorTable.csv';
src{2,2} = 'RawLabels-AbsError';
myfields = [ {'AvgAbsError'}    {'AvgPercentAbsError'}    {'FinalAbsError'}    {'AvgAbsErrorAccum1'}    {'AvgAbsErrorAccum2'}];
fn_fig = 'C:\wrk\Ripple\Deliverables\Box_AbsError.png';
%%
src = {};
src{1,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles\FullData Validation\OutputCSVs-NewError Raw\ErrorTable.csv';
src{1,2} = 'InterpLabels-RawError';
src{2,1} = 'C:\wrk\Ripple\Deliverables\SourceFiles-Raw\FullData Validation\OutputCSVs-NewError Raw\ErrorTable.csv';
src{2,2} = 'RawLabels-RawError';
myfields = [ {'AvgError'}    {'AvgPercentError'}    {'FinalError'}    {'AvgErrorAccum1'}    {'AvgErrorAccum2'}];
fn_fig = 'C:\wrk\Ripple\Deliverables\Box_RawError.png';
%%
plotdata = {};
for ii=1:length(src)
    T = readtable(src{ii});
%     if ii==1;plotdata{ff} = [];end
    for ff=1:length(myfields)
        plotdata{ff}{ii} = T.(myfields{ff});
        if ii==length(src);plotdata{ff} = cell2mat(plotdata{ff});end
    end

    [~,fn,~] = fileparts(src{ii,1});
    writetable(T,dst,'Sheet',src{ii,2});
end
%%
% close 1 2 3

dock;clf    
for ff=1:length(myfields)
    subplot(1,length(myfields),ff)
    boxplot(plotdata{ff})
    xticklabels(src(:,2))
    title(myfields{ff})
end
fullscreen(gcf)
saveas(gcf, fn_fig)
