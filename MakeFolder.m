function MakeFolder(folderpath,varargin)
if not(isempty(varargin))
    terminal_mode = varargin{1};
else
    terminal_mode = false;
end

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