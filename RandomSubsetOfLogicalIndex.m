function idx_random_subset = RandomSubsetOfLogicalIndex(mylogical,proportion)
    myidxs = find(mylogical);
    num_total = length(myidxs);
    num_random = round(proportion * num_total);
    rand_perm_idx = randperm(num_total,num_random);
    idx_random_subset = myidxs(rand_perm_idx);
end