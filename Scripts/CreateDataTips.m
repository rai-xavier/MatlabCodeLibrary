b = bar(round(holdout,2));
for i=1:length(b) % loop through series (grouped by rows)
    for y = 1:2 % datatip each row in this series
        datatip(b(i),'DataIndex',[y]); % create datatip
    end
    b(i).DataTipTemplate.DataTipRows(1) = []; % remove x coord from datatip
    b(i).DataTipTemplate.DataTipRows.Label = ''; % remove "Y: " from datatip
end