function [L,T] = getSegmentLabelsFromStartStop(mylen,istart,istop, WinSz,StepSz, MinOverlap)

T = window_data(1:mylen,WinSz,StepSz);
overlap = (T >= istart) & (T <= istop);
overlap_percent = sum(overlap,2)/WinSz;
L = overlap_percent >= MinOverlap;
T = T(:,end);

return
end