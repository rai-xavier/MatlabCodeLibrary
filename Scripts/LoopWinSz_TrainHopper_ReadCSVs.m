%% Paths
if TerminalMode
    projectdir = '';
    
    % Hopper
    addpath(fullfile(projectdir,'Hopper'))
    
    % Req'd Vars
    if not(exist('windex'));syslog('Require var windex','x');end
    
else
    clearvars;close('all')
    projectdir = '';
    if not(exist('windex')); windex = input('windex = ');    end
end

addpath(projectdir)
syslog(strcat('windex = ',num2str(windex)))

modeldir = fullfile(projectdir,'Results-WinExplore');

csvdir = fullfile(projectdir, '');
mydir=dir(csvdir);

%% Train Parameters

% subset
SubsetProportion = 0.3;
syslog(strcat('SubsetProportion = ',num2str(SubsetProportion)))

% use parallel
UseParallel = false;
syslog(strcat('UseParallel = ',num2str(UseParallel)))

% segmentation
Fs = 20e3;
winsz_low = 50;
winsz_hi = 2e3;
num_win = 6;
window_sizes = [linspace(winsz_low,winsz_hi,num_win) 2.^(7:10)];
window_sizes = window_sizes(windex);
syslog(strcat('window_sizes = ',num2str(window_sizes)))

% feature spaces
Options = struct('samplerate',Fs,'nfilts',26);
A = split('A1 A2 A3 A5 A5 A6',' ');
BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
E1 = cellfun(@(x) ['E1' x], C,'UniformOutput',false);
E2 = cellfun(@(x) ['E2' x], C,'UniformOutput',false);
FeatureSpaces = [A;BA;C;BC]';
syslog(strcat('FeatureSpaces = ',FeatureSpaces))

% model types
ModelTypes = {'STA_LIN_OVO','STA_LIN_OVA','NST_POLY_OVO'};
syslog(strcat('ModelTypes = ',join(ModelTypes,', ')))

%% Loop Windows

for winsz = window_sizes
    syslog(strcat('winsz = ',num2str(winsz)))
    stepsz = 0.5*winsz;
    
    ModelFileName = fullfile(modeldir,['H_' num2str(winsz) 'win']);
    syslog(strcat('ModelFileName = ',num2str(ModelFileName)))
    
    ClassBalanceFigureFileName = strrep(ModelFileName,'.mat','_ClassBalance.png');
    syslog(strcat('ClassBalanceFigureFileName = ',num2str(ClassBalanceFigureFileName)))
    
    ResultsTableFileName = strrep(ModelFileName,'.mat','_ResultsTable.csv');
    syslog(strcat('ResubTableFileName = ',num2str(ResubTableFileName)))
    
    %% Loop CSVs
    HData = {};
    HLabels = [];
    disp(newline)
    for ii=1:length(mydir)
        [~,fn,ext]=fileparts(mydir(ii).name);
        if not(contains(ext,'csv'));continue;end
        
        % read table
        T = readtable(fullfile(csvdir,mydir(ii).name));
        HData{end+1,1} = window_data(T.Volt, winsz,stepsz);
        HData{end,2} = window_data(T.Amp, winsz,stepsz);
        HLabels{end+1,1} = window_data(T.HallStepSmooth, winsz,stepsz);
        HLabels{end} = mean(HLabels{end},2);
        HGroups{end+1,1} = repmat(fn,length(HLabels{end}),1);
        
    end
    disp(newline)
    HData = {cell2mat(HData)};
    HLabels = cell2mat(HLabels);
    HGroups = cell2mat(HGroups);
    
    [HGroups,GroupMap] = grp2idx(HGroups);
    [HLabels,ClassMap] = grp2idx(HLabels);
    syslog(strcat('NumSamples = ',num2str(length(HLabels))))
    
    %% Plot ClassBalance
    
    SetFigureToFullScreen(1);clf
    histogram(HLabels);
    xticks(unique(HLabels))
    xticklabels(ClassMap);
    xtickangle(45)
    ylabel('# Samples')
    mytitle={};
    [~,mytitle{1},~] = fileparts(ClassBalanceFigureFileName);
    mytitle{2} = ['# Total Samples = ' num2str(length(HLabels))];
    mytitle{3} = [num2str(winsz) 'win'];
    mytitle = strrep(mytitle,'_','-');
    title(mytitle);
    SetFigureToFullScreen(1);
    saveas(figure(1),ClassBalanceFigureFileName);
    DockFigure(1)
    
    %% Subset Data
    
    NumOfEachClass = min(histcounts(HLabels));
    [HData,HLabels,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HLabels, NumOfEachClass);
    HGroups = HGroups(SubsetIdx);
    
    ClassBalanceFigureFileName = strrep(ClassBalanceFigureFileName, '.png','_Subset.png');
    SetFigureToFullScreen(2);clf
    histogram(HLabels);
    ylabel('# Samples')
    mytitle={};
    [~,mytitle{1},~] = fileparts(ClassBalanceFigureFileName);
    mytitle{2} = ['# Total Samples = ' num2str(length(HLabels))];
    mytitle{3} = [num2str(winsz) 'win'];
    mytitle = strrep(mytitle,'_','-');
    title(mytitle);
    SetFigureToFullScreen(2);
    saveas(figure(2),ClassBalanceFigureFileName);
    
    %% Initialize Hopper
    H = HopperSVM(...
        'Data', HData, ...
        'MetaData', HLabels, ...
        'ClassMap', ClassMap,...
        'Groups', HGroups,...
        'GroupMap',GroupMap,...
        'FeatureNames',FeatureSpaces, ...
        'ModelNames', ModelTypes,...
        'UseParallel', UseParallel);
    H = H.H_FEATURE_EXTRACTORS();
    
    %% Train - Resub
    tic
    H = H.H_TRAIN_MODELS(1);
    H = H.H_RESUB();
    syslog(['Total training time = ' num2str(toc/60) ' min'])
    syslog(['Saving to ' ModelFileName])
    save(ModelFileName, 'H')
    ResultsTable = getClassifyResultsTable(H.HopperModels);
    writetable(ResultsTable,ResultsTableFileName)
    
    %% Train - KFold
    rng(0);
    tic
    H = H.H_KFOLD([], 10, [], true); toc
    syslog(['Total kfold time = ' num2str(toc/60) ' min'])
    syslog(['Saving to ' ModelFileName])
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
    
    %% end loop windows
end

%% Emd of script
syslog('Script complete.','x')