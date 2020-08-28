
RunningCounterTotal = cumsum(CounterPacket);
RunningPeakTotal = cumsum(PeakCounter);
CounterPacketLocs = find(CounterPacket);
PeakLocs = find(PeakCounter);

%%
loop = [];
xstop = 0.53-80/20e3;
while isempty(loop)
    
    xstart = xstop;
    delta = 240/20e3;
    xstop = xstart + delta;
    
    
    t = find( TimePacket <= xstop & TimePacket >= xstart );
    pks = intersect( t+1 , PeakLocs );
    cts = intersect( t  , CounterPacketLocs );
    
    % view packet
    dock(1,'PeaksVsCounts')
    clf
    NumRows = 2; NumCols = 2;
    for plotnum = 1 : NumRows*NumCols
        subplot(NumRows,NumCols,plotnum);
        hold on;
        plot(TimePacket(t),RunningCounterTotal(t));
        plot(TimePacket(t(2:end)),RunningPeakTotal(t(2:end)));
        for n=1:length(pks); xline(TimePacket(pks(n)),'g','HandleVisibility',handleviz(n)); end
        for n=1:length(cts); xline(TimePacket(cts(n)),'k','HandleVisibility',handleviz(n)); end
        mylgd = {'RunningCounterTotal','RunningPeakTotal','Peak','Count'};
        yyaxis right;
        switch plotnum
            case 1
                title('Volt')
                plot(TimePacket(t),VoltPacket(t));
                mylgd{end+1} = 'Volt';
            case 2
                title('Amp')
                plot(TimePacket(t),AmpPacket(t));
                mylgd{end+1} = 'Amp';
            case 3
                title('VoltDemin')
                plot(TimePacket(t),VDeminPacket(t));
                mylgd{end+1} = 'VoltDemin';
            case 4
                title('AmpDemin')
                plot(TimePacket(t),ADeminPacket(t));
                mylgd{end+1} = 'AmpDemin';
        end
        legend(mylgd,'Orientation','horizontal','Location','southoutside')
        xlim([xstart xstop]);
    end
    
    loop = input('continue?');
end