function TitleAsFileName(filename)
[~,filename,~] = fileparts(filename);
mytitle = strrep(filename,'_','-');
sgtitle(mytitle);
return
end