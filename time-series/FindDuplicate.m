function [DuplicateVal, IdxDup] = FindDuplicate(myarray)
% uvals = unique(myarray);
[mygrp,grpmap] = grp2idx(myarray);
nbins = length(grpmap);
idx_dup = histcounts(mygrp,nbins)>1;
DuplicateVal = grpmap(idx_dup);
if isnumeric(myarray)
    IdxDup = myarray == DuplicateVal;
else
    IdxDup = find(ismember(myarray,DuplicateVal));
end
return
end