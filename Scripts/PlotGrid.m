dock
%%
NumRows = 3;
NumCols = 4;
for r = 1:NumRows
    for c=1:NumCols
        plotnum = (r-1)*NumCols + c;
        disp([r,c,plotnum])
        continue
        subplot(NumRows,NumCols,plotnum)
        title(plotnum)
    end
end