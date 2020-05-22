function DockFigure(fignum)
global terminal_mode
if terminal_mode; return; end
figure(fignum);set(figure(fignum),'WindowStyle','docked'); 
return
end
