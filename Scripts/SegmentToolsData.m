jsondir = '';
CSVData = readtable(fullfile(jsondir,'.csv'));
RawData = h5read(fullfile(jsondir,'.hd5'), '/dataset0')';
[HData, HLabels, HGroups, HIdx] =  ConvertDataFromHD5andCSVToHopperFormat(RawData, CSVData, [], 256, 'BroseRadar');
