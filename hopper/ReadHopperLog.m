function hopperLogArray = ReadHopperLog(logFilePath)

logFileString = fileread(logFilePath);
logFileCell = splitlines(logFileString);
idx_empty = cellfun(@isempty,logFileCell);
logFileCell(idx_empty) = [];
idx_json = cellfun(@(x) strcmp(x(1),'{'),logFileCell);
logFileCell(not(idx_json)) = [];


idx_start = find(contains(logFileCell, 'JSON tasks array'));
idx_start = min(idx_start);
logFileCell = logFileCell(idx_start:end);
jsonArrayString = ['[' newline];
jsonArrayString = [jsonArrayString char(join(logFileCell(1:end-1), [', ' newline])) ', ' newline];
jsonArrayString = [jsonArrayString logFileCell{end}];
jsonArrayString = [jsonArrayString ']'];

hopperLogArray = jsondecode(jsonArrayString);
hopperLogArray = struct2table(hopperLogArray);
return
end