function SaveFigureFullScreen(fignum,FigureFileName)
SetFigureToFullScreen(fignum)
saveas(figure(fignum), FigureFileName )
DockFigure(fignum)
end
        