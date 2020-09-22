% restoredefaultpath
newpaths = {};
newpaths{end+1,1} = '/home/xgutierrez/Hopper';
newpaths{end+1,1} = '/home/xgutierrez/HopperUtilities';

matlablibpath = genpath('/home/xgutierrez/MatlabCodeLibrary');
matlablibpath = split(matlablibpath,pathsep);
% remove git
idx_git = contains(matlablibpath,'git');
matlablibpath(idx_git) = [];
% remove empty
idx_empty = strcmp(matlablibpath,'');
matlablibpath(idx_empty) = [];
newpaths = [newpaths;matlablibpath];
for n = 1 : length(matlablibpath); 
	disp(['Adding to MatLab path: ' newpaths{n}])
	addpath(newpaths{n},'-begin'); 
end

savepath /usr/local/MATLAB/R2017a/toolbox/local/pathdef.m


% pathToPoolProfile = '/home/matlab/Hopper/HopperController_v1_522_Compiled_08_20_20/Cloud_Cluster_Profile.settings';
% %import the saved cluster
% parallel.importProfile(pathToPoolProfile);
% parallel.defaultClusterProfile('Cloud_Cluster_Profile');
% %store the cluster in the variable myClust
% myClust = parcluster('Cloud_Cluster_Profile');
% parpool(myClust,numWorkers);
