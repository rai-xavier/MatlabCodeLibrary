function subDir = extractSubDir(fullPath,varargin)
    if isempty(varargin); n = 1; end
    fullPath = split(fullPath,filesep);
    subDir = join(fullPath(1:end-n),filesep);
return
end