% jsondir = 'C:\wrk\dev-xavier\debug\7-17 SensorSpec\duplicate-results-2';
% logfilepath = fullfile(jsondir, 'HopperLog_ResampleCurve.txt');
% hopperLogArray = ReadHopperLog(logfilepath);

%% NumTasks
start_task =  hopperLogArray.Message( contains( hopperLogArray.Message, 'Executing JSON task') );
% NumTasks = sum(start_task);

%% ResampleRates
ResampleRates = hopperLogArray.Value( contains( hopperLogArray.Message, 'SampleRateNew') );
ResampleRates = cell2mat(ResampleRates);
[ResampleRates,sortidx] = sort(ResampleRates);

%% RESULT_TABLE
RESULT_TABLE =  hopperLogArray.Value( contains( hopperLogArray.MessageType, 'RESULT_TABLE') );

%% Plot Resub_Acc
Resub_Acc = cellfun(@(result_table) result_table.Resub_Acc, RESULT_TABLE);
Resub_Acc = Resub_Acc(sortidx);

dock
plot(ResampleRates, Resub_Acc, '-*'); xticks( sort( ResampleRates ) ); ylim([ 0 1]); ylabel('Resub Acc'); xlabel('ResampleRate')
mytitle = split(jsonDir,'\');
mytitle = mytitle{end};
title(mytitle)

%% Plot Kfold_Acc
KFold_Acc = cellfun(@(result_table) result_table.Kfold_Acc, RESULT_TABLE);
KFold_Acc = KFold_Acc(sortidx);

dock; 
plot(ResampleRates, KFold_Acc, '-*'); xticks( sort( ResampleRates ) ); ylim([ 0 1]); ylabel('KFold Acc'); xlabel('ResampleRate')
mytitle = split(jsonDir,'\');
mytitle = mytitle{end};
title(mytitle)

%% Plot Spectra

Spectra = hopperLogArray.Value( contains( hopperLogArray.Message, 'spectrum') );
Spectra = reshape(Spectra, length(Spectra)/length(ResampleRates), length(ResampleRates));
Spectra = Spectra';

dock;clf
nrows = length(ResampleRates);
ncols = size(Spectra,2);
for ii=1:nrows
    for cc=1:ncols
        plotnum = ncols*(ii-1) + cc;
        subplot(nrows,ncols,plotnum)
        FBins = calculateFreqBins(333,333);
        plot(FBins,Spectra{ii,cc});
        
        xticks( sort( ResampleRates/2 ) );
        axis tight
        title(['Chan' num2str(cc) ' (' num2str(ResampleRates(ii)) ' Hz)'])
    end
end