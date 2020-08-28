function CenterLegend(legend_cell)
L = legend(legend_cell, 'Orientation','horizontal');
L.Units = 'normalized';
L.Position(1) = 0.15; % left
L.Position(2) = 0; % bottom
% Position = [left bottom width height]
return
end