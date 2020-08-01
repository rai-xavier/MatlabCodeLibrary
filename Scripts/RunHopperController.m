ProcessIdentifier = 'DEBUG-h2go';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';
clc
%% jsonDir
% jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\New error\';
jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\duplicate-results\';
%% re-format json-init file

% file paths
src = 'jsonString.json';
jsonInitFilePathSrc = fullfile(jsonDir,src);
dst = strrep(src,'.json','_local.json');
jsonInitFilePathDst = fullfile(jsonDir,dst);

% replace w/ local directories
jsonInitData = ReadJson(jsonInitFilePathSrc);
jsonInitData = swapDirs(jsonInitData,jsonDir);
% newSampleRate = 332;
% jsonInitData.SampleRate = num2str(newSampleRate);
% jsonInitData.methodToUse = 'H_RESUB';
% jsonInitData.methodParameters = [1];
% jsonInitData.ResampleRate = num2str(166.5);
jsonInitData.ResampleRate = num2str(41.625);
jsonInitData.H_SAVE = true;

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
    [olddir,fn,ext] = fileparts(mypath);
    jsonCommand.(myfields{ff}) = fullfile(newdir, [fn ext]);
end
return
end