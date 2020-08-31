function MakeFolder(varargin)
% if isempty(folderpath);return;end


for i = 1:length(varargin)
    folderpath = varargin{i};
    [~,~,thisext]=fileparts(folderpath);
    if not(isempty(thisext)) && not(strcmp(thisext,""))
        folderpath = fileparts(folderpath);
    end
    if not(exist(folderpath, 'dir'))
        mkdir(folderpath)
    end
    
end


return
end