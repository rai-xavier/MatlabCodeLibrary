outterdir = 'Y:\Household Sound classification\DCASE_Xavier_v2\babycry_v1\results';
% last edit to any matlab scripts: 8/15/19
% TrainingScript_L1 -> DCASE_Training_Object??

%%
outterdir = 'Y:\Household Sound classification\DCASE_Xavier_v2\babycry_v2\results';
% traiing scripts? 8/20/19
%%
mydir = dir(outterdir);
dirstats = struct;
for ii=3:length(mydir)
    if not(mydir(ii).isdir); continue; end
    newdirpath = fullfile(mydir(ii).folder, mydir(ii).name);
    newdir = dir(newdirpath);
    idx_png = contains({newdir.name},'.png');
    
    dirstats(end+1).SubDir = mydir(ii).name;
    dirstats(end).NumTestFiles = sum(idx_png);
    disp('')
     
end

dirstats = struct2table(dirstats(2:end));
% dirstats.numTXT = cell2mat(dirstats.numTXT);