%% Base-Directories/Vars
if TerminalMode
    projectdir = '';
    if not(strcmp(projectdir, pwd)); syslog(strcat("Execute script from ",projectdir),'x'); end
    datadir = '';
    
    % Hopper
    addpath(fullfile(projectdir,'Hopper'))
    
    % Req'd Vars
    ReqVars = {''};
    for r=1:length(ReqVars)
        command = {};
        command{end+1} = "if not(exist('";
        command{end+1} = ReqVars{r};
        command{end+1} = "','var')); syslog('DEFINE VAR: ";
        command{end+1} = ReqVars{r};
        command{end+1} = "','x'); end";
        command = join(cellfun(@char,command,'UniformOutput',false), '');
        evalc(char(command));
    end
else
    clearvars;close('all')
    projectdir = 'Z:\Bose';
    datadir = fullfile(projectdir,'ToolsWAV');
    WIndex = 1:4;
    FIndex = 1;
end
mydir = dir(datadir);

%% Dst Directories
resultsdir = fullfile(projectdir,'Results');
modeldir = fullfile(resultsdir,'Models');
basemodeldir = fullfile(resultsdir, 'BaseModels');
classbalancedir = fullfile(resultsdir, 'ClassBalance');
resultstabledir = fullfile(resultsdir, 'ResultsTable' );
confmatdir = fullfile(resultsdir, 'ConfMats');
MakeFolder(resultsdir,modeldir,basemodeldir,classbalancedir,resultstabledir,confmatdir)
%% Hopper Params
NumGroups = 10;
UseGroups = true;
% A = split('A1 A2 A3 A4 A5 A6',' ');
% BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
E1 = cellfun(@(x) ['E1' x], C,'UniformOutput',false);
E2 = cellfun(@(x) ['E2' x], C,'UniformOutput',false);
FeatSpaces = [C;BC;E1;E2]';
if exist('FIndex','var'); FeatSpaces = FeatSpaces(FIndex); end
ModelType = 'STA_LIN_OVO';
%% Data Params
WindowSizes = 2.^(11:14);
if exist('WIndex','var'); WindowSizes = WindowSizes(WIndex); end
SubsetProportion = 0.3;
%% Loop Windows
for WinSz = WindowSizes
    StepSz = round( 0.5 * WinSz );
        
    %% FilePaths
    ModelName = ['H-W' num2str(WinSz) '.mat'];
    ModelFilePath = fullfile(modeldir,ModelName);
    TrainResultsTableFilePath = fullfile(resultstabledir, strrep(ModelName,'.mat','_TrainResultsTable.csv') );
    if and( exist(ModelFilePath,'file'), exist(TrainResultsTableFilePath,'file') );continue; end
    syslog(strcat("ModelName = ",ModelName))

    ClassBalanceFigureFilePath = fullfile(classbalancedir, strrep(ModelName,'.mat','_ClassBalance.png') );
    fig_classbalance = dock(1,'ClassBalance');clf
    fig_confmat = dock(2,'ConfMat');clf
    %% Loop DataDir
    HData = {};
    HLabels = {};
    HGroups = {};
    HGroupsExt = {};
    for ii=1:length(mydir)
        [~,fn,ext]=fileparts(mydir(ii).name);
        if not(contains(ext,'wav'));continue;end
        % current label
        ispresencedetection = or( contains(fn, 'Absence'), contains(fn,'Presence') );
        if ispresencedetection
            label = 'NotBabyCry';
        else
            label = 'BabyCry';
        end
%         if and( strcmp(label,'NotBabyCry'), any(strcmp(vertcat(HLabels{:}),'NotBabyCry')) ); continue; end
%         if and( strcmp(label,'BabyCry'), any(strcmp(vertcat(HLabels{:}),'BabyCry')) ); continue; end
        % read file
        [y,fs] = audioread(fullfile(datadir,mydir(ii).name));
        % segment data
        HData{end+1,1} = window_data(y, WinSz, StepSz);
        % segment labels
        HLabels{end+1,1} = repmat(string(label), size(HData{end},1),1);
        % segment groups
        HGroups{end+1,1} = repmat(string(fn),size(HData{end},1),1);
        % segment super-groups
        HGroupsExt{end+1,1} = join([HLabels{end} HGroups{end}],'-');
    end
    
    %% Format Data
    
    % stack
    for jj=1:size(HData,2)
        HData(1,jj) = {vertcat(HData{:,jj})};
    end
    HData(2:end,:) = [];
    HLabels = vertcat(HLabels{:});
    HGroups = vertcat(HGroups{:});
    syslog(strcat('NumSamples = ',num2str(length(HLabels))))
    % map
    [HGroups,GroupMap] = grp2idx(HGroups);
    [HLabels,ClassMap] = grp2idx(HLabels);
    UseParallel = length(ClassMap) >= 3;
    
    %% Plot Full ClassBalance
    figure(fig_classbalance);
    subplot(211);
    histogram(HLabels);
    xticks(unique(HLabels))
    xticklabels(ClassMap);
    xtickangle(45)
    ylabel('# Samples')
    mytitle={};
    mytitle{end+1} = ['# Total Samples = ' num2str(length(HLabels))];
    title(mytitle);
    titleabove(ModelName);
    saveas(gcf,ClassBalanceFigureFilePath);
    
    %% Subset Data (HLabels vs HGroupsExt)
    NumOfEachClass = min(histcounts(HLabels));
    NumOfEachClass = round( SubsetProportion * NumOfEachClass );
    [HData,HLabels,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HLabels, NumOfEachClass);
    HGroups = HGroups(SubsetIdx);
    
    %% Plot Subset ClassBalance
    figure(fig_classbalance);
    subplot(212);
    histogram(HLabels);
    ylabel('# Samples')
    mytitle={};
    mytitle{2} = ['# Total Samples = ' num2str(length(HLabels))];
    title(mytitle);
    titleabove(ModelName);
    saveas(gcf,ClassBalanceFigureFilePath);
    
    %% Run Hopper
    H = HopperSVM(...
        'Data', HData, ...
        'MetaData', HLabels, ...
        'ClassMap', ClassMap,...
        'Groups', HGroups,...
        'GroupMap',GroupMap,...
        'FeatureNames',FeatSpaces, ...
        'ModelNames', ModelType,...
        'UseParallel', UseParallel);
    H = H.H_FEATURE_EXTRACTORS();
    clear HData HLabels ClassMap HGroups GroupMap
    
    % Train - Resub
    tic
    H = H.H_TRAIN_MODELS(1);
    H = H.H_RESUB();
    syslog(['Total training time = ' num2str(toc/60) ' min'])
    
    % Train - KFold
    rng(0);
    tic
    H = H.H_KFOLD([], NumGroups, [], UseGroups);
    syslog(['Total kfold time = ' num2str(toc/60) ' min'])   
    
    % save Model 
    syslog(['Saving to ' ModelFilePath])
    save(ModelFilePath, 'H','-v7.3')
    
    % Save BaseModel + CM
    Models = H.HopperModels.Properties.VariableNames;
    Models = reshape(Models,1,length(Models));
    Feats = H.HopperModels.Properties.RowNames;
    Feats = reshape(Feats,1,length(Feats));
    for M = Models
        M = char(M);
        for f = 1:length(Feats)
            F = Feats{f};
            % base model
            HBaseModel = H.HopperModels.(M).BaseModel;
            BaseModelName = strrep(ModelName,'.mat',['-' strrep(M,'_','-') '-' F '.mat']);
            BaseModelPath = fullfile(basemodeldir,BaseModelName);
            save(BaseModelPath, 'HBaseModel','-v7.3')
            % resub conf mat
            ResubConfMatPath = fullfile(confmatdir,strrep(BaseModelName,'.mat','-ResubCM.png'));
            figure(fig_confmat);clf
            ResubConfMat = H.HopperModels.(M)(f).ResubConfusionMat;
            plotConfMat(ResubConfMat,unique(H.MetaData))
            titleabove({BaseModelName,'Resub'})
            saveas(gcf,ResubConfMatPath);
            % kfold conf mat
            KFoldConfMatPath = fullfile(confmatdir,strrep(BaseModelName,'.mat','-KFoldCM.png'));
            figure(fig_confmat);clf
            KFoldConfMat = H.HopperModels.(M)(f).KFoldConfusionMat;
            plotConfMat(KFoldConfMat,unique(H.MetaData))
            titleabove({BaseModelName,'KFold'})
            saveas(gcf,KFoldConfMatPath);

        end
    end

     %% Save ResultsTable with MetaData
    syslog(['Saving to ' TrainResultsTableFilePath])
    ResultsTable = getClassifyResultsTable(H.HopperModels);
    writetable(ResultsTable,TrainResultsTableFilePath)
    
    %% Test Hopper
    disp('')

    %% end loop windows
end

%% Emd of script
syslog('Script complete.','x')
