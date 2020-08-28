% srcdir = 'C:\wrk\Ripple\Deliverables\SourceFiles\';
srcdir = 'C:\wrk\Ripple\Deliverables\HallCounter';
modeldir = fullfile(srcdir,'Models');

%% base model
basemodelflag = true;
if basemodelflag
    basemodeldir = fullfile(srcdir,'BaseModels');
end

%% confmat
confmatflag = false;
if confmatflag
    confmatdir = fullfile(srcdir,'ConfMats');
end

%% resultstable
resultstableflag = false;
if resultstableflag
    resultstabledir =  fullfile(srcdir,'ResultTables');
end

%% loop through files
mydir=dir(modeldir);
for i = 1:length(mydir)
    [~,fn,ext]=fileparts(mydir(i).name);
    if not(contains(ext,'mat'));continue;end
    
    
    %% load model
    ModelName = [fn ext];
    disp(ModelName)
    ModelFilePath = fullfile(modeldir,ModelName);
    load(ModelFilePath,'H')
    
    
    %% CM/BaseModel
    Models = H.HopperModels.Properties.VariableNames;
    Models = reshape(Models,1,length(Models));
    Feats = H.HopperModels.Properties.RowNames;
    Feats = reshape(Feats,1,length(Feats));
    for M = Models
        M = char(M);
        for f = 1:length(Feats)
            F = Feats{f};
            
            BaseModelName = strrep(ModelName,'.mat',['-' M '-' F '.mat']);
            
            if basemodelflag
                BaseModelPath = fullfile(basemodeldir,BaseModelName)
                HBaseModel = H.HopperModels.(M)(f).BaseModel;
                save(BaseModelPath, 'HBaseModel','-v7.3')
            end
            
            if confmatflag
                ConfMatPath = fullfile(confmatdir,strrep(BaseModelName,'.mat','-ResubCM.png'));
                dock(strrep(BaseModelName,'.mat',''))
                plotConfMat(H.HopperModels.(M)(f).ResubConfusionMat,unique(H.MetaData))
                title(strrep(BaseModelName,'_','-'))
                saveas(gcf,ConfMatPath);
            end
        end
    end
    
    %% Add MetaData & Save ResultsTable
    if resultstableflag
        ResultsTableFilePath = fullfile(resultstabledir,strrep(ModelName,'.mat','-ResultTable.csv'));
        ResultsTable = getClassifyResultsTable(H.HopperModels);
        writetable(ResultsTable,ResultsTableFilePath)
    end
    %% done
    disp('')
    close all
end

%%
if resultstableflag
    MasterResults = table;
    mydir = dir(resultstabledir);
    for i = 1:length(mydir)
        [~,fn,ext]=fileparts(mydir(i).name);
        if not(contains(ext,'csv'));continue;end
        T = readtable(fullfile(resultstabledir,mydir(i).name));
        MasterResults=[MasterResults;T];
    end
    MasterResults = sortrows(MasterResults,'Accuracy','descend');
    % writetable(MasterResults,fullfile(resultstabledir,'MasterResults.csv'))
end