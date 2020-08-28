function PlotClassBalance(fignum, HLabels, labelmap, ClassBalanceFigureFileName,varargin)
figure(fignum); clf; DockFigure(fignum);
histogram(HLabels);
xticks(unique(HLabels))
xticklabels(labelmap);
xtickangle(45)
ylabel('# Samples')
mytitle = {};
[~,mytitle{1},~] = fileparts(ClassBalanceFigureFileName);
mytitle{1} = strrep(mytitle{1},'_','-');
if not(isempty(varargin))
    mytitle{2} = varargin{1};
end
title(mytitle);
DockFigure(fignum)
end