%% Path
outdir = 'Z:\Hopper_Dev\dev-xavier\Feature-Optimization';
MakeFolder(outdir)
BaseModelFileName = fullfile(outdir,'H.mat');
%% Parameters
% A = split('A1 A2 A3 A4 A5 A6',' ');
% BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
% C = split('C1 C2 C3 C4 C5 C6 C7',' ');
% BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
% FeatureSpaces = [A;BA;C;BC;{'E1C1'};{'E2C1'}]';
% FeatureSpaces = {'A1','C1','C6','E1C1','E1C6'};
FeatureSpaces = {'E1C1'};
ModelType = {'STA_LIN_OVO'};
WinSz = 2^15;
Options = struct('SampleRate',16e3,'NFFT',WinSz);
Options.NumFilts = CalculateMaxMelFilts(Options.NFFT,Options.SampleRate);
%% Data
HData = {randi(2^16,10,WinSz)};
HLabels = [zeros(5,1);ones(5,1)];
ClassMap = {'babycry','other'};
save(fullfile(outdir,'SegmentData.mat'),'HData','HLabels','ClassMap')
%% Initialize Hopper
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'ClassMap',ClassMap, ...
    'FeatureNames',FeatureSpaces, ...
    'Options',Options,...
    'ModelNames', ModelType);
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
%% H2GO
subDirName = 'h2go-debug';
pathToHSVM = 'Z:\Hopper_Dev\dev-xavier\Feature-Optimization\H_C5.mat';
simAndExportOne(subDirName, pathToHSVM, [])