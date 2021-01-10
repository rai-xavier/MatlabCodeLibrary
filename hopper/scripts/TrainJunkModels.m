%% Path
% outdir = 'Z:\Hopper_Dev\dev-xavier\Feature-Optimization';
outdir = 'C:\wrk\dev-xavier\ToolsDebug\RegressionTest';
MakeFolder(outdir)
BaseModelFileName = fullfile(outdir,'H.mat');
%% Parameters
A = split('A1 A2 A3 A4 A5 A6',' ');
BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
FeatureSpaces = [A;BA;C;BC;{'E1C1'};{'E2C1'}]';
% FeatureSpaces = {'A1','C1','C6','E1C1','E1C6'};
% FeatureSpaces = {'C5','C6','E1C1'};
FeatureSpaces = {'E2C1'};
ModelType = {'STA_LIN_OVO'};
WinSz = 2^15;
Options = struct('SampleRate',16e3,'NFFT',WinSz);
Options.NumFilts = CalculateMaxMelFilts(Options.NFFT,Options.SampleRate);
%% waves

% Fs = 16e3;
% t = (0:(1/Fs):1);
% A1 = 1; f1 = 160; w1 = A1 * sin( 2 * pi * f1 * t' );
% A2 = 2; f2 = 320; w2 = A2 * sin( 2 * pi * f2 * t' );
% 
% dock(1);clf
% subplot(211); plot(w1); title("w1")
% subplot(212); plot(w2); title("w2")

%% Data
HData = {randi(2^16,10,WinSz)};
HLabels = [zeros(5,1);ones(5,1)];
% 0 ~ train-normal
% 1 ~ test-anomaly
% 2 ~ test-normal
ClassMap = {'babycry','other'};
% save(fullfile(outdir,'SegmentData.mat'),'HData','HLabels','ClassMap')
%% Initialize Hopper
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'ClassMap',ClassMap, ...
    'FeatureNames',FeatureSpaces, ...
    'Options',Options,...
    'ModelNames', ModelType);
% %% ANomaly detection
% H = HopperSVM("Data", HData, "MetaData", HLabels, "FeatureNames", "A B BA BC C", "ModelNames", {'STA_RBF_OVO'} );
% [H,OutlierIdx,ResultTable,upper] = H.ANOMALY_DETECTOR();
% H.PLOT_ANOMALY();

%% Train - Resub
H = H.H_RESUB();


%% H2GO
H.RunDir = 'C:\wrk\dev-xavier\ToolsDebug\Hopper2Go\debug';
H.RunName = ['HopperVer' strrep(H.HopperVersion,'1.','')];
H.Data = [];
H.MetaData = [];
H.HOPPER2GO;
% S = H.HopperModels.STA_LIN_OVO;
% save(fullfile(H.RunDir,['S-' strrep(H.HopperVersion,'1.','')]),'S')

% %% Save
% for jj = 1:height(H.HopperModels)
%     S = H.HopperModels.STA_LIN_OVO(jj);
%     FeatureSpace = S.ModelInfo.FeatureName;
%     NewModelFileName = strrep(BaseModelFileName,'.mat',['_' FeatureSpace '.mat']);
%     save(NewModelFileName, 'S','-v7.3')
% end

% %% H2GO
% subDirName = 'h2go-debug';
% pathToHSVM = 'Z:\Hopper_Dev\dev-xavier\Feature-Optimization\H_C5.mat';
% pathtoData = 'Z:\Hopper_Dev\dev-xavier\Feature-Optimization\SegmentData.mat';
% simAndExportOne(subDirName, pathToHSVM, [])