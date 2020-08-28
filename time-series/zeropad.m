function padded_array = zeropad(myarray,padsize)
if not(any(size(myarray)==1))
    error('1D input array required')
end
sz = size(myarray);

numzeros = padsize - length(myarray);

if sz(1) >= sz(2) % col vector
    padded_array = [myarray;zeros(numzeros,1)];
else % row vector
    padded_array = [myarray,zeros(1,numzeros)];
end

return
end