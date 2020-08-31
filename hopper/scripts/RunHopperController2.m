ProcessIdentifier = 'DEBUG-SENSORSPEC';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';
clc
%% jsonDir
% jsonDir = 'C:\wrk\dev-xavier\debug\8-4 SensorSpec';
% jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\duplicate-results-2'; ResampleRate = 167; src = 'jsonString.json';
% jsonDir = 'C:\wrk\dev-xavier\debug\8-5 SensorSpec UpwardCurve\5f2b2a3d2377af42cc83475c'; 
% src = 'jsonArray.json'; 
% ModelName = '5f11992226537326b157ebc2jsonString17_200717133456_STA_LIN_OVO_C5.mat';

jsonDir = 'C:\wrk\dev-xavier\debug\8-11 SensorSpec stderr bug';
src = 'jsonString.json'; 
%% re-format json-init file

% file paths
jsonInitFilePathSrc = fullfile(jsonDir,src);
dst = strrep(src,'.json','_local.json');
jsonInitFilePathDst = fullfile(jsonDir,dst);

% replace w/ local directories
jsonInitData = ReadJson(jsonInitFilePathSrc);
for i = 1:size(jsonInitData,1)
    jsonInitData(i) = swapDirs(jsonInitData(i),jsonDir);
    
    % jsonInitData.ResampleRate = num2str(ResampleRate);
    
%     jsonInitData(i).NoiseType = 'SNR';
%     jsonInitData(i).NoiseValue = num2str(2);

%     jsonInitData(i).forPrediction = fullfile(jsonDir, ModelName);
%     jsonInitData(i).methodToUse = "H_RESUB";
%     jsonInitData(i).methodParameters = [1];
    jsonInitData(i).dumpFlag = true;
end

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

%% Run HopperController
diaryfile = strrep(jsonInitFilePathDst,'.json','_2.log');

diary(diaryfile)
diary on
HopperController(ProcessIdentifier, pathToPoolProfile, jsonCommand)
diary off

%% Inspect log/diary
hopperLogArray = ReadHopperLog(diaryfile);
openvar('hopperLogArray')

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