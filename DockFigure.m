function DockFigure(fignum)

figure(fignum);

if TerminalMode
    return; 
end

set(figure(fignum),'WindowStyle','docked'); 
return
end
