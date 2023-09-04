function [trialAll, trialsECOG] = mergeMSTImultiBGTrialsECOG(MATPATH, posIndex, MSTIParams)
narginchk(2, 3);
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
temp = cellfun(@(x, y) x + Std_Dev_Onset{y}(end) * 1000, stdTemp, ordTemp, "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "devOnset");
temp = cellfun(@(x, y) x + Std_Dev_Onset{y}(1:end) * 1000, stdTemp, ordTemp, "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "soundOnsetSeq");


% filter
ECOGFDZ = mFTHP(ECOGDataset, fhp, flp);% filtered, dowmsampled, zoomed
trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(2), Window);
[trialsECOG, ~, idx] = excludeTrialsChs(trialsECOG, 0.2);
trialAll = trialAll(idx);
end