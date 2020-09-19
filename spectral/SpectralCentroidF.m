function C = SpectralCentroidF(y,winsz, stepsz, sr, fstartinhz, fstopinhz,varargin)


% normalize sig
y = y / max(abs(y));

% segmentation params
cur = 1;
L = length( y );
numOfFrames = floor( (L-winsz) / stepsz ) + 1;
H = hamming( winsz );

% fft params
nfft = 2 * winsz;
fnyq = round( sr/2 );
fbins = calculateFreqBins( sr, nfft );


[~,fstart] = FindClosestVal( fbins, fstartinhz );
[~,fstop] = FindClosestVal( fbins, fstopinhz );

% calculate weights
wts = linspace(0,fnyq,nfft);
wts = wts(fstart:fstop)';
% wts = wts/fnyq;
% dock(3);subplot(3,1,wtsflag);plot(wts)

% normflag
normflag = 0;
if not(isempty(varargin)); normflag = varargin{1};end
    
% calculate spectral centroid
C = zeros(numOfFrames,1);
for i=1:numOfFrames
    
    % grab seg
    seg = y(cur:cur+winsz-1);
    seg = H.*seg;
    
    % fft
    f = fft(seg,nfft);
    f = abs(f(1:ceil(nfft/2)));
    
    % normalize f
    switch normflag
        case 1; f = f / max(f);
        case 2; f = f / sum(f);
    end
    
    % bandpass
    f = f(fstart:fstop);
    
    % weighted sum
    C(i) = sum(wts.*f);

    % magnitude filter
    %     if (sum(window.^2)<0.010)
    %         C(i) = 0.0;
    %     end
    
    % next step
    cur = cur + stepsz;
end

% normalize C
C = C / fnyq;


return
end