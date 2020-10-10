c = 343;
micdist = 0.044;
% dphi = pi;
% max_cycle = 0.5;
% lambdamin = max_cycle*micdist
% fmax = c/lambdamin
%%

% f ~ spectrum, len = nfft/2
% f_complex ~ complex spectrum, len = nfft/2
% fbin ~ bin num, [1,nfft/2]
% freq ~ frequency in Hz, [0,samplerate/2]

calc_phi = @(f_complex,fbin) angle(f_complex(fbin));
calc_arcratio = @(dphi,freq) (dphi * c) ./ (2*pi * micdist *freq);

calc_dphi = @(aoa,f) 2*pi*f*micdist*sin(aoa)/c;
calc_max_dphi = @(f) (2*pi*micdist/c)*f;
calc_max_aoa = @(f) asind(c./(f.*2.*micdist));

%%

f = 700:1600;
max_dphi = calc_max_dphi(f);
arcratio = calc_arcratio(max_dphi,f);
aoa = asind(arcratio);

dock(1);clf
subplot(211)
plot(f,max_dphi,'-*')
xlabel('f [Hz]'); ylabel('max(dphi) [rad]'); title('max phase difference')
subplot(212)
plot(f,aoa)
xlabel('f (Hz)'); ylabel('aoa'); title('max angle of arrival')


%%

dock(2);clf

N = 4;
f_arr = linspace(700,1600,N);
aoa = -90:90; 

for n = 1 : N
    
    dphi = calc_dphi(aoa,f_arr(n));
    dphi = dphi/pi;
    
    max_dphi = calc_max_dphi(f_arr(n));
    max_dphi = max_dphi/pi;
    
    subplot(2,2,n); plot(aoa,dphi); yline(max_dphi); yline(-1*max_dphi); yline(0);
    ylabel('dphi [\pi]'); ylim([-1 1]); xlabel('aoa [deg]'); 
    title({['Frequency = ' num2str(f_arr(n))],['max(dphi) = ' num2str(max_dphi)]})
end


%%

dock(3);clf

% calculate
f = 700:1600;
max_aoa = calc_max_aoa(f);
dphi=[];
for n=1:length(f); dphi(n) = calc_dphi(abs(max_aoa(n)),f(n)); end
dphi = dphi/pi;

% plot f vs max_aoa
subplot(211); plot(f,max_aoa); xlabel('f [Hz]'); ylabel('max(aoa) [deg]');

% plot f vs dphi
subplot(212); plot(f,dphi); xlabel('f [Hz]'); ylabel('dphi [\pi]');