function C = SpectralCentroidF(y,winsz, stepsz, sr, fstartinhz, fstopinhz)
nfft = 2*winsz;
fbins = calculateFreqBins(sr,nfft);
[~,fstart] = FindClosestVal(fbins,fstartinhz);
[~,fstop] = FindClosestVal(fbins,fstopinhz);

y = y / max(abs(y));
cur = 1;
L = length(y);
numOfFrames = floor((L-winsz)/stepsz) + 1;
H = hamming(winsz);
% numwts = ceil(nfft/2); wts = ((sr/(2*winsz))*[1:numwts])'; wts = wts(fstart:fstop);
numwts = fstop-fstart+1; wts = ((sr/(2*winsz))*[1:numwts])';
C = zeros(numOfFrames,1);
for i=1:numOfFrames
    window = H.*(y(cur:cur+winsz-1));
    FFT = abs(fft(window,nfft));
    FFT = FFT(1:ceil(nfft/2));
    FFT = FFT / max(FFT);
    FFT = FFT(fstart:fstop);
    C(i) = sum(wts.*FFT)/sum(FFT);
    %     if (sum(window.^2)<0.010)
    %         C(i) = 0.0;
    %     end
    cur = cur + stepsz;
end
C = C / (sr/2);
return
end