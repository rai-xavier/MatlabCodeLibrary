%% load
load(fullfile(debugdir,'dev','HopperData.mat'),'HDataTrain','HLabelsTrain','ClassMap','HGroupsTrain')
[HDataTrain,HLabelsTrain] = GET_HOPPER_DATA_SUBSET(HDataTrain,HLabelsTrain,round(500/length(ClassMap)));

%% make RawData + indexCSV + wavdir
RawData = {};
CSVData = struct;
MetaData = struct;
wavdir = fullfile(debugdir,'WAV'); MakeFolder(wavdir)
istart = 1;
for i=1:length(HLabelsTrain)
    dataseg = HDataTrain{1}(i,:);
    
    fn = [NUM2STR_ZEROPAD(i,3) '.wav'];
    MetaData(end+1).File = fn; 
    MetaData(end).Class = ClassMap{HLabelsTrain(i)};
    audiowrite(fullfile(wavdir, fn), dataseg, 1670)
    
    RawData{i,1} = transpose( dataseg );
    CSVData(end+1).group = i;
    CSVData(end).start = istart;
    CSVData(end).xEnd = istart + length(RawData{i}) - 1;
    CSVData(end).class = HLabelsTrain(i);
    CSVData(end).pdoId = num2str(i);
    istart = istart + length(RawData{i});
end

MetaData = struct2table(MetaData);
MetaData(1,:) = [];
writetable(MetaData,fullfile(debugdir,'MetaData.csv'))

CSVData = struct2table(CSVData);
CSVData(1,:) = [];
writetable(CSVData,pathToIndexCSV)

RawData = cell2mat(RawData);
save(pathToRawDataMat,'RawData','-v7.3')