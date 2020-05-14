function SetFigureToFullScreen(fignum)
set(figure(fignum),'WindowStyle','normal')
set(figure(fignum), 'units','normalized')
set(figure(fignum),'outerposition',[0 0 1 1])
return
end