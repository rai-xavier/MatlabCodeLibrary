function [ClosestValue,ClosestValueIdx] = FindClosestVal(myarray,myvalue)

[~,ClosestValueIdx] = min(abs(myarray - myvalue));
ClosestValue = myarray(ClosestValueIdx);

return
end