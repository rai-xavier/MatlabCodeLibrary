clc;clearvars;close('all')

%% Paths
projectdir = 'C:\wrk\Ripple\';
modeldir = fullfile(projectdir,'Results-WinExplore');

csvdir = fullfile(projectdir, '01-Cmpr_Rslts_Test_20200615\Pre-Segmented\');
mydir=dir(csvdir);

%% Loop CSVs
durations = [];
for ii=1:length(mydir)
    [~,fn,ext]=fileparts(mydir(ii).name);
    if not(contains(ext,'csv'));continue;end
    % read table
    T = readtable(fullfile(csvdir,mydir(ii).name));
    durations(ii) = T.Time(end) - T.Time(1);
end
DockFigure(1)
histogram(durations)

[minval,minidx] = min(durations(not(durations==0)))