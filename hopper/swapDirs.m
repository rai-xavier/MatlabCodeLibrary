function jsonCommand = swapDirs(jsonCommand,newdir)
myfields = {'pathToIndexCSV','pathToData','forPrediction','baseToolPath'};
for ff=1:length(myfields)
    if not(isfield(jsonCommand, myfields{ff}));continue;end
    mypath = jsonCommand.(myfields{ff});
    if isempty(mypath); continue; end
    [olddir,fn,ext] = fileparts(mypath);
    jsonCommand.(myfields{ff}) = fullfile(newdir, [fn ext]);
end
return
end