loop = true;
while loop
    Fs = 20e3;
    xl = [];
    xl(1) = 0.05219;
    d = input('');
    xl(2) = xl(1) + d/Fs;
    
    subplot(311);
    xlim(xl)

%     loop = isempty(input(''));
end
        
    