function fullscreen(varargin)
if not(isempty(varargin))
    fignum = varargin{1};
    f=figure(fignum);
else
    f = figure();
end
set(f,'WindowStyle','normal')
set(f, 'units','normalized')
set(f,'outerposition',[0 0 1 1])
drawnow
return
end