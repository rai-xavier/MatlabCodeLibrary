datadir = '';
ResampleRates = [333,167,83,42];
x1 = {};
for ii=1:length(ResampleRates)
    load(fullfile(datadir,['HData_' num2str(ResampleRates(ii))]));
    x1{ii} = HData;
    clear HData
end
%%
for rr = 1:size(x1{1}{1},1)
    dock(1,'Audio Segment');clf
    dock(2, 'Freq. Spectrum');clf
    plotnum = 1;
    for ii=1:length(ResampleRates)
        x2 = cellfun(@(hdata) hdata(1,:), x1{ii},'UniformOutput',false);
        for jj=1:length(x2)
            
            figure(1)
            subplot(length(ResampleRates),length(x2),plotnum)
            plot(x2{jj})
            title(['Chan' num2str(jj) ', Resample to ' num2str(ResampleRates(ii)) ' Hz'])
            axis tight
            
            figure(2)
            subplot(length(ResampleRates),length(x2),plotnum)
            f = fft(x2{jj});
            f = f(1:ceil(end/2));
            f = abs(f);
            plot(f)
            xticks(sort(round(ResampleRates/2)))
            xlabel('Hz')
            title(['Chan' num2str(jj) ', Resample to ' num2str(ResampleRates(ii)) ' Hz'])
            axis tight
            
            plotnum = plotnum+1;
        end
    end
    
    figure(1); sgtitle('Audio');
    figure(2); sgtitle('Spectrum')
    breakflag = input('');
    if not(isempty(breakflag)); break; end
    
    disp('')
    
    
end