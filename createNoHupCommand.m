NoHupScriptPath = fullfile(projectdir,'TrainNewSensorLocs.sh');
fid = fopen(NoHupScriptPath);
fopen(fid);
fwrite(fid, '#!/bin/bash','char');

SensorIdxs = {'M1','M2','M3','M4','M5','M6','M7','M8','A1','A2','A3','A4','A5'};
for i=1:length(SensorIdxs)
    command = createNoHupCommand('TrainOnNewSensorLocs',[SensorIdxs{i} '_4Prob'],'FailTypes',{'OD','ID','CHRG','MULTI'},'SensorIdxs',SensorIdxs{i});
    fwrite(fid, command,'char');
    fwrite(fid,'\n','char');
end
fclose(fid);

function command = createNoHupCommand(ScriptName,LogSuffix,varargin)
varnames = varargin(1:2:end);
varvals = varargin(2:2:end);

command = {};
command{end+1} = ['nohup matlab -r "'];
for i = 1:length(varnames)
    command{end+1} = char(strcat(varnames{i}, "={'", join(varvals{i},','), "'};"));
end
command{end+1} = ['try;' ScriptName ';catch ME; showstack(ME); exit;end'];
command{end+1} = ['> ' ScriptName '_' LogSuffix '.log &'];
%nohup matlab -r "FailTypes={'OD'}; TrainPhase=2; try;TrainOnPhase12Data_MonoChanBitDepth3;catch ME; showstack(ME); exit; end" > TrainOnPhase12Data_MonoChanBitDepth3_M10_OD_Ph2.log &
command = join(command,'');

return
end