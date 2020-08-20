function TDemin = DeminSeries(T,WinSz)
TDemin = NaN(WinSz-1,1);
for istop = WinSz:length(T)
    istart = istop - WinSz + 1;
    TDemin(end+1)= T(istop) - min( T(istart:istop) );
end
return
end