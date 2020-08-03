ProcessIdentifier = 'DEBUG-h2go';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';
clc
%% jsonDir
% jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\New error\';
jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\duplicate-results\';
% jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\Rheem Test Data 1 OD_OK 1sec Subset 1000';
ResampleRates = [333,167,83,42];
%% re-format json-init file

% file paths
src = 'jsonString.json';
jsonInitFilePathSrc = fullfile(jsonDir,src);
dst = strrep(src,'.json','_local.json');
jsonInitFilePathDst = fullfile(jsonDir,dst);

% replace w/ local directories
jsonInitDataOrig = ReadJson(jsonInitFilePathSrc);
jsonInitDataOrig = swapDirs(jsonInitDataOrig,jsonDir);
% newSampleRate = 332;
% jsonInitData.SampleRate = num2str(newSampleRate);
% jsonInitData.methodToUse = 'H_RESUB';
% jsonInitData.methodParameters = [1];
% jsonInitData.ResampleRate = num2str(166.5);
% jsonInitData.ResampleRate = num2str(41.625);
% jsonInitData.H_SAVE = true;

% array for samplerate-curve
jsonInitDataArray = [];
for ii=1:length(ResampleRates)
    jsonInitDataNew = jsonInitDataOrig;
    jsonInitDataNew.SampleRate = num2str(ResampleRates(1));
    jsonInitDataNew.ResampleRate = num2str(ResampleRates(ii));
    
    jsonInitDataNew.NoiseType = "SNR";
%     jsonInitDataNew.NoiseValue = num2str(0.0001);
    jsonInitDataNew.NoiseValue = num2str(10000);
    
    jsonInitDataNew.featureNames = 'A1';
    jsonInitDataNew.modelNames = 'STA_LIN_OVO';
    
%     jsonInitDataNew.methodToUse = "H_RESUB";
%     jsonInitDataNew.methodParameters = [1];
    
    jsonInitDataNew.methodToUse = "H_KFOLD";
    jsonInitDataNew.methodParameters = [2,10,0,0];

    
    jsonInitDataArray = [jsonInitDataArray; jsonInitDataNew];
end

% write dst
jsonInitString = jsonencode(jsonInitDataArray);
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