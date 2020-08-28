function [ClosestNonZeroVal,ClosestNonZeroLoc] = FindNearestNonZeroValue( ValArray, Locs )

NonZeroValLocs = find(logical(ValArray));
ClosestNonZeroVal = [];
for i=1:length(Locs)
    ClosestNonZeroLoc(i,1) = FindClosestVal(NonZeroValLocs,Locs(i));
    ClosestNonZeroVal(i,1) = ValArray(ClosestNonZeroLoc(i));
end

return
end