
function FBins = calculateFreqBins(Fs,Nfft)
% Nfft ~ window length
% Fs ~ sample rate
FNyq = 0.5*Fs; % Nyquist frequency
% FreqBinWidth = FNyq/Nfft;
% FBins = (0:(Nfft-1))*FreqBinWidth;
FBins = linspace(0,FNyq, ceil(Nfft/2));
return
end