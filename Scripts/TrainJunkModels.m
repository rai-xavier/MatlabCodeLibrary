%% Path
outdir = 'C:\wrk\dev-xavier\embedded-hopper2go\Matlab SVM\';
MakeFolder(outdir)
BaseModelFileName = fullfile(outdir,'H.mat');
%% Parameters
A = split('A1 A2 A3 A4 A5 A6',' ');
BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
FeatureSpaces = [A;BA;C;BC;{'E1C1'};{'E2C1'}]';
ModelType = {'STA_LIN_OVO'};
WinSz = 256;
Options = struct('samplerate',WinSz,'nfilts',26);

%% Data
HData = {randi(2^16,10,WinSz)};
HLabels = [zeros(5,1);ones(5,1)];

%% Initialize Hopper
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'FeatureNames',FeatureSpaces, ...
    'Options',Options,...
    'ModelNames', ModelType);
H = H.H_FEATURE_EXTRACTORS();

%% Train - Resub
H = H.H_TRAIN_MODELS(1);
H = H.H_RESUB();

%% Save

for jj = 1:height(H.HopperModels)
    S = H.HopperModels.STA_LIN_OVO(jj);
    FeatureSpace = S.ModelInfo.FeatureName;
    NewModelFileName = strrep(BaseModelFileName,'.mat',['_' FeatureSpace '.mat']);
    save(NewModelFileName, 'S','-v7.3')
end
