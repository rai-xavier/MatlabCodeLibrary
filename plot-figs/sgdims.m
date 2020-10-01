function [nrows,ncols] = sgdims(nplots)
% automate calculation of subplot grid dimensions when order doesn't matter
% nplots <= ncols * nrows
f = factor(nplots);
switch length(f)
    case 1 % 2 or prime
        nrows = ceil(sqrt(nplots));
        ncols = floor(sqrt(nplots));
        if nrows*ncols < nplots;  ncols = ceil(sqrt(nplots)); end
    case 2 % even number
        [nrows] = max(f);
        [ncols] = min(f);
    otherwise % non-prime odd
        midpt = ceil(length(f)/2);
        nrows = prod(f(1:midpt));
        ncols = prod(f(midpt+1:end));
end

% nf = [];
% for m = 1:100; nf(m) = length(factor(m)); end
% dock;plot(nf)

return
end