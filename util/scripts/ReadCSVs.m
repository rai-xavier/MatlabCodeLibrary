clc;clearvars;close('all')

%% Paths
projectdir = '';

csvdir = fullfile(projectdir, '');
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