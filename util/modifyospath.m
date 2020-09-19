function path = modifyospath(path)

if ispc
   path = strrep(path,'/Volumes/','//abyss1/');
   path = strrep(path,'/','\');
else
    path = strrep(path,'\\abyss1\','\Volumes\');
    path = strrep(path,'\','/');
end

return
end