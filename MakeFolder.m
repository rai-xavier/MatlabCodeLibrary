function MakeFolder(folderpath)
global terminal_mode

if terminal_mode
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