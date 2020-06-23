function ConfusionMat = getHopperFeatConfMat(HopperTable,ModelType,Feat,Training)
% Hopper Table
% ModelType: STA_LIN_OVO, etc.
% Feat: A1, A2, etc
% Training: KFold/Resub

AllFeats = H.HopperModels.Properties.RowNames;
idx_feat = strcmp(AllFeats,Feat);
switch lower(Training)
    case 'resub'
        confmatfield = 'ResubConfusionMat';
    case 'kfold'
        confmatfield = 'KFoldConfusionMat';
end
ConfusionMat = HopperTable.(ModelType)(idx_feat).(confmatfield);
return
end
