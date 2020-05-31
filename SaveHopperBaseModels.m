function SaveHopperBaseModels(HopperModelPath, varargin)
[ModelDir,ModelFileName,ext] = fileparts(HopperModelPath);
if not(isempty(varargin))
    BaseModelDir = varargin{1};
else
    BaseModelDir = fullfile(ModelDir,'BaseModels');
end
disp(['Loading ' HopperModelPath])
H = load(HopperModelPath);
mat_vars = fields(H);
idx_h = find(contains(mat_vars,'H'));
if length(idx_h)>1
    disp(strcat("Multiple 'H_'-variables found in filepath: ", string(mat_vars(idx_h))));
    return
end
H = H.(mat_vars{idx_h});

% get model names
ModelTypes = H.HopperModels.Properties.VariableNames;
for ii=1:length(ModelTypes)
    NumModels = length(H.HopperModels.(ModelTypes{ii}));
    for jj=1:NumModels
        ModelTag = H.HopperModels.(ModelTypes{ii})(jj).ModelInfo.ModelName;
        H_BaseModel = H.HopperModels.(ModelTypes{ii})(jj).BaseModel;
        BaseModelName = [ModelFileName '_' ModelTag ext];
        BaseModelPath = fullfile(BaseModelDir, BaseModelName);
        if exist(BaseModelPath)
            disp(['File already exists (skip) : ' BaseModelPath])
            continue
        end
        disp(['Saving ' BaseModelPath])
        save(BaseModelPath,'H_BaseModel','-v7.3')
    end
end
return
end