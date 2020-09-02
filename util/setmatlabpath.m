restoredefaultpath

hopperpath = '/home/xgutierrez/Hopper';
addpath(hopperpath)

hopperutilpath = '/home/xgutierrez/HopperUtilities';
addpath(hopperutilpath)

matlablibpath = '/home/xgutierrez/MatlabCodeLibrary';
% matlablibpath = '\\abyss1\Active_Projects\MATLAB-CodeLibraries\MatLabCodeLibraryRepo';
matlablibpath = split(genpath(matlablibpath),';');
idx_git = contains(matlablibpath,'git');
matlablibpath(idx_git) = [];
matlablibpath = char(join(matlablibpath,';'));
addpath(matlablibpath)



savepath


% pathToPoolProfile = '/home/matlab/Hopper/HopperController_v1_522_Compiled_08_20_20/Cloud_Cluster_Profile.settings';
% %import the saved cluster
% parallel.importProfile(pathToPoolProfile);
% parallel.defaultClusterProfile('Cloud_Cluster_Profile');
% %store the cluster in the variable myClust
% myClust = parcluster('Cloud_Cluster_Profile');
% parpool(myClust,numWorkers);
