function YamlData = MyReadYaml(filename)
yamlString = fileread(filename);
yamlString = strrep(yamlString,'!!python/unicode','');
fid = fopen('test_yaml.yaml','w');
fwrite(fid,yamlString,'char')
fclose(fid)
% yamlCell = splitlines(yamlString);
% channels
% description
% duration
% samplerate

return
end