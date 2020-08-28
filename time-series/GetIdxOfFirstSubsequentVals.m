function idx_first_subsequent_vals = GetIdxOfFirstSubsequentVals(locarray)
locarray=reshape(locarray,1,length(locarray));

% find all idxs of loc such that locarray(idx+1) = locarray(idx) + 1
mydiff = diff(locarray);
idx_subsequent_vals = find(mydiff==1)+1;
if isempty(idx_subsequent_vals)
    idx_first_subsequent_vals = 1;
    return
end
idx_subsequent_vals = [idx_subsequent_vals(1)-1,idx_subsequent_vals];
if all(diff(idx_subsequent_vals)==1)
    idx_first_subsequent_vals = idx_subsequent_vals;
else
    idx_idx = GetIdxOfFirstSubsequentVals(idx_subsequent_vals);
    idx_first_subsequent_vals = idx_subsequent_vals(idx_idx);
end
return
% single chain
if idx_subsequent_vals(end) == length(locarray)
    idx_first_subsequent_vals = idx_subsequent_vals;
    
% multiple chains
else
    % find idx of start of next chain of subsequent locs
    not_subsequent_subsequent = find(diff(idx_subsequent_vals)~=1)+1;
    first_not_subsequent_subsequent = not_subsequent_subsequent(1);
    
    % find idx of end of first chain of subsequent locs
    last_first_subsequent = first_not_subsequent_subsequent - 1;
    
    % return idxs of first chain of subsequent locs
    idx_first_subsequent_vals = idx_subsequent_vals(1:last_first_subsequent);
end


return
end