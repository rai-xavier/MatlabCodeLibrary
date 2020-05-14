function packetBoundaries = findPacketBoundaries2(indexSeries)

% eventIdxs = find(logical(categoricalSeries));
eventIdxs = indexSeries;
if isempty(eventIdxs)
    packetBoundaries = [];
    return
end
eventIdxsDiff = diff(eventIdxs) ;
stopPts = find(eventIdxsDiff > 1);
startPts = find(eventIdxsDiff > 1) + 1;
packetStartIdxs = [1; startPts];
packetStopIdxs = [stopPts; length(eventIdxs)];
packetBoundaries = [eventIdxs(packetStartIdxs), eventIdxs(packetStopIdxs)];

end