
%% Paths
projectdir = '';
csvdir = fullfile(projectdir, '');

modeldir = fullfile(projectdir,'Results');
ModelFileName = fullfile(modeldir,'');
ClassBalanceFigureFileName = strrep(ModelFileName,'.mat','_ClassBalance.png');
ResultsTableFileName = strrep(ModelFileName,'.mat','_ResultsTable.csv');

%% Train Parameters
Fs = 20e3;
winsz = 0.5*Fs;
stepsz = 0.5*winsz;
A = split('A1 A2 A3 A5 A5 A6',' ');
BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
E1 = cellfun(@(x) ['E1' x], C,'UniformOutput',false);
E2 = cellfun(@(x) ['E2' x], C,'UniformOutput',false);
FeatureSpaces = [A;BA;C;BC]';
ModelTypes = {'STA_LIN_OVO','STA_LIN_OVA','NST_POLY_OVO'};

%% Loop CSVs
HData = {};
HLabels = [];
mydir=dir(csvdir);
for ii=1:length(mydir)
    [~,fn,ext]=fileparts(mydir(ii).name);
    if not(contains(ext,'csv'));continue;end
    
    % read table
    T = readtable(fullfile(csvdir,mydir(ii).name));
    HData{end+1,1} = window_data(T.Data,winsz,stepsz);
    HLabels{end+1,1} = window_data(T.Labels,winsz,stepsz);
    HLabels{end} = mean(HLabels{end},2);
    
end

HData = {cell2mat(HData)};
HLabels = cell2mat(HLabels);
HGroups = cell2mat(HGroups);

[HGroups,GroupMap] = grp2idx(HGroups);
[HLabels,ClassMap] = grp2idx(HLabels);

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

%% Initialize Hopper
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'ClassMap', ClassMap,...
    'Groups', HGroups,...
    'GroupMap',GroupMap,...
    'FeatureNames',FeatureSpaces, ...
    'ModelNames', ModelTypes,...
    'UseParallel', false);
H = H.H_FEATURE_EXTRACTORS();
clear HData

%% Train - Resub
tic
H = H.H_TRAIN_MODELS(1);
H = H.H_RESUB();
disp(['Total training time = ' num2str(toc/60) ' min'])
disp(['Saving to ' ModelFileName])
save(ModelFileName, 'H')
ResultsTable = getClassifyResultsTable(H.HopperModels);
writetable(ResultsTable,ResultsTableFileName)

%% Train - KFold
rng(0);
tic
H = H.H_KFOLD([], 10, [], true); toc
disp(['Total kfold time = ' num2str(toc/60) ' min'])
disp(['Saving to ' ModelFileName])
save(ModelFileName, 'H')
ResultsTable = getClassifyResultsTable(H.HopperModels);
writetable(ResultsTable,ResultsTableFileName)
for ii=1:lenght(ModelTypes)
    for jj=1:length(FeatureSpaces)
        ConfusionMat = getHopperFeatConfMat(H.HopperModels,ModelTypes{ii},FeatureSpaces{jj},'kfold');
        saveConfMatFig(ConfusionMat, ModelFilePath, labelmap, FeatureSpaces{jj}, 'kfold');
        [Recall,Precision,F1] = getMarginals(ConfusionMat);
    end
end