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
hsvmdir = fullfile(resultsdir, 'HSVM');
classbalancedir = fullfile(resultsdir, 'ClassBalance');
rmsdir = fullfile(resultsdir,'RMS');
resultstabledir = fullfile(resultsdir, 'ResultsTable' );
confmatdir = fullfile(resultsdir, 'ConfMats');
MakeFolder(resultsdir,modeldir,hsvmdir,classbalancedir,rmsdir,resultstabledir,confmatdir)
%% Hopper Params
ModelType = 'STA_LIN_OVO';
% kfold
NumGroups = 10;
UseGroups = true;
% feature-space
% A = split('A1 A2 A3 A4 A5 A6',' ');
% BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
E1 = cellfun(@(x) ['E1' x], C,'UniformOutput',false);
E2 = cellfun(@(x) ['E2' x], C,'UniformOutput',false);
FeatSpaces = [C;BC;E1;E2]';
if exist('FIndexes','var'); FeatSpaces = FeatSpaces(FIndexes); end

%% Data Params
% WindowSizes = 2.^(11:14);
WinSzSeconds = [0.25 0.5 1 2];
WinSzs = 2.^nextpow2(WinSzSeconds*SampleRate);
if exist('WIndexes','var'); WinSzs = WinSzs(WIndexes); end
SubsetProportion = 0.3;
%% Loop Windows + Feats
syslog(strcat("WinSzSeconds = ", char(join(string(WinSzSeconds),', '))))
syslog(strcat("FeatSpaces = ", char(join(FeatSpaces,', '))))
for WinSz = WinSzs
    StepSz = round( 0.5 * WinSz );
    Options = struct('SampleRate', SampleRate, 'NumFilts', 0.5);
    for FeatSpace = FeatSpaces
        FeatSpace = char(FeatSpace);
        %% FilePaths + figs
        DataName = ['D-W' num2str(WinSz)];
        HSVMName = ['H-W' num2str(WinSz) '-' FeatSpace];
        ModelFilePath = fullfile(modeldir,HSVMName);
        TrainResultsTableFilePath = fullfile(resultstabledir, [HSVMName '_TrainResultsTable.csv'] );
        if and( exist(ModelFilePath,'file'), exist(TrainResultsTableFilePath,'file') );continue; end
        syslog(strcat("ModelName = ",HSVMName))
        % continue
        SegmentDataPath = fullfile(resultsdir,DataName);
        ClassBalanceFigureFilePath = fullfile(classbalancedir, [ HSVMName '-ClassBalance.png'] );
        fig_classbalance = dock(1,'ClassBalance');clf
        RMSFigFilePath = fullfile(rmsdir, [DataName '-RMS.png']);
        fig_rms = dock(3,'RMS');clf
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
        
        %% Save Full Data
        save(SegmentDataPath,'HData','HLabels','HGroups','HGroupsExt','ClassMap','GroupMap','GroupExtMap','-v7.3')
        
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
        titleabove(HSVMName);
        saveas(gcf,ClassBalanceFigureFilePath);
        
        %% RMS By Class
        figure(fig_rms); clf
        [nrows,ncols] = sgdims(length(ClassMap));
        for n = 1 : length(ClassMap)
            % subset class
            classidx = find(HLabels == n);
            % calculate rms
            ClassRMS = cellfun(@(x) rms(x(classidx,:),2), HData, 'UniformOutput',false);
            % plot histogram
            subplot(nrows,ncols,n)
            h = histogram(ClassRMS{1},NumBins);
            if not(TerminalMode); xline(mean(ClassRMS{1}),'k'); end
            title(ClassMap{n})
            xlabel('RMS')
            ylabel('# windows')
        end
        titleabove( { ['win = ' num2str(WinSz)], ['fs = ' num2str(SampleRate)]})
        saveas(fig_rms,RMSFigFilePath);
        
        %% Subset Data (HLabels vs HGroupsExt)
        NumOfEachClass = min(histcounts(HLabels));
        NumOfEachClass = round( SubsetProportion * NumOfEachClass );
        [HData,HLabels,SubsetIdx] = GET_HOPPER_DATA_SUBSET(HData, HLabels, NumOfEachClass);
        HGroups = HGroups(SubsetIdx);
        
        %% Plot Subset ClassBalance
        figure(fig_classbalance);
        subplot(212);
        histogram(HLabels);
        xticks(unique(HLabels))
        xticklabels(ClassMap);
        xtickangle(45)
        ylabel('# Samples')
        mytitle={};
        mytitle{2} = ['# Total Samples = ' num2str(length(HLabels))];
        title(mytitle);
        titleabove(HSVMName);
        saveas(gcf,ClassBalanceFigureFilePath);
        
        %% RMS By Class (Submap)
        figure(fig_rms); clf
        [nrows,ncols] = sgdims(length(ClassMap));
        for n = 1 : length(ClassMap)
            classidx = HLabels == n;
            ClassRMS = cellfun(@(x) rms(x(classidx,:),2), HData, 'UniformOutput',false);
            subplot(nrows,ncols,n)
            histogram(ClassRMS{1},20)
            if not(TerminalMode); xline(mean(ClassRMS{1})); end
            title(ClassMap{n})
            xlabel('RMS')
            ylabel('# windows')
            disp('')
        end
        titleabove( { ['(Submap) win = ' num2str(WinSz)], ['fs = ' num2str(SampleRate)]})

        saveas(fig_rms,strrep(RMSFigFilePath,'.png','-SubMap.png'));
        
        %% Run Hopper
        H = HopperSVM(...
            'Data', HData, ...
            'MetaData', HLabels, ...
            'ClassMap', ClassMap,...
            'Groups', HGroups,...
            'GroupMap',GroupMap,...
            'FeatureNames',Feat, ...
            'Options', Options, ...
            'ModelNames', ModelType,...
            'UseParallel', UseParallel);
        tic
        H = H.H_FEATURE_EXTRACTORS();
        toc
        save(ModelFilePath, 'H','-v7.3')
        clear HData HLabels HGroups GroupMap
        
        % Train - Resub
        tic
        H = H.H_TRAIN_MODELS(1);
        H = H.H_RESUB();
        save(ModelFilePath, 'H','-v7.3')
        syslog(['Total training time = ' num2str(toc/60) ' min'])
        
        % Save - HSVM + Resub CM
        Models = H.HopperModels.Properties.VariableNames;
        Models = reshape(Models,1,length(Models));
        Feats = H.HopperModels.Properties.RowNames;
        Feats = reshape(Feats,1,length(Feats));
        for M = Models
            M = char(M);
            for f = 1:length(Feats)
                F = Feats{f};
                % hsvm
                HSVM = H.HopperModels.(M)(f);
                HSVMBaseName = [HSVMName '-' strrep(M,'_','-') '-' F];
                HSVMBaseName = char( join( unique( split( HSVMBaseName,'-' ) ) , '-' ) );
                HSVMPath = fullfile(hsvmdir,HSVMBaseName);
                save(HSVMPath, 'HSVM','ClassMap','-v7.3')
                % resub conf mat
                ResubConfMatPath = fullfile(confmatdir,[ HSVMBaseName '-ResubCM.png' ] );
                figure(fig_confmat);clf
                ResubConfMat = H.HopperModels.(M)(f).ResubConfusionMat;
                plotConfMat(ResubConfMat,H.ClassMap)
                titleabove({HSVMBaseName,'Resub'})
                saveas(gcf,ResubConfMatPath);
            end
        end
        
        % Train - KFold
        rng(0);
        tic
        H = H.H_KFOLD([], NumGroups, [], UseGroups);
        syslog(['Total kfold time = ' num2str(toc/60) ' min'])
        
        % save Model
        syslog(['Saving to ' ModelFilePath])
        save(ModelFilePath, 'H','-v7.3')
        
        % Save KFold CM
        Models = H.HopperModels.Properties.VariableNames;
        Models = reshape(Models,1,length(Models));
        Feats = H.HopperModels.Properties.RowNames;
        Feats = reshape(Feats,1,length(Feats));
        for M = Models
            M = char(M);
            for f = 1:length(Feats)
                F = Feats{f};
                % hsvm
                HSVM = H.HopperModels.(M)(f);
                HSVMBaseName = [HSVMName '-' strrep(M,'_','-') '-' F];
                HSVMBaseName = char( join( unique( split( HSVMBaseName,'-' ) ) , '-' ) );
                HSVMPath = fullfile(hsvmdir,HSVMBaseName);
                save(HSVMPath, 'HSVM','-v7.3')
                % kfold conf mat
                KFoldConfMatPath = fullfile(confmatdir,[ HSVMBaseName '-KFoldCM.png' ] );
                figure(fig_confmat);clf
                KFoldConfMat = H.HopperModels.(M)(f).KFoldConfusionMat;
                plotConfMat(KFoldConfMat,ClassMap)
                titleabove({HSVMName,'KFold'})
                saveas(gcf,KFoldConfMatPath);
            end
        end
        
        %% Save ResultsTable with MetaData
        syslog(['Saving to ' TrainResultsTableFilePath])
        ResultsTable = getClassifyResultsTable(H.HopperModels);
        writetable(ResultsTable,TrainResultsTableFilePath)
        
        %% Test Hopper
        disp('')
        
        %% end loop feat
    end
    %% end loop windows
end
%% End of script
syslog('Script complete.','x')
