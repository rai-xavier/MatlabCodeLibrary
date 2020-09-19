csvdir = 'Z:\Rheem\IndoorPrognostics\Phase 1 Analysis\ToolsWAV-A1';
sensimdir = 'Z:\Rheem\IndoorPrognostics\Phase 1 Analysis\Sensor-Sensitivity\';
baseToolPath = fullfile(sensimdir,'A1-2500')
MakeFolder(baseToolPath)
%% Data Params
fileSubstring = 'Holdout';
SampleRate = 2.5e3;
WINSZ = 1;
windowLength = round( WINSZ * SampleRate );
stepsz = round( 0.5*windowLength );
featureNames = 'C5';
%% Sensor-Sensitivity Params
ResampleRate = 2e3;
NoiseType = 'SNR'; NoiseValues_dB = [0 3 6 9]; NoiseValues = 10.^(NoiseValues_dB/10);
DataMin = -8; DataMax = 8; BitDepthNew = 16;
%% Hopper Params
methodToUse = 'H_RESUB'; methodParameters = [1];
forPrediction = fullfile(baseToolPath,'MULTI-6Class-A1-C5 1.3.mat');
%% Other Params
pathToIndexCSV = fullfile(baseToolPath,'indexCSV.csv');
pathToData = [];
pathToRawDataMat = fullfile(baseToolPath,'RawData.mat');
pathToJsonInit = fullfile(baseToolPath,'jsonString.json');
uniqueIdentifier = 'uniqueIdentifier';
dumpFlag = true;
%% Segment Source Files
HData = {};
HLabels = {};
HGroups = {};
mydir = dir(csvdir);
for i = 1 : length(mydir)
    [~,fn,ext] = fileparts(mydir(i).name);
    if not(contains(ext,'csv'));continue;end
    if not(contains(fn,fileSubstring));continue;end
    %    [y,fs] = audioread(fullfile(wavdir,mydir(i).name));
    T = readtable(fullfile(csvdir,mydir(i).name));
    myvars = T.Properties.VariableNames;
    rowidx = size(HData,1)+1;
    for c = 1 : length(myvars)
        HData{rowidx,c} = window_data( T.(myvars{c}), winsz, stepsz );
    end
    
    label_split = split(mydir(i).name,'-');
    label = label_split{3};
    HLabels{rowidx,1} = repmat( string(label) , size(HData{end},1), 1 );
    HGroups{rowidx,1} = repmat( string(fn), size(HData{end},1), 1 );
    disp('')
end

for jj=1:size(HData,2)
    HData(1,jj) = {vertcat(HData{:,jj})};
end
HData(2:end,:) = [];
HLabels = vertcat(HLabels{:});
[HLabels,classMap] = grp2idx(HLabels);
HGroups = vertcat(HGroups{:});
openvar('HData')
openvar('HLabels')
openvar('classMap')
openvar('HGroups')
save( fullfile(baseToolPath,[fileSubstring '.mat'] ),'HData','HLabels','classMap','HGroups','-v7.3');
%% Write RawData + indexCSV
RawData = {};
CSVData = struct;
istart = 1;
for i=1:length(HLabels)
    
    % RawData
    for c = 1 : size(HData,2)
        dataseg = HData{c}(i,:);
        RawData{i,c} = transpose( dataseg );
    end
    % indexCSV
    CSVData(end+1).group = i;
    CSVData(end).start = istart;
    CSVData(end).xEnd = istart + length(RawData{i}) - 1;
    CSVData(end).class = HLabels(i);
    CSVData(end).pdoId = num2str(i);
    istart = istart + length(RawData{i});
end
CSVData = struct2table(CSVData);
CSVData(1,:) = [];
openvar('CSVData')
writetable(CSVData,pathToIndexCSV)

RawData = cell2mat(RawData);
openvar('RawData')
save(pathToRawDataMat,'RawData','-v7.3')
%% Write jsonString
jsonData = struct;
% old json fields hopper inputs
jsonData.pathToIndexCSV = pathToIndexCSV;
jsonData.pathToData = pathToData;
jsonData.pathToRawDataMat = pathToRawDataMat;
jsonData.groupColumn = [];
jsonData.windowLength = num2str(windowLength);
jsonData.magnitudes = [];
% old json fields initHopper()
jsonData.baseToolPath = baseToolPath;
jsonData.uniqueIdentifier = uniqueIdentifier;
jsonData.useParallel = [];
jsonData.featureNames = featureNames;
jsonData.forPrediction = forPrediction;
jsonData.CloudRun = [];
jsonData.H_SAVE = [];
jsonData.H_SUBSET = [];
jsonData.ChannelSubset = [];
jsonData.NoiseClass = []; % can be 0, so must be empty to reject
jsonData.Options = [];
% old json fields runHopperCommand()
jsonData.methodToUse = methodToUse;
jsonData.methodParameters = methodParameters;
jsonData.dumpFlag = dumpFlag;
% H_TEST_DATA_WITH_STEPPED_VARIANCE
jsonData.MaxVariance = [];
jsonData.NumStepsVariance = [];
jsonData.VarianceMode = [];
jsonData.PlotFlag = [];
% error balance
jsonData.updateSVM = [];
% hopper2go
jsonData.classMap = classMap;
% sensor spec simulation
jsonData.SampleRate = num2str(SampleRate);
jsonData.ResampleRate = num2str(ResampleRate);
jsonData.DataMin = num2str(DataMin);
jsonData.DataMax = num2str(DataMax);
jsonData.BitDepthNew = num2str(BitDepthNew);
% noise-array
jsonData.NoiseType = NoiseType;
jsonData.NoiseValue = '';
jsonDataArray = [];
for i =1:length(NoiseValues)
    jsonDataArray = [jsonDataArray;jsonData];
    jsonDataArray(i).NoiseValue = num2str( NoiseValues(i) );
end
openvar('jsonDataArray')
disp('')
% write jsonString.json
jsonString = jsonencode(jsonDataArray);
fid = fopen(pathToJsonInit,'w');
fwrite(fid, jsonString,'char');
fclose(fid);
