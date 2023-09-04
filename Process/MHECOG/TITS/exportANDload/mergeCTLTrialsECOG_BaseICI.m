function [trialAll, trialsECOG, trialsECOG_S1, chIdx] = mergeCTLTrialsECOG_BaseICI(MATPATH, posIndex, CTLParams)
narginchk(2, 3);
if nargin < 3
    Protocol = evalin("base", "Protocol");
    run("CTLconfig.m");
else
    parseStruct(CTLParams);
end
%% Parameter settings
params.posIndex = posIndex; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;

segOption = ["trial onset", "dev onset"];

% tTh = 0.1;
% chTh = 0.1;

%% Processing
[trialAll, ECOGDataset] = ECOGPreprocess(MATPATH, params);
trialAll(1) = [];
trialAll([trialAll.devOrdr] == 0) = [];
trialAll(end) = [];
devType = unique([trialAll.devOrdr]);
devTemp = {trialAll.devOnset}';

temp = cellfun(@(x, y) x + changepoint{y}, devTemp, {trialAll.ordrSeq}', "UniformOutput", false);
trialAll = addFieldToStruct(trialAll, temp, "devOnset");

% filter
ECOGFDZ = mFTHP(ECOGDataset, fhp_export, flp_export);% filtered, dowmsampled, zoomed
% ECOGFDZ = ECOGResample(ECOGFDZ, fs);
trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(2), Window);
trialsECOG_S1 = selectEcog(ECOGFDZ, trialAll, segOption(1), Window);

[tIdx, chIdx] = excludeTrials(trialsECOG, tTh, chTh);
trialsECOG(tIdx) = [];
trialsECOG_S1(tIdx) = [];
trialAll(tIdx) = [];
