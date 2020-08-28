function newsignal = myDownsample(signal, oldSampleRate, sampleRate)

[q,p] = rat(oldSampleRate/sampleRate);

newsignal = resample(signal, p, q);

return
end