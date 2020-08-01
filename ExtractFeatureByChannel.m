function HData = ExtractFeatureByChannel(HData, FeatSpaces, varargin)
if not(length(FeatSpaces) == length(HData))
    syslog('Required length(FeatSpaces) == length(HData)','x')
end

if nargin ==3; Options = varargin{1}; else; Options = []; end

for jj=1:length(HData)
    FeatModel = FEATURE_EXTRACTOR([],FeatSpaces{jj}, HData(jj),Options,[]);
    HData{jj} = FeatModel.NODR{1,1}.FeatureData;
    clear FeatModel
end

return
end
