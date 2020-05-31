function TogglePlotting(plot_flag)
switch plot_flag
    case 0; plot_flag = 'off';
    case 1; plot_flag = 'on';
end
set(groot,'DefaultFigureVisible',plot_flag)
return
end