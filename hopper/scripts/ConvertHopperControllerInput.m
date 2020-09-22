%% baseToolPath
baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\9-22 NoHData';
src = 'jsonString.json';
%% re-write to local json

% fn
jsonInitFilePathSrc = fullfile(baseToolPath,src);
dst = strrep(src,'.json','_local.json');
jsonInitFilePathDst = fullfile(baseToolPath,dst);
% json-data
jsonInitData = ReadJson(jsonInitFilePathSrc);
jsonInitData = swapDirs(jsonInitData,baseToolPath);
% write dst
jsonInitString = jsonencode(jsonInitData);
fid = fopen(jsonInitFilePathDst,'w');
fwrite(fid, jsonInitString,'char');
fclose(fid);

%% re-name hd5
mydir = dir(baseToolPath);
mydir = struct2table(mydir);
idx_hd5 = contains(mydir.name,'hd5');
srcfn = mydir.name{idx_hd5};
src = fullfile(baseToolPath, srcfn);
dst = fullfile(baseToolPath, 'convertedData.hd5');
movefile(src,dst)

%% swapDirs()

function jsonCommand = swapDirs(jsonCommand,newdir)
myfields = {'pathToIndexCSV','pathToData','forPrediction','baseToolPath'};
for ff=1:length(myfields)
    mypath = jsonCommand.(myfields{ff});
    if isempty(mypath); continue; end
    [olddir,fn,ext] = fileparts(mypath);
    jsonCommand.(myfields{ff}) = fullfile(newdir, [fn ext]);
end
return
end
