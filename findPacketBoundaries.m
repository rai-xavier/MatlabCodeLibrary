function packetBoundaries = findPacketBoundaries(logicalSeries)
if isRowVector(logicalSeries)
    logicalSeries = logicalSeries';
end

    
eventIdxs = find(logical(logicalSeries));
% eventIdxs = logicalSeries;
if isempty(eventIdxs)
    packetBoundaries = [];
    return
end

eventIdxsDiff = diff(eventIdxs) ;

stopPts = find(eventIdxsDiff > 1);
packetStopIdxs = [stopPts; length(eventIdxs)];

startPts = find(eventIdxsDiff > 1) + 1;
packetStartIdxs = [1; startPts];

packetBoundaries = [eventIdxs(packetStartIdxs), eventIdxs(packetStopIdxs)];

end

function flag = isRowVector(myarray)
    flag = size(myarray,1)==1 && size(myarray,2) >= 1;
end