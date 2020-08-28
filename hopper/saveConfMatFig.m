function saveConfMatFig(ConfusionMat, ModelFilePath, labelmap, varargin)
% ConfusionMat: numeric 2d arr
% ModelFilePath: full path to hopper model
% labelmap: for confmat fig labels
% varargin: {'C5','Resub'}
[thisdir,ConfMatFile,~] = fileparts(ModelFilePath);
ConfMatFile = [ConfMatFile '_' char(join(varargin,'_'))];
plotConfusionMatrix(ConfusionMat, labelmap);
SetCMtoRAIcolors
title(strrep(ConfMatFile,'_','-'))
saveas(gcf, fullfile(thisdir,[ConfMAtFile '.png']) )
close('all')
return
end