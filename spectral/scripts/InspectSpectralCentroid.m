
%    '\\abyss1\Customer_Data\BabyCry\FreeSound\baby_crying_LicenseCreativeCommons0\151079__picklejones__01-baby-with-hiccups.wav'

%% do calculations
x = [1:size(y)];
windowsize = round(0.04*fs);
overlap = round(0.75*windowsize);
stepsize = windowsize - overlap;
rms = movingRMS(y, windowsize, overlap, 0);
rms_norm = rms / max(rms); threshold_norm = threshold / max(rms);
numwindows = length(rms);

t_signal = [1:length(y)] / fs;
t_windowed  = [windowsize:stepsize:(numwindows*stepsize + windowsize- 1)] / fs;
%% plot
dock();clf

subplot(611);
plot(t_windowed,rms);
axis tight;
title('rms')

subplot(612);
specwin = round( 0.25*fs );
specoverlap = round( 0.75*specwin );
spectrogram(y,specwin,specoverlap,[],fs,'yaxis');
axis tight;
colorbar('off');
title('spectrogram')

subplot(613);
sc = SpectralCentroid(y, windowsize, stepsize,fs);
plot(t_windowed,sc);
axis tight;
%         ylim([ 0 1])
title('spectral-centroid')

subplot(614);
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,1);
plot(t_windowed,sc);
axis tight;
%         ylim([ 0 1])
title('spectral-centroid-bandpass-1')

subplot(615);
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,2);
plot(t_windowed,sc);
axis tight;
%         ylim([ 0 1])
title('spectral-centroid-bandpass-2')

subplot(616);
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,3);
plot(t_windowed,sc);
axis tight;
%         ylim([ 0 1])
title('spectral-centroid-bandpass-3')

%%
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,1);
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,2);
sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2,3);

%%


        dock(20);clf
        numplots = 4;
        
        subplot(numplots,1,1)
        sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2);
        plot(t_windowed,sc); 
        title('spectral-centroid')
        axis tight
        
        subplot(numplots,1,2)
        scdiff = diff(sc);
        plot(t_windowed(2:end), abs(scdiff))
        title('spectral-centroid-diff')
        axis tight

        subplot(numplots,1,3)
        scstep = step(sc);
        plot(t_windowed(2:end), abs(scstep))
        title('spectral-centroid-step-ratio')
        axis tight

        subplot(numplots,1,4)
        scflipstep = step( flip( sc ) ) ;
        scflipstepflip = flip( scflipstep );
        plot(t_windowed(2:end), abs(scflipstepflip))
        title('spectral-centroid-step-ratio-rev')
        axis tight
        
        %%
        
        sc = SpectralCentroidF(y, windowsize, stepsize,fs,500,fs/2); mytitle='raw';
%         sc = DeminSeries(sc,5);mytitle ='demin';
        % diff
        scdiff = diff(sc);
        scdiffrev = flip( diff( flip( sc ) ) );
        % step-ratio
        scflipstep = step( flip( sc ) ) ;
        scflipstepflip = flip( scflipstep );

        dock();clf
        numplots = 3;
        
        subplot(numplots,1,1)
        plot( t_windowed, sc ); 
        title('spectral-centroid')
        axis tight
        
        subplot(numplots,1,2)
        plot( t_windowed(2:end), abs(scdiff) )
        title('spectral-centroid-diff')
        axis tight

        subplot(numplots,1,3)
        plot( t_windowed(2:end), abs( scflipstep ) )
        title('spectral-centroid-step-ratio')
        axis tight
        
        sgtitle(mytitle)
        
        %%
        x1 = abs(scdiff) / max(abs(scdiff));
        x2 = rms/max(rms);
        mycorr = x1 .* x2(2:end)' ;
        
        dock
        numplots = 4;
        subplot(numplots,1,1); plot(x1)
        subplot(numplots,1,2); plot(x2)
        subplot(numplots,1,3); plot(mycorr)
        subplot(numplots,1,4); plot(log10(mycorr))



        
        