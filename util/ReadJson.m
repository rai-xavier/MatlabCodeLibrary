function jsonData = ReadJson(jsonFilePath)
jsonString = fileread(jsonFilePath);
jsonData = jsondecode(jsonString);
return
end