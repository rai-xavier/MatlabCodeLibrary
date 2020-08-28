function TitleAsFileName(filename)
[~,filename,~] = fileparts(filename);
mytitle = strrep(filename,'_','-');
try
sgtitle(mytitle);
catch
    title(mytitle);
end
return
end