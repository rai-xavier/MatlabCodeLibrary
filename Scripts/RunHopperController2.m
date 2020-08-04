ProcessIdentifier = 'DEBUG-SENSORSPEC';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';
clc
%% jsonDir
jsonDir = 'C:\wrk\dev-xavier\debug\8-4 SensorSpec';
%% re-format json-init file

% file paths
src = 'jsonString.json';
jsonInitFilePathSrc = fullfile(jsonDir,src);
dst = strrep(src,'.json','_local.json');
jsonInitFilePathDst = fullfile(jsonDir,dst);

% replace w/ local directories
jsonInitData = ReadJson(jsonInitFilePathSrc);
jsonInitData = swapDirs(jsonInitData,jsonDir);

% write dst
jsonInitString = jsonencode(jsonInitData);
fid = fopen(jsonInitFilePathDst,'w');
fwrite(fid, jsonInitString,'char');
fclose(fid);

%% format HC JsonCommand 

jsonCommand = struct;
jsonCommand.MethodToUse = 'JSONINIT';
jsonCommand.MethodParameters = jsonInitFilePathDst;
jsonCommand = jsonencode(jsonCommand);

%% Run Hopperconotroller
HopperController(ProcessIdentifier, pathToPoolProfile, jsonCommand)

%%
function jsonCommand = swapDirs(jsonCommand,newdir)
myfields = {'pathToIndexCSV','pathToData','forPrediction','baseToolPath'};
for ff=1:length(myfields)
    mypath = jsonCommand.(myfields{ff});
    if isempty(mypath); continue; end
    [olddir,fn,ext] = fileparts(mypath);
    jsonCommand.(myfields{ff}) = fullfile(newdir, [fn ext]);
end
return
end