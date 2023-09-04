function [trialAll, trialsECOG] = mergeMSTIomiTrialsECOG(MATPATH, posIndex, MSTIParams, sound)
narginchk(2, 4);
if nargin < 3
    run("CTLconfig.m");
else
    parseStruct(MSTIParams);
end
%% Parameter settings
params.posIndex = posIndex; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;

temp = string(split(MATPATH, '\'));
Protocol = temp(end - 2);
segOption = ["trial onset", "dev onset"];

%% Processing
[trialAll, ECOGDataset] = ECOGPreprocess(MATPATH, params, "patch", "matchIssue");
trialAll(1) = [];
trialAll([trialAll.devOrdr] == 0) = [];
trialAll(end) = [];
devType = unique([trialAll.devOrdr]);
stdTemp = {trialAll.soundOnsetSeq}';
devTemp = {trialAll.devOnset}';
if contains(Protocol, "MSTI")
    [~, ordTemp] = ismember([trialAll.ordrSeq]', devType);
    ordTemp = num2cell(ordTemp);
end
temp = cellfun(@(a,b) a + b,...
       {trialAll.soundOnsetSeq}',...% ms
       cellfun(@(x) sound(x).Std_Dev_onset(end) * 1000, ordTemp, "UniformOutput", false),...
       "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "dida_daOffset");
trialAll = addFieldToStruct(trialAll, temp, "devOnset");
temp = cellfun(@(a,b) a + b,...
       {trialAll.dida_daOffset}',...% ms
       cellfun(@(x) sound(x).dida_Duration(1) * 1000, ordTemp, "UniformOutput", false),...
       "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "omissionPoint");



% filter
ECOGFDZ = mFTHP(ECOGDataset, fhp, flp);% filtered, dowmsampled, zoomed
trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(2), Window);
[trialsECOG, ~, idx] = excludeTrialsChs(trialsECOG, 0.2);
trialAll = trialAll(idx);
end