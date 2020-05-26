function MakeFolder(folderpath)

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