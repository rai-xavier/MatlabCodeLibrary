function MakeFolder(folderpath)
if isempty(folderpath);return;end
if iscell(folderpath);folderpath=string(folderpath);end


[folderpath,thisfn,thisext] = fileparts(folderpath);
if TerminalMode
    if not(exist(folderpath, 'dir'))
        mkdir(folderpath)
    end
else
    if not(isfolder(folderpath))
       mkdir(folderpath)
    end
end

return
end