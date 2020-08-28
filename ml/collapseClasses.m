function collpased_op = collapseClasses(MappingCell, ip)
collpased_op = nan(length(ip),1);
for i = 1: size(MappingCell,1)
    collpased_op(ismember(ip, MappingCell{i,2} )) = MappingCell{i,1};
end
end