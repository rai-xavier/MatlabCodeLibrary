
ModelFilePaths = {};

ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1\BaseModels-OD-16\H_20_OD_BA1_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1\BaseModels-OD-32\H_20_OD_BA1_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1\BaseModels-OD-64\H_20_OD_BA1_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1\BaseModels-OD-128\H_20_OD_BA1_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1\BaseModels-OD-256\H_20_OD_BA1_A1.mat';


ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1WinLoopV3\BaseModels-OD\H-OD-W16-C5-BA1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1WinLoopV3\BaseModels-OD\H-OD-W32-C5-BA1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1WinLoopV3\BaseModels-OD\H-OD-W64-C5-BA1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1WinLoopV3\BaseModels-OD\H-OD-W128-C5-BA1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P1\Cool\1HzPlusMic1WinLoopV3\BaseModels-OD\H-OD-W256-C5-BA1.mat';

% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_39_ID_C4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_58_ID_C4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_167_ID_BA4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_198_ID_C4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_199_ID_C4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_194_ID_BA4_A1.mat';
% ModelFilePaths{end+1} = '\\abyss1\active_projects\Rheem\IndoorPrognostics\PWIPartitions2\P2\Cool\1HzPlusMic1WinLoop\BaseModels-ID-16\H_196_ID_C4_A1.mat';

%%
HBaseModels = cellfun(@load, ModelFilePaths,'UniformOutput',false);
dock('CompareBaseModels')
for h=1:length(HBaseModels)
    [~,fn,~] = fileparts(ModelFilePaths{h});
    try
        PlotModelParams(HBaseModels{h}.H_BaseModel,length(HBaseModels),h,strrep(fn,'_','-'))
    catch ME
        PlotModelParams(HBaseModels{h}.HBaseModel,length(HBaseModels),h,strrep(fn,'_','-'))
    end
end

%%
myfig = gcf;
axObjs = myfig.Children;
DataTable = struct;
for i=1:3:length(axObjs)
    DataTable(end+1).Sigma = axObjs(i).Children.XData;
    DataTable(end).Mu = axObjs(i+1).Children.XData;
    DataTable(end).Beta = axObjs(i+2).Children.XData;
end
DataTable=struct2table(DataTable);
DataTable(1,:) = [];
dock;
M1 = 1;
M2 = 2;
subplot(311); plot(DataTable.Sigma{M1} - DataTable.Sigma{M2}); title('\Delta Sigma')
subplot(312); plot(DataTable.Mu{M1} - DataTable.Mu{M2}); title('\Delta Mu')
subplot(313); plot(DataTable.Beta{M1} - DataTable.Beta{M2}); title('\Delta Beta')

%%
function PlotModelParams(HBaseModel,numcols,colnum,mytitle)
Params = {'Beta','Mu','Sigma'};
for p=1:length(Params)
    plotnum = numcols*(p-1) + colnum;
    subplot(length(Params),numcols,plotnum); hold on
    plot(HBaseModel.BinaryLearners{1}.(Params{p})  );
    title({mytitle,Params{p}})
end
return
end