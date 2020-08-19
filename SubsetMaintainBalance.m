function IdxSubset=SubsetMaintainBalance(IDCol,SubsetVal)
% maintain relative proportions of each unique ID in IDCol
% if SubsetVal<1, subset amount using proportion 
% if SubsetVal>1, ID's are sub-classes and SubsetVal = final tally of super-class
rng(0) 

UIDs = unique(IDCol);
NumIDs = length(UIDs);
IdxSubset = {};
for jj=1:length(UIDs)
    % logical
    IdxUID = IDCol == UIDs(jj); 
    
    % idx nums
    IdxUID = find(IdxUID); 
    TotalNumFromThisID = length(IdxUID);

    % how many from this ID to keep?
    if SubsetVal<1 % same proportion of each ID
        SubsetNumFromThisID = round( SubsetVal * TotalNumFromThisID );
    elseif SubsetVal>1 % divide super-class tally over ID's in col
        error('not for this funcn')
        SubsetNumFromThisID = round( SubsetVal / NumIDs );
        SubsetNumFromThisID = min([SubsetNumFromThisID,TotalNumFromThisID]);
    end
    
    % idxs of idxs to keep
    IdxUIDSubset = randperm(TotalNumFromThisID,SubsetNumFromThisID);
    
    % subset uid idxs
    IdxSubset{end+1,1} = IdxUID(IdxUIDSubset);
end
idx_empty = cellfun(@isempty,IdxSubset);
IdxSubset(idx_empty)=[];
IdxSubset = cell2mat(IdxSubset);
return
end