function DockFigure(varargin)
if TerminalMode;    return;     end

if not(isempty(varargin))
    fignum = varargin{1};
    f = figure(fignum);
else
    f = figure();
end

set(f,'WindowStyle','docked'); 
return
end
