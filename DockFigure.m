function DockFigure(varargin)
if TerminalMode;    return;     end

try
    if not(isempty(varargin))
        fignum = varargin{1};
        f = figure(fignum);
    else
        f = figure();
    end
    
    set(f,'WindowStyle','docked');
catch ME
    
end
return
end
