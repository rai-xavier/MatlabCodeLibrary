function stepseries = step(myseries)
prev = myseries(1:end-1);
cur =  myseries(2:end);
% next = myseries(3:end); next(end+1) = NaN
stepseries = (cur - prev) ./ prev ;
return
end