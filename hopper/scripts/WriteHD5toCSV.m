%Read and decode the json string in jsonPath
jsonDir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\Rheem Test Data 1 OD_OK 1sec Subset 1000';
jsonFile = 'jsonString_local.json';
jsonString = fileread(fullfile(jsonDir,jsonFile));
jsonData = jsondecode(jsonString);

csvdir = fullfile(jsonDir,'HD5-CSV_500SUBSET');
MakeFolder(csvdir);

i = 1;
CSVData = checkJSONField(jsonData(i),'pathToIndexCSV');
RawData = checkJSONField(jsonData(i),'pathToData');
GroupColumn = checkJSONField(jsonData(i),'groupColumn');
WindowLength = checkJSONField(jsonData(i),'windowLength');
UniqueIdentifier = checkJSONField(jsonData(i),'uniqueIdentifier');
[HData, HLabels, HGroups, HIdx] =  ConvertDataFromHD5andCSVToHopperFormat(RawData, CSVData, GroupColumn, WindowLength, UniqueIdentifier);
%%
hcounts = histcounts(HLabels);
numOfEachClass = round( min(hcounts)/4 );
[HData,HLabels] = GET_HOPPER_DATA_SUBSET(HData,HLabels,numOfEachClass);
%%
for f=1:length(HLabels)
    displayLoopIteration(1,length(HLabels),f)
    OutCSV = table();
    for c=1:length(HData)
        OutCSV = [OutCSV table(HData{c}(f,:)')];
    end
    OutCSV.Class = repmat(HLabels(f),height(OutCSV),1);
    writetable(OutCSV, fullfile(csvdir, [NUM2STR_ZEROPAD(f,4) '.csv']) )
end
