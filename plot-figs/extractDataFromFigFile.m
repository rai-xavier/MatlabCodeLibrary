function [x,y] = extractDataFromFigFile(figpath)
openfig(figpath);
h = findobj(gca, 'Type','line');
x = get(h,'XData');
y = get(h,'YData');
return
end