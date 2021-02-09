%% baseToolPath
baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\11-13 H2goError';
baseToolPath = 'Z:\Hopper_Dev\dev-xavier\ToolsDebug\11-13 Model_Path empty';
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
if any(idx_hd5)
    srcfn = mydir.name{idx_hd5};
    src = fullfile(baseToolPath, srcfn);
    dst = fullfile(baseToolPath, 'convertedData.hd5');
    movefile(src,dst)
end
%% swapDirs()


