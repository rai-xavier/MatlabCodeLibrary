function highlightbars(b,varargin)

switch class(b)
    case 'matlab.graphics.chart.primitive.Histogram'
        histhighlight(b,varargin{:})
    case 'matlab.graphics.chart.primitive.Bar'
        barhighlight(b,varargin{:})
end
return
end

function barhighlight(b,varargin)
b.FaceColor = 'flat';
if isempty(varargin)
    RAIBlue1 = [0.165,0.655,0.875];
    RAIOrange = [0.961,0.569,0.130];
    color = RAIBlue1;
else
    color = varargin{1};
end

for i = 1:size(b.CData)
    b.CData(i,:) = color;
end
return
end


function histhighlight(b,varargin)
if isempty(varargin)
    RAIBlue1 = [0.165,0.655,0.875];
    RAIOrange = [0.961,0.569,0.130];
    color = RAIBlue1;
else
    color = varargin{1};
end
b.FaceColor = color;
return
end