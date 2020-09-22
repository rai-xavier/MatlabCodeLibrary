
function command = createNoHupCommand(ScriptName,LogSuffix,varargin)
varnames = varargin(1:2:end);
varvals = varargin(2:2:end);

command = {};
command{end+1} = ['nohup matlab -r "'];
for i = 1:length(varnames)
    if iscell(varvals{i}) || ischar(varvals{i})
        command{end+1} = char(strcat(varnames{i}, "={'", join(varvals{i},"','"), "'};"));
    elseif isnumeric(varvals{i})
        if length(varvals{i})==1
            command{end+1} = char(strcat(varnames{i}, "=", num2str(varvals{i}),";"));
        else
            command{end+1} = char(strcat(varnames{i}, "=[", num2str(varvals{i}),"];"));
        end
    else; error(['function not defined for datatype: ' class(varvals{i})]);
    end
end
command{end+1} = ['try;' ScriptName ';catch ME; showstack(ME); exit;end"  '];
command{end+1} = ['> ' ScriptName '-' LogSuffix '.log &'];
%nohup matlab -r "FailTypes={'OD'}; TrainPhase=2; try;TrainOnPhase12Data_MonoChanBitDepth3;catch ME; showstack(ME); exit; end" > TrainOnPhase12Data_MonoChanBitDepth3_M10_OD_Ph2.log &
command = char(join(command,''));

return
end