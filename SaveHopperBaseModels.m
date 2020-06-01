function SaveHopperBaseModels(H, varargin)

if ischar(H)
    
    HopperModelPath = H;
    [ModelDir,ModelFileName,ext] = fileparts(HopperModelPath);
    if not(isempty(varargin))
        BaseModelDir = varargin{1};
    else
        BaseModelDir = fullfile(ModelDir,'BaseModels');
    end
    MakeFolder(BaseModelDir);
    disp(['Loading ' HopperModelPath])
    H = load(HopperModelPath);
    mat_vars = fields(H);
    idx_h = find(contains(mat_vars,'H'));
    if length(idx_h)>1
        syslog(strcat("Multiple 'H_'-variables found in filepath: ", string(mat_vars(idx_h))),'w');
        return
    end
    H = H.(mat_vars{idx_h});
else
    if not(isempty(varargin))
        BaseModelDir = varargin{1};
        MakeFolder(BaseModelDir);
    else
        syslog('Provided Hopper-object without BaseModelDir','w')
        return
    end
end
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
            syslog(['File already exists (skip) : ' BaseModelPath])
            continue
        end
        syslog(BaseModelPath,'s')
        save(BaseModelPath,'H_BaseModel','-v7.3')
    end
end
return
end