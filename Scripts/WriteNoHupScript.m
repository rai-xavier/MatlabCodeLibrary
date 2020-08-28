
%% TrainNewSensorLocs.sh
if false
    projectdir = 'C:\wrk\Rheem\Phase 2 Analysis';
    NoHupScriptPath = fullfile(projectdir,'TrainNewSensorLocs.sh');
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    SensorIdxs = {'M1','M2','M3','M4','M5','M6','M7','M8','A1','A2','A3','A4','A5'};
    for i=1:length(SensorIdxs)
        command = createNoHupCommand('TrainOnNewSensorLocs',[SensorIdxs{i} '_4Prob'],'FailTypes',{'OD','ID','CHRG','MULTI'},'SensorIdxs',SensorIdxs{i});
        fwrite(fid, command,'char');
        fwrite(fid,newline,'char');
    end
    fclose(fid);
end

%% TrainInt8DS.sh
if false
    projectdir = 'C:\wrk\Rheem\Phase 2 Analysis';
    NoHupScriptPath = fullfile(projectdir,'TrainInt16DS.sh');
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    FailTypes = {'OD','ID','CHRG','MULTI'};
    BitDepthNew = 16;
    for i=1:length(FailTypes)
        command = createNoHupCommand('TrainOnPhase12Data_MonoChanBitDepth3',[FailTypes{i} '_int' num2str(BitDepthNew)],'FailTypes',FailTypes(i),'BitDepthNew',BitDepthNew);
        fwrite(fid, command,'char');
        fwrite(fid,newline,'char');
    end
    fclose(fid);
end

%% 1HzPlusMicWinLoop.sh
if false
    projectdir = 'C:\wrk\Rheem';
    NoHupScriptPath = fullfile(projectdir,'1HzPlusMicWinLoop.sh');
    MatlabScriptName = 'TrainIndoorHoldoutPartition2Class_1HzPlusMic_WinLoopV3';
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    HoldoutNums = 1:5;
    FailTypes = {'OD','ID','CHRG'};
    MicNums = [1]; %4
    
    for f=1:length(FailTypes)
        for h=1:length(HoldoutNums)
            for m=1:length(MicNums)
                command = createNoHupCommand(MatlabScriptName,...
                    ['P' num2str(HoldoutNums(h)) '-' FailTypes{f} '-M' num2str(MicNums)],...
                    'FailTypes',FailTypes(f),...
                    'HoldoutNums',HoldoutNums(h),...
                    'MicNums',MicNums(m)...
                    );
                fwrite(fid, command,'char');
                fwrite(fid,newline,'char');
            end
        end
    end
    fclose(fid);
end

%% MicPlusMicWinLoop.sh
if false
    projectdir = 'C:\wrk\Rheem';
    NoHupScriptPath = fullfile(projectdir,'MicPlusMicWinLoop.sh');
    MatlabScriptName = 'TrainIndoorHoldoutPartition2Class_1HzPlusMic_WinLoopV4';
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    HoldoutNums = 1:5;
    % FailTypes = {'OD','ID','CHRG'};
    FailTypes = {'OD'};
    MicNums = [1]; %4
    
    for f=1:length(FailTypes)
        %     for h=1:length(HoldoutNums)
        for m=1:length(MicNums)
            for w=1:5
                command = createNoHupCommand(MatlabScriptName,...
                    [FailTypes{f} '-M' num2str(MicNums) '-W' num2str(w)],...
                    'FailTypes',FailTypes(f),...
                    'HoldoutNums',flip(HoldoutNums),...
                    'MicNums',MicNums(m),...
                    'WIndex',w...
                    );
                fwrite(fid, command,'char');
                fwrite(fid,newline,'char');
            end
        end
        %     end
    end
    fclose(fid);
end

%% runHallCounterTrainTrainOnVoltSpikes.sh
if false
    projectdir = 'C:\wrk\Ripple\Deliverables\HallCounter';
    MatlabScriptName = 'HallCounterTrainOnVoltSpikes';
    NoHupScriptPath = fullfile(projectdir,['run' MatlabScriptName '.sh']);
    if exist(NoHupScriptPath); delete(NoHupScriptPath); end
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    WinSzs = 10:5:40;
    A = split('A1 A2 A3 A4 A5 A6',' ');
    BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
    C = split('C1 C2 C3 C4 C5',' ');
    BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
    FeatureSpaces = [A;BA;C;BC]';
    
    for w=1:length(WinSzs)
        command = createNoHupCommand(MatlabScriptName,...
            ['W' num2str(WinSzs(w))],...
            'WinSzs',WinSzs(w),...
            'FeatSpace',FeatureSpaces...
            );
        fwrite(fid, command,'char');
        fwrite(fid,newline,'char');
    end
    fclose(fid);
    open(NoHupScriptPath)
end

%% runTrainPairwisePartitions.sh
if false
    projectdir = 'C:\wrk\Rheem\Phase 1 Analysis';
    MatlabScriptName = 'TrainPairwisePartitions';
    NoHupScriptPath = fullfile(projectdir,['run' MatlabScriptName '.sh']);
    if exist(NoHupScriptPath); delete(NoHupScriptPath); end
    disp(['Writing ' NoHupScriptPath ])
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    % SensorIdxs = {'M1','M4','A1','A4'}; % compr shell + fan motor
    SensorIdxs = {'M1','M4'};
    
    % FailTypes = {'OD','ID','CHRG','MULTI'};
    FailTypes = {'ID','CHRG'};
    
    PartitionNum=6;
    % WIndex = 1:5;
    WIndex = 5;
    
    NumCombos = 220;
    NumComboPartitions = 5;
    ComboPartitions = linspace(1,NumCombos,NumComboPartitions+1);
    
    for s=1:length(SensorIdxs)
        for f =1:length(FailTypes)
            for w=1:length(WIndex)
                for c=1:NumComboPartitions
                    command = createNoHupCommand(MatlabScriptName,...
                        [SensorIdxs{s} '-P' num2str(PartitionNum) '-' FailTypes{f} '-W' num2str(WIndex(w)) '-C' num2str(c) ],...
                        'PartitionNums',PartitionNum,...
                        'SensorIdxs',SensorIdxs{s},...
                        'FailTypes',FailTypes{f},...
                        'WIndex',WIndex(w),...
                        'CIndex',round(ComboPartitions(c):ComboPartitions(c+1))...
                        );
                    fwrite(fid, command,'char');
                    fwrite(fid,newline,'char');
                end
            end
        end
    end
    fclose(fid);
    open(NoHupScriptPath)
end

%% runWindowLoopClass.sh
if false
    projectdir = 'C:\wrk\Fujitsu-FCL';
    MatlabScriptName = 'WindowLoopClass';
    NoHupScriptPath = fullfile(projectdir,['run' MatlabScriptName '.sh']);
    if exist(NoHupScriptPath); delete(NoHupScriptPath); end
    disp(['Writing ' NoHupScriptPath ])
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    WIndex = 1:5;
    DropAbs = 0:1;
    
    for w=1:length(WIndex)
        for d=1:length(DropAbs)
            command = createNoHupCommand(MatlabScriptName,...
                ['W' num2str(WIndex(w)) '-DropAbs' num2str(DropAbs(d))],...
                'WIndex',WIndex(w),...
                'DropAbs',DropAbs(d)...
                );
            fwrite(fid, command,'char');
            fwrite(fid,newline,'char');
        end
    end
    fclose(fid);
    open(NoHupScriptPath)
end

%% runWindowLoopClass.sh
if true
    projectdir = 'C:\wrk\Ripple\Deliverables\HallCounter';
    MatlabScriptName = 'HallCounterTestOnVoltSpikes';
    NoHupScriptPath = fullfile(projectdir,['run' MatlabScriptName '.sh']);
    if exist(NoHupScriptPath); delete(NoHupScriptPath); end
    disp(['Writing ' NoHupScriptPath ])
    [fid,errmsg] = fopen(NoHupScriptPath,'wt');
    
    fwrite(fid, '#!/bin/bash','char');
    fwrite(fid,newline,'char');
    
    WinSzs = 10:5:40;
    FeatSpaces={'A1','A2','A3','A4','A5','A6','BA1','BA2','BA3','BA4','BA5','BA6','C1','C2','C3','C4','C5','BC1','BC2','BC3','BC4','BC5'};
    
    for w=1:length(WinSzs)
        for f=1:length(FeatSpaces)
            command = createNoHupCommand(MatlabScriptName,...
                ['W' num2str(WinSzs(w)) '-F' num2str(f)],...
                'WinSzs',WinSzs(w),...
                'FeatSpaces',FeatSpaces(f)...
                );
            fwrite(fid, command,'char');
            fwrite(fid,newline,'char');
        end
    end
    fclose(fid);
    open(NoHupScriptPath)
end
%% createNoHupCommand

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