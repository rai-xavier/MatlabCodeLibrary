ProcessIdentifier = 'DEBUG';
pathToPoolProfile = '\\abyss1\active_projects\Hopper_Dev\dev-xavier\Hopper\Cloud_Cluster_Profile.settings';
clc
%% pathToJsonInit
% baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\11-19 Tools error';
% baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\11-23 model_path empty STILL';
baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\12-11 CalcFeatOptions';
pathToJsonCloud = fullfile(baseToolPath, 'jsonString.json');
pathToJsonLocal = fullfile(baseToolPath, 'jsonString_local.json');

%% re-write to local json
% json-data
jsonInitData = ReadJson(pathToJsonCloud);
jsonInitData = swapDirs(jsonInitData,baseToolPath);
% write dst
jsonInitString = jsonencode(jsonInitData);
fid = fopen(pathToJsonLocal,'w');
fwrite(fid, jsonInitString,'char');
fclose(fid);

%% format jsonCommand
jsonCommand = struct;
jsonCommand.MethodToUse = 'JSONINIT';
jsonCommand.MethodParameters = pathToJsonLocal;
jsonCommand = jsonencode(jsonCommand);
%% Run HopperController
diaryfile = strrep(pathToJsonLocal,'.json',['.log']);
if exist(diaryfile, 'file') == 2
    diary off
    fclose('all');
    delete(diaryfile);
end
diary(diaryfile)
diary on
HopperController(ProcessIdentifier, pathToPoolProfile, jsonCommand)
diary off
%% Inspect log/diary
if false
    hopperLogArray = ReadHopperLog(diaryfile);
    openvar('hopperLogArray')
    
    start_task =  hopperLogArray.Message( contains( hopperLogArray.Message, 'Executing JSON task') );
    % NumTasks = sum(start_task);
    
    NoiseValues = hopperLogArray.Value( contains( hopperLogArray.Message, 'Noise') );
    NoiseValues = cell2mat(NoiseValues);
    [NoiseValues,sortidx] = sort(NoiseValues);
    
    RESULT_TABLE =  hopperLogArray.Value( contains( hopperLogArray.MessageType, 'RESULT_TABLE') );
    
    Resub_Acc = cellfun(@(result_table) result_table.Resub_Acc, RESULT_TABLE);
    Resub_Acc = Resub_Acc(sortidx);
    
    
    dock
    plot(NoiseValues, Resub_Acc, '-*'); xticks( NoiseValues ); ylim([ 0 1]); ylabel('Resub Acc'); xlabel('NoiseValues')
    mytitle = split(baseToolPath,'\');
    mytitle = mytitle{end};
    title(mytitle)
end