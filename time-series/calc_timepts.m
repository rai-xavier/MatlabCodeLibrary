function timepts = calc_timepts(stepsize, windowsize, len, varargin)

if not(isempty(varargin))
    startsamp = varargin{1};
else
    startsamp = 1;
end

timepts = startsamp:stepsize:(len-windowsize);

return
end