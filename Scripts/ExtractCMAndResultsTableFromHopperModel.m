srcdir = 'C:\wrk\Ripple\Deliverables\SourceFiles\';
modeldir = fullfile(srcdir,'Models'); 
basemodeldir = fullfile(srcdir,'BaseModels');
confmatdir = fullfile(srcdir,'ConfMats');
resultstabledir =  fullfile(srcdir,'ResultTables');

%% loop through files
mydir=dir(modeldir);
for i = 1:length(mydir)
    [~,fn,ext]=fileparts(mydir(i).name);
    if not(contains(ext,'mat'));continue;end
    
    ModelName = [fn ext];
    disp(ModelName)
    ModelFilePath = fullfile(modeldir,ModelName);
    ResultsTableFilePath = fullfile(resultstabledir,strrep(ModelName,'.mat','-ResultTable.csv'));

    load(ModelFilePath,'H')

    
    %% Save ResubCM
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
            dock(strrep(BaseModelName,'.mat',''))
            plotConfMat(H.HopperModels.(M)(f).ResubConfusionMat,unique(H.MetaData))
            title(strrep(BaseModelName,'_','-'))
            saveas(gcf,ConfMatPath);
        end
    end
      
    %% Add MetaData & Save ResultsTable
    ResultsTable = getClassifyResultsTable(H.HopperModels);
    writetable(ResultsTable,ResultsTableFilePath)
    
    %% done
    disp('')
    close all
end

%%
MasterResults = table;
mydir = dir(resultstabledir);
for i = 1:length(mydir)
    [~,fn,ext]=fileparts(mydir(i).name);
    if not(contains(ext,'csv'));continue;end
    T = readtable(fullfile(resultstabledir,mydir(i).name));
    MasterResults=[MasterResults;T];
end
MasterResults = sortrows(MasterResults,'Accuracy','descend');
writetable(MasterResults,fullfile(resultstabledir,'MasterResults.csv'))