%% Paths
if TerminalMode
    projectdir = '';
    
    % Hopper
    addpath(fullfile(projectdir,'Hopper'))
    
    % Req'd Vars
%     if not(exist('windex'));syslog('Require var windex','x');end
    ReqVars = {'FailType','SensorGroup','SensorIdx','WinSz','StepSz','FeatureSpace','ModelType'};
    for r=1:length(ReqVars)
        command = {};
        command{end+1} = "if not(exist('";
        command{end+1} = ReqVars{r};
        command{end+1} = "','var')); syslog('DEFINE VAR: ";
        command{end+1} = ReqVars{r};
        command{end+1} = "','x'); end";
        command = join(cellfun(@char,command,'UniformOutput',false), '');
        evalc(char(command))
    end
    
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

% KFold
UseGroups = true;
NumGroups = 10;
syslog(strcat('UseGroups = ',num2str(UseGroups)))
syslog(strcat('NumGroups = ',num2str(NumGroups)))

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
A = split('A1 A2 A3 A4 A5 A6',' ');
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
    
    %% output directories
    modeldir = fullfile(resultsdir,['Models-' num2str(winsz)]);
    basemodeldir = fullfile(resultsdir, ['BaseModels-'  num2str(winsz)]);
    classbalancedir = fullfile(resultsdir, ['ClassBalance-'  num2str(winsz)]);
    resultstabledir = fullfile(resultsdir, ['ResultsTable-'  num2str(winsz)]);
    kfoldcmdir = fullfile(resultsdir, ['KFoldCM-'  num2str(winsz)]);
    
    dirs = {'resultsdir','modeldir','basemodeldir','classbalancedir','resultstabledir','kfoldcmdir'};
    for d=1:length(dirs)
        evalc(['MakeFolder(' dirs{d} ')']);
    end
        
    %% file paths
    
    ModelFileName = ['H_' num2str(winsz) 'win'];
    ModelFilePath = fullfile(modeldir,ModelFileName);
    if exist(ModelFilePath,'file');continue; end
    syslog(strcat('ModelFileName = ',num2str(ModelFileName)))
    
    ClassBalanceFigureFilePath = fullfile(classbalancedir, strrep(ModelFileName,'.mat','_ClassBalance.png') );
    ResultsTableFilePath = fullfile(resultstabledir, strrep(ModelFileName,'.mat','_ResultsTable.csv') );
    KFoldCMFilePath = fullfile(kfoldcmdir, strrep(ModelFileName,'.mat','_KFoldCM.png') );
        
    %% Loop CSVs
    HData = {};
    HLabels = {};
    HGroups = {};
    HGroupsExt = {};
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
        HGroups{end+1,1} = repmat(string(fn),length(HLabels{end}),1);
        HGroupsExt{end+1,1} = join([HLabels(end) HGroups(end)],'-');

    end
    disp(newline)
    
    %% format data
    HData = {cell2mat(HData)};
    HLabels = cell2mat(HLabels);
    HGroups = cell2mat(HGroups);
    
    [HGroups,GroupMap] = grp2idx(HGroups);
    [HLabels,ClassMap] = grp2idx(HLabels);
    syslog(strcat('NumSamples = ',num2str(length(HLabels))))
    
    %% Plot ClassBalance
    
    dock(1);clf
    histogram(HLabels);
    xticks(unique(HLabels))
    xticklabels(ClassMap);
    xtickangle(45)
    ylabel('# Samples')
    mytitle={};
    [~,mytitle{1},~] = fileparts(ClassBalanceFigureFilePath);
    mytitle{2} = ['# Total Samples = ' num2str(length(HLabels))];
    mytitle{3} = [num2str(winsz) 'win'];
    mytitle = strrep(mytitle,'_','-');
    title(mytitle);
    saveas(gcf,ClassBalanceFigureFilePath);
    
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
    
    %% Train - KFold
    rng(0);
    tic
    H = H.H_KFOLD([], NumGroups, [], UseGroups); toc
    syslog(['Total kfold time = ' num2str(toc/60) ' min'])   
    
    %% save Model 
    syslog(['Saving to ' ModelFileName])
    save(ModelFilePath, 'H','-v7.3')
    
    %% Add MetaData & Save ResultsTable
    syslog(['Saving to ' ResultsTableFilePath])
    syslog(['Total kfold time = ' num2str(toc/60) ' min'])    
    ResultsTable = getClassifyResultsTable(H.HopperModels);
    % add metdata to results table
    syslog(['Saving to ' ResultsTableFilePath])
    writetable(ResultsTable,ResultsTableFilePath)
    
    %% Save BaseModel + ResubCM
    Models = H.HopperModels.Properties.VariableNames;
    Models = reshape(Models,1,length(Models));
    Feats = H.HopperModels.Properties.RowNames;
    Feats = reshape(Feats,1,length(Feats));
    for M = Models
        M = char(M);
        for f = 1:length(Feats)
            F = Feats{f};
            
            BaseModelName = strrep(ModelName,'.mat',['-' M '-' F '.mat']);
            
            BaseModelPath = fullfile(basemodeldir,BaseModelName);
            HBaseModel = H.HopperModels.(M).BaseModel;
            save(BaseModelPath, 'HBaseModel','-v7.3')

            ConfMatPath = fullfile(confmatdir,strrep(BaseModelName,'.mat','-ResubCM.png'));
            dock
            plotConfMat(H.HopperModels.(M)(f).ResubConfusionMat,unique(HLabels))
            sgtitle(strrep(BaseModelName,'_','-'))
            saveas(gcf,ConfMatPath);
            
        end
    end

    

    %% end loop windows
end

%% Emd of script
syslog('Script complete.','x')
