function DockFigure(fignum)
global terminal_mode

figure(fignum);

if terminal_mode
    return; 
end

set(figure(fignum),'WindowStyle','docked'); 
return
end
