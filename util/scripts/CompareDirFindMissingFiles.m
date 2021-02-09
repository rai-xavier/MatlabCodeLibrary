dirpath1 = 'Z:\Rheem\Field-Trials\prognostics-01\AudioFiles\';
dirpath2 = 'Z:\Rheem\Field-Trials\prognostics-01\AudioFiles\WAV';

dir1 = struct2table(dir(dirpath1));
dir2 = struct2table(dir(dirpath2));
[~,fn1,~] = cellfun(@fileparts,dir1.name,'UniformOutput',false);
[~,fn2,~] = cellfun(@fileparts,dir2.name,'UniformOutput',false);

if height(dir1) > height(dir2)
    idxmissing = find(not(ismember(fn1,fn2)));
    MissingFiles = dir1(idxmissing,:);
else
    idxmissing = find(not(ismember(fn2,fn1)));
    MissingFiles = dir2(idxmissing,:);
end