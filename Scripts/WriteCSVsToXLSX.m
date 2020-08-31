%% MasterTestResults_1HzPlusMic
projectdir = 'Y:\Rheem\IndoorPrognostics\PWIPartitions2';
dst = fullfile(projectdir,'MasterTestResults_1HzPlusMic.xlsx');
mode = ["Cool"];
for pp=1:5
    filedir = fullfile(projectdir ,['P' num2str(pp)],mode);
    fn = fullfile(filedir, 'MasterTestResults_1HzPlusMic.csv');
    if not(isfile(fn));continue;end
    disp(pp)
    T = readtable(fn);
    T = movevars(T, 'Feat', 'Before', 'WinSz');
    T = movevars(T, 'Fulldata', 'Before', 'Holdout');
    T = movevars(T, 'Mode', 'Before', 'MicNum');
    T = movevars(T, 'P', 'Before', 'MicNum');
    T.Resub = round(100*T.Resub,2);
    T.Fulldata = round(100*T.Fulldata,2);
    T.Holdout = round(100*T.Holdout,2);
    T.MaxHoldoutEnvCondn = round(T.MaxHoldoutEnvCondn,2);
    T.MinHoldoutEnvCondn = round(T.MinHoldoutEnvCondn,2);
    T = sortrows(T,'MinHoldoutEnvCondn','descend');
    writetable(T,dst,'Sheet',['P' num2str(pp)]);
end

%% BestOfSummary_1HzPlusMic
projectdir = 'Y:\Rheem\IndoorPrognostics\PWIPartitions2';
dst = fullfile(projectdir,'BestOfSummary_1HzPlusMic.xlsx');
mode = ["Cool"];
for pp=1:5
    filedir = fullfile(projectdir ,['P' num2str(pp)],mode);
    fn = fullfile(filedir, 'BestOfSummary_1HzPlusMic.csv');
    if not(isfile(fn));continue;end
    disp(pp)
    T = readtable(fn);
    T = movevars(T, 'Feat', 'Before', 'WinSz');
    T = movevars(T, 'Fulldata', 'Before', 'Holdout');
    T = movevars(T, 'Mode', 'Before', 'MicNum');
    T = movevars(T, 'P', 'Before', 'MicNum');
    T.Resub = round(100*T.Resub,2);
    T.Fulldata = round(100*T.Fulldata,2);
    T.Holdout = round(100*T.Holdout,2);
    T.MaxHoldoutEnvCondn = round(T.MaxHoldoutEnvCondn,2);
    T.MinHoldoutEnvCondn = round(T.MinHoldoutEnvCondn,2);
    writetable(T,dst,'Sheet',['P' num2str(pp)]);
end

