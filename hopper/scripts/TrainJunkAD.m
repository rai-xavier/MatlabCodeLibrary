%% hopper parameters

% features
A = split('A1 A2 A3 A4 A5 A6',' ');
BA = cellfun(@(x) ['B' x], A,'UniformOutput',false);
C = split('C1 C2 C3 C4 C5 C6 C7',' ');
BC = cellfun(@(x) ['B' x], C,'UniformOutput',false);
FeatureSpaces = [A;BA;C;BC;{'E1C1'};{'E2C1'}]';
% FeatureSpaces = {'A1','C1','E1C1'};

% models
ModelType = {'STA_RBF_OVO_AUTO'}; 
% looking @ the AD-methods, apparently it uses 'AUTO' as well

%% Data

WinSz = 2^15;
Fs = 16e3;
t = (1:WinSz);
A1 = 1; f1 = 1/WinSz; w1 = A1 * sin( 2 * pi * f1 * t' );
A2 = 2; f2 = 2/WinSz; w2 = A2 * sin( 2 * pi * f2 * t' );

dock(1);clf
subplot(211); plot(w1); title("w1")
subplot(212); plot(w2); title("w2")

HData = { ...
    [ repmat( w1 ,5,1);...
      repmat( w2 ,5,1);...
      repmat( w1 ,5,1) ] ...
      };
% 0 ~ train-normal
% 1 ~ test-anomaly
% 2 ~ test-normal
HLabels = [zeros(5,1);ones(5,1);2*ones(5,1)];

%% Initialize Hopper
H = HopperSVM(...
    'Data', HData, ...
    'MetaData', HLabels, ...
    'FeatureNames',FeatureSpaces, ...
    'ModelNames', ModelType);

%% Training (classifier)
if false
    myflag = 1;
    % next 3 cases are equivalent
    switch myflag
        case 1
            % each subsequent method can determine if the previous methods were already called
            H = H.H_FEATURE_EXTRACTORS();
            H = H.H_TRAIN_MODELS(1);
            H = H.H_RESUB();
            H = H.H_KFOLD();
            
        case 2
            H = H.H_RESUB();
            H = H.H_KFOLD();
            
        case 3
            H = H.H_KFOLD();
    end
end

%% Anomaly Detection
[H,OutlierIdx,ResultTable,upper] = H.ANOMALY_DETECTOR();
H.PLOT_ANOMALY(); % original version
H.PLOT_ANOMALY2(); % updated 
% 