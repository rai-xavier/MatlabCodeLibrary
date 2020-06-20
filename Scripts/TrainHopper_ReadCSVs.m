
%% Paths
projectdir = 'C:\wrk\Ripple\';

csvdir = fullfile(projectdir, '01-Cmpr_Rslts_Test_20200615\Pre-Segmented\');
mydir=dir(csvdir);

modeldir = fullfile(projectdir,'Results');
ModelFileName = fullfile(modeldir,'');
ClassBalanceFigureFileName = strrep(ModelFileName,'.mat','_ClassBalance.png');

%% Train Parameters
Fs = 20e3;
winsz = ;
stepsz = 0.5*winsz;
FeatureSpaces = 'A1 A2 A3 A4 A5 A6 BA1 BA2 BA3 BA4 BA5 BA6 C1 C2 C3 C4 C5 BC1 BC2 BC3 BC4 BC5';
ModelTypes = {'STA_LIN_OVO'};

%% Loop CSVs
HData = {};
HLabels = [];

for ii=1:length(mydir)
  [~,fn,ext]=fileparts(mydir(ii).name);
    if not(contains(ext,'csv'));continue;end
    % read table
   T = readtable(fullfile(csvdir,mydir(ii).name));
   HData{end+1,1} = window_data(T.,winsz,stepsz);
   HLabels{end+1,1} = window_data(T.,winsz,stepsz);
   HLabels{end} = mean(HLabels{end},2);
   
end
HData = {cell2mat(HData)};
HLabels = cell2mat(HLabels);
HGroups = cell2mat(HGroups);

[HGroups,groupmap] = grp2idx(HGroups);
[HLabels,labelmap] = grp2idx(HLabels);

%% ClassBalance

SetFigureToFullScreen(1);clf
histogram(HLabels);
xticks(unique(HLabels))
xticklabels(labelmap);
xtickangle(45)
ylabel('# Samples')
[~,mytitle,~] = fileparts(ClassBalanceFigureFileName);
mytitle = strrep(mytitle,'_','-');
title(mytitle);
SetFigureToFullScreen(1);
saveas(figure(1),ClassBalanceFigureFileName);
DockFigure(1)

%% Subset Data
hdata = histcounts(HLabels);
numOfEachClass = min(hdata);
[HData,HLabels,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HLabels, NumOfEachClass);

%% Train Hopper
tic
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'Groups', HGroups,...
    'FeatureNames',FeatureSpaces, ...
    'ModelNames', ModelTypes,...
    'UseParallel', false);

% train
H = H.H_TRAIN_MODELS(1);
H = H.H_RESUB();
toc
disp(['Total training time = ' num2str(toc/60) ' min'])
disp(['Saving to ' ModelFileName])
save(ModelFileName, 'H','labelmap','groupmap')
rng(0);

% kfold
tic; H = H.H_KFOLD([], 10, [], true); toc
disp(['Total kfold time = ' num2str(toc/60) ' min'])
disp(['Saving to ' ModelFileName])
save(ModelFileName, 'H','labelmap','groupmap')