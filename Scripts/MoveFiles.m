src = {...
    'Y:\Household Sound classification\DCASE\transfer_DCASE_data_with_meta.m',...
    'Y:\Household Sound classification\DCASE_Xavier_v2\babycry_v1\extract_clean_events.m',...
    'Y:\Household Sound classification\DCASE_Xavier_v2\babycry_v1\PredictThisTrack_L1.m',...
    'Y:\Household Sound classification\DCASE_Xavier_v2\Add_Training_Data\learnerSmoothing1.m',...
    };
dstdir = 'Y:\Household Sound classification\Revisit Babycry 7-31-20\transfer-files';
MakeFolder(dstdir)

for ss=1:length(src)
    
   [~,fn,ext] = fileparts(src{ss});
   dst = fullfile(dstdir, [fn ext]);
   copyfile(src{ss},dst)
    

end