% plot
fn_gif = ['Z:\Hopper_Dev\dev-xavier\Mel-NFilts' num2str(nfilts) '-' num2str(samplerate) 'Hz.gif'];
if exist(fn_gif,'file'); delete(fn_gif); end
FBins = calculateFreqBins(samplerate,nfft);
FPS = nfilts/2;
for n = 1 : size(fbank,1)
    plot(FBins,fbank(n,:))
    ylim([0 1]); ylabel('Filter-Weight')
    xlim([0 (samplerate/2)]); xlabel('Hz');
    title({...
        ['Filt ' num2str(n)],...
        ['CenterFrequency = ' num2str(hz_points(n+1)) ' Hz'],...
        ['# NonZero = ' num2str(nnz(fbank(n,:)))] ...
        })
    SaveFrameToGIF(get(gcf,'Number'),n, fn_gif, FPS)
%     pause(0.1)
end