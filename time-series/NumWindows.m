function numOfFrames = NumWindows(win,step,varargin)
if length(varargin{1}) > 1
    L = length(varargin{1});
else
    L = varargin{1};
end
numOfFrames = floor((L-win)/step)+1;

return
end