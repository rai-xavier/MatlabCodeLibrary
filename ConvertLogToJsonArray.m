function ConvertLogToJsonArray(jsonFilePath)

try

    jsonData = ReadJson(jsonFilePath);
    disp('Hopper log can be read as json array')

catch ME
    
    logFileString = fileread(jsonFilePath);
    logFileCell = splitlines(logFileString);
    idx_start = find(contains(logFileCell, 'JSON tasks array'));
    idx_start = min(idx_start);
%     HopperOutputString('LOG', 'Hopper log converted to Json array file', 'FUNCTION', true)
    logFileCell = logFileCell(idx_start:end);
    jsonArrayString = ['[' newline];
    jsonArrayString = [jsonArrayString char(join(logFileCell(1:end-1), [', ' newline]))];
    jsonArrayString = [jsonArrayString logFileCell{end}];
    jsonArrayString = [jsonArrayString ']'];
    fid = fopen(jsonFilePath, 'w');
    fwrite(fid, jsonArrayString, 'char');
    fclose(fid);
end


return
end