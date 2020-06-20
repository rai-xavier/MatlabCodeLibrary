addpath('/home/xgutierrez/MatlabCodeLibrary')
if TerminalMode
    projectdir = '/home/xgutierrez/Ripple/';
    addpath('/home/xgutierrez/HopperUtilities')
    % Hopper
    % Req'd Vars
    if not(exist('windex'));syslog('Require var windex','x');end
else
    clc;clearvars;close('all')
    projectdir = 'C:\wrk\Ripple\';
    windex = input('windex = ');
end
syslog(strcat('windex = ',num2str(windex)))

addpath(projectdir)

%% Paths
projectdir = 'C:\wrk\Ripple\';
modeldir = fullfile(projectdir,'Results-WinExplore');

csvdir = fullfile(projectdir, '01-Cmpr_Rslts_Test_20200615\Pre-Segmented\');
mydir=dir(csvdir);

%% Train Parameters
SubsetProportion = 0.3;
syslog(strcat('SubsetProportion = ',num2str(SubsetProportion)))

UseParallel = false;

Fs = 20e3;
Options = struct('samplerate',20e3,'nfilts',26);

winsz_low = 50;
winsz_hi = 2e3;
num_win = 6;
window_sizes = [linspace(winsz_low,winsz_hi,num_win) 2.^(7:10)];
window_sizes = window_sizes(windex);
syslog(strcat('window_sizes = ',num2str(window_sizes)))

FeatureSpaces = 'BA1 BA2 BA3 BA4 BA5 BA6 C1 C2 C3 C4 C5 BC1 BC2 BC3 BC4 BC5';
syslog(strcat('FeatureSpaces = ',FeatureSpaces))

ModelTypes = {'STA_LIN_OVO'};
syslog(strcat('ModelTypes = ',join(ModelTypes,', ')))

%% Loop Windows

for winsz = window_sizes
    syslog(strcat('winsz = ',num2str(winsz)))
    stepsz = 0.5*winsz;
    
    ModelFileName = fullfile(modeldir,['H_' num2str(winsz) 'win']);
    syslog(strcat('ModelFileName = ',num2str(ModelFileName)))

    ClassBalanceFigureFileName = strrep(ModelFileName,'.mat','_ClassBalance.png');
    syslog(strcat('ClassBalanceFigureFileName = ',num2str(ClassBalanceFigureFileName)))
    
    ResubTableFileName = fullfile(modeldir,'ResultsTables',['Win' num2str(winsz) '_Resub']);
    syslog(strcat('ResubTableFileName = ',num2str(ResubTableFileName)))
    
    KFoldTableFileName = fullfile(modeldir,'ResultsTables',['Win' num2str(winsz) '_KFold']);
    syslog(strcat('KFoldTableFileName = ',num2str(KFoldTableFileName)))
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
    
    [HGroups,groupmap] = grp2idx(HGroups);
    [HLabels,labelmap] = grp2idx(HLabels);
    
    syslog(strcat('# Samples = ',num2str(length(HLabels))))
    
    %% Plot ClassBalance
    
    SetFigureToFullScreen(1);clf
    histogram(HLabels);
    xticks(unique(HLabels))
    xticklabels(labelmap);
    xtickangle(45)
    ylabel('# Samples')
    [~,mytitle,~] = fileparts(ClassBalanceFigureFileName);
    mytitle = strrep(mytitle,'_','-');
    mytitle = {strrep(mytitle,'_','-')};
    mytitle{end+1} = ['# Samples = ' num2str(length(HLabels))];
    title(mytitle);
    SetFigureToFullScreen(1);
    saveas(figure(1),ClassBalanceFigureFileName);
    DockFigure(1)
    
    %% Subset Data
 [hdata,edges] = histcounts(HLabels,6);
    hdatanorm = hdata/max(hdata);
    HLabelsDscrt = discretize(HLabels,edges);
    uLabels = unique(HLabelsDscrt);
    SubsetIdx = {};
    for jj=1:length(uLabels)
        idx_class = HLabelsDscrt == uLabels(jj);
        idx_class = find(idx_class);
        idx_subset = randperm(length(idx_class),round(SubsetProportion*length(idx_class)));
        idx_class_subset = idx_class(idx_subset);
        SubsetIdx{end+1,1} = idx_class_subset;
    end
    SubsetIdx = cell2mat(SubsetIdx);
    HData = cellfun(@(x) x(SubsetIdx,:),HData,'UniformOutput',false);
    HLabels = HLabels(SubsetIdx);
    
%     NumOfEachClass = min(hdata);
%     [HData,~,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HLabelsDscrt, 2);
%     HLabels = HLabels(SubsetIdx);
    
    ClassBalanceFigureFileName = strrep(ClassBalanceFigureFileName, '.png','_Subset.png');
    SetFigureToFullScreen(2);clf
    histogram(HLabels);
    ylabel('# Samples')
    [~,mytitle,~] = fileparts(ClassBalanceFigureFileName);
    mytitle = strrep(mytitle,'_','-');
    title(mytitle);
    SetFigureToFullScreen(2);
    saveas(figure(2),ClassBalanceFigureFileName);
    
    %% Train Hopper
    tic
    H = HopperSVM(...
        'Data', HData, ...
        'MetaData', HLabels, ...
        'Groups', HGroups,...
        'FeatureNames',FeatureSpaces, ...
        'ModelNames', ModelTypes,...
        'Options', Options ,...
        'UseParallel', UseParallel);
    
    % train
    H = H.H_TRAIN_MODELS(1);
    H = H.H_RESUB();
    toc
    syslog(['Total training time = ' num2str(toc/60) ' min'],'t')
    syslog(['Saving to ' ModelFileName],'s')
    save(ModelFileName, 'H','labelmap','groupmap')
    
    % kfold
    rng(0);
    tic; H = H.H_KFOLD([], 10, [], true); 
    syslog(['Total kfold time = ' num2str(toc/60) ' min'],'t')
    syslog(['Saving to ' ModelFileName],'s')
    save(ModelFileName, 'H','labelmap','groupmap')
    
    %% Store results
    
    %% end loop windows
end
