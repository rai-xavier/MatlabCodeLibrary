%% plot filter bank as gif
% fn_gif = ['Z:\Hopper_Dev\dev-xavier\Mel-NFilts' num2str(nfilts) '-' num2str(samplerate) 'Hz.gif'];
% if exist(fn_gif,'file'); delete(fn_gif); end

% initialize params
FOPTIONS = struct('SampleRate',16e3,'NFFT',2^15);
% calculate max num mel-filters
FOPTIONS.NumFilts = CalculateMaxMelFilts(FOPTIONS.NFFT,FOPTIONS.SampleRate);
FOPTIONS.NumFilts = FOPTIONS.NumFilts + 25;
% calculate mel-spectrum-filterbank
[FOPTIONS.MelFilterBank, FOPTIONS.MelBins, FOPTIONS.HzBinsMelScale] = computeMelFilterBank( FOPTIONS.SampleRate, FOPTIONS.NumFilts , FOPTIONS.NFFT );

dock(1);clf
FPS = FOPTIONS.NumFilts/2;
for n = 1 : FOPTIONS.NumFilts
    melfilt = FOPTIONS.MelFilterBank(n,:);
    plot(FOPTIONS.HzBins,melfilt)
    ylim([0 1]); ylabel('Filter-Weight')
    xlim([0 (FOPTIONS.SampleRate/2)]); xlabel('Hz');
    title({...
        ['Filt ' num2str(n)],...
        ['CenterFrequency = ' num2str(FOPTIONS.HzBins(n+1)) ' Hz'],...
        ['# NonZero = ' num2str(nnz(melfilt))] ...
        })
    %     SaveFrameToGIF(get(gcf,'Number'),n, fn_gif, FPS)
    pause(1/FPS)
end
%% filterbank heatmap

% initialize params
FOPTIONS = struct('SampleRate',16e3,'NFFT',2^15);
% calculate max num mel-filters
FOPTIONS.NumFilts = CalculateMaxMelFilts(FOPTIONS.NFFT,FOPTIONS.SampleRate);
% calculate mel-spectrum-filterbank
[FOPTIONS.MelFilterBank, FOPTIONS.MelBins, FOPTIONS.HzBinsMelScale] = computeMelFilterBank( FOPTIONS.SampleRate, FOPTIONS.NumFilts , FOPTIONS.NFFT );
% make plot title
mytitle={};
mytitle{end+1} = ['Fs = ' num2str(FOPTIONS.SampleRate/1e3) 'kHz, NFFT = ' num2str(FOPTIONS.NFFT) ];
mytitle{end+1} = ['# Mel-Filts (max) = ' num2str(FOPTIONS.NumFilts)];
mytitle{end+1} = ['Filter Bank Dims = ' num2str(size(FOPTIONS.MelFilterBank))];
% plot heatmap
dock(2);clf
imagesc( logical( FOPTIONS.MelFilterBank ) );
xlabel('Freq Bin #'); ylabel('Filter #')
title(mytitle)
% save
saveas(gcf,fullfile('Z:\Hopper_Dev\dev-xavier\Feature-Optimization','Mel-FilterBank-HeatMap.png'))

%% calculate dimension reduction
SampleRate = 16e3;
% winlen/nfft
pow2 = 8:2:32;
WinLen = 2.^pow2;
NFFT = 0.5*WinLen;
mylog2nfftlabels = string(log2(NFFT));
% max num filts
MaxNumFilts = CalculateMaxMelFilts(NFFT,SampleRate);
mylog2numfiltslabels = string( round(log2(MaxNumFilts),1) );
% dimensionality reduction
Ratio = NFFT./MaxNumFilts;
myratioyticks = sort(unique(round(Ratio,1)));
myratioyticks = myratioyticks(1:4);
% plot
dock(3);clf
subplot(211); plot(NFFT,MaxNumFilts,'-*');
    % x
    set(gca, 'XScale', 'log');
    set(gca,'XMinorTick','off');
    xlabel('log2 of NFFT = WinLen/2');
    xticks(NFFT);    xticklabels(mylog2nfftlabels);
    % y
    set(gca, 'YScale', 'log');
    set(gca,'YMinorTick','off');
    yticks(round(MaxNumFilts,1));
    ylabel('log2 of MaxNumFilts'); yticklabels(mylog2numfiltslabels)
subplot(212); plot(NFFT,Ratio,'-*');
    % x
    set(gca, 'XScale', 'log');
    set(gca,'XMinorTick','off');
    xlabel('log2 of NFFT = WinLen/2');
    xticks(NFFT);    xticklabels(mylog2nfftlabels);
    % y
    set(gca, 'YScale', 'log');
    set(gca,'YMinorTick','off');
    ylabel('NFFT / MaxNumFilts')
    yticks(myratioyticks);  yticklabels(myratioyticks)
sgtitle({['Fs = ' num2str(SampleRate/1e3) 'kHz'],'Mel Scale Feature Dimension Reduction'})
% save
saveas(gcf,fullfile('Z:\Hopper_Dev\dev-xavier\Feature-Optimization','Mel-Scale-Feature-DR.png'))

%% validate filterbank spacing

% initialize params
FOPTIONS = struct('SampleRate',16e3,'NFFT',2^15);
% calculate max num mel-filters
FOPTIONS.NumFilts = CalculateMaxMelFilts(FOPTIONS.NFFT,FOPTIONS.SampleRate);
FOPTIONS.NumFilts = FOPTIONS.NumFilts + 25;
% calculate mel-spectrum-filterbank
[FOPTIONS.MelFilterBank, FOPTIONS.MelBins, FOPTIONS.HzBinsMelScale] = computeMelFilterBank( FOPTIONS.SampleRate, FOPTIONS.NumFilts , FOPTIONS.NFFT );
% calculate full-spectrum freq-bins
FOPTIONS.HzBins = linspace(0,0.5*FOPTIONS.SampleRate, ceil(FOPTIONS.NFFT/2));
% make plot title
mytitle={};
mytitle{end+1} = ['Fs = ' num2str(FOPTIONS.SampleRate/1e3) 'kHz, NFFT = ' num2str(FOPTIONS.NFFT) ];
mytitle{end+1} = ['# Mel-Filts (max) = ' num2str(FOPTIONS.NumFilts)];
mytitle{end+1} = ['Filter Bank Dims = ' num2str(size(FOPTIONS.MelFilterBank))];
% find peakloc of each mel-filter
filtnum = [];
peaklocs = [];
for n = 1 : FOPTIONS.NumFilts
    peakloc = find(FOPTIONS.MelFilterBank(n,:)==1);
    filtnum = [filtnum;repmat(n,length(peakloc),1)];
    peaklocs = [peaklocs;peakloc];
end
% find distance between peaks of adjacent mel-filters
peakdists = diff(peaklocs);
% calculate distribution of distances
udists = unique(peakdists);
hcounts = histcounts(peakdists);
% plot
dock(4);clf
subplot(311); plot(filtnum(1:end),peaklocs); xlabel('filter #'); ylabel('peak-loc')
subplot(312); plot(filtnum(2:end),peakdists); xlabel('filter #');ylabel('dist-btwn-peaks')
% subplot(413); plot(filtnum(2:end),peakdists>0); xlabel('filter #'); ylim([-1 2]); yticks([0 1]); yticklabels({'peak-dist <= 0','peak-dist > 0'}); ytickangle(0)
subplot(313); bar(hcounts); xticks(1:length(udists)); xticklabels(udists); xlabel('peak-dists'); ylabel('# bands')
sgtitle(mytitle)
% save
saveas(gcf,fullfile('Z:\Hopper_Dev\dev-xavier\Feature-Optimization','Mel-FilterBank-Distribution.png'))

%% find filterbanks with empty filters

if false
    MaxNumFilts = CalculateMaxMelFilts(FOPTIONS.NFFT,FOPTIONS.SampleRate);
    FOPTIONS = struct('SampleRate',16e3,'NFFT',2^15);
    for nf = 7290:1:7300
        disp(nf)
        [FOPTIONS.MelFilterBank, FOPTIONS.MelBins, FOPTIONS.HzBinsMelScale] = computeMelFilterBank( FOPTIONS.SampleRate, nf, FOPTIONS.NFFT );
        
        NumNonZero = [];
        for n = 1 : nf
            NumNonZero(n) = nnz(FOPTIONS.MelFilterBank(n,:));
        end
        if any(NumNonZero ==0)
            dock
            plot(FOPTIONS.HzBinsMelScale, NumNonZero);
            xlabel('Triangle   Filter   Peak   [Hz]');
            ylabel('# NonZero FilterWeights')
            title(['# Filts = ' num2str(nf)])
            disp(['No Filter Weights found using NumFilts = ' num2str(nf)])
            break
        end
    end
end