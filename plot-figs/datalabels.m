function datalabels(b,varargin)
switch class(b)
    case 'matlab.graphics.chart.primitive.Histogram'
        histdatalabels(b,varargin{:})
    case 'matlab.graphics.chart.primitive.Bar'
        bardatalabels(b,varargin{:})
    case 'matlab.graphics.scatter';
        % do something
end
return
end

%%
function bardatalabels(b,varargin)
for i=1:length(b) % loop through series (grouped by rows)
    numpts = length(b(i).XData);
    for n = 1:numpts
        datatip(b(i),'DataIndex',n); % create datatip
    end
    b(i).DataTipTemplate.DataTipRows(1) = []; % remove x coord from datatip
    b(i).DataTipTemplate.DataTipRows.Label = ''; % remove "Y: " from datatip
end
return
end

%%
function histdatalabels(b,varargin)
    if nargin>=2; keepbinlabels = varargin{1};else;keepbinlabels=false;end
    if nargin>=3; labelfontsz = varargin{2};else;labelfontsz=false;end

for i=1:length(b) % loop through series (grouped by rows)
    
    % create datatips
    numpts = length(b(i).Values);
    for n = 1:numpts
        if logical(b(i).Values(n)); datatip(b(i),'DataIndex',n); end
    end
    
    if keepbinlabels
        % remove "Value: " & "BinEdges: " label
        for j = 1:length(b(i).DataTipTemplate.DataTipRows)
            b(i).DataTipTemplate.DataTipRows(j).Label = ''; 
        end
    else
        b(i).DataTipTemplate.DataTipRows(2) = []; % remove bin edges
        b(i).DataTipTemplate.DataTipRows.Label = ''; % remove "Value: " from datatip
    end
    
    if labelfontsz
        b(i).DataTipTemplate.FontSize = labelfontsz;
    end
end

return
end