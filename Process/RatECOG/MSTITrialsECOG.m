function [trialAll, trialsECOG, trialsECOG_Lag, chIdx, fs] =MSTITrialsECOG(MATPATH, params, MSTIparams)
narginchk(2, 3);
if nargin < 3
    Protocol = evalin("base", "ProtocolStr");
    run("MSTIParamsSetting_ECOG.m");
else
    parseStruct(MSTIparams);
end
%% Parameter settings
temp = string(split(MATPATH, '\'));
Protocol = temp(end - 1);

segOption = ["trial onset", "dev onset"];
flp = 300;
fhp = 0.1;
tTh = 0.1;
chTh = 0.1;

%% Processing
[trialAll, ECOGDataset] = ECOGPreprocess(MATPATH, params);
fs = ECOGDataset.fs;
trialAll(1) = [];
trialAll([trialAll.devOrdr] == 0) = [];
trialAll(end) = [];
OnsetTemp = {trialAll.soundOnsetSeq}';
ordTemp = {trialAll.ordrSeq}';
if contains(Protocol, "Change") || contains(Protocol, "Insert")
    temp = cellfun(@(x) x + ClickTrainDur1, OnsetTemp, "UniformOutput", false);
    trialAll = addFieldToStruct(trialAll, temp, "devOnset");
elseif contains(Protocol, "Oscillation")

elseif contains(Protocol, "MSTI")
    temp = cellfun(@(x, y) MSTIsoundinfo(x).Std_Dev_Onset(end) + y, ordTemp, OnsetTemp, "UniformOutput", false);
    trialAll = addFieldToStruct(trialAll, temp, "devOnset");
end

% filter
ECOGFDZ = mFTHP(ECOGDataset, fhp, flp);% filtered, dowmsampled, zoomed
if contains(Protocol, "Change") || contains(Protocol, "Insert") || contains(Protocol, "MSTI")
    trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(2), devonset_Win);
elseif contains(Protocol, "Oscillation")
    trialsECOG = selectEcog(ECOGFDZ, trialAll, segOption(1), trialonset_Win);
end
%% lag
if contains(Protocol, "MSTI")
    tSD = round(diff(cell2mat({MSTIsoundinfo.Std_Dev_Onset})) / 1000 * fs);
    trialsECOG_Lag = cellfun(@(x, y) [zeros(size(x, 1), tSD(end, y)), x(:, 1:end-tSD(end, y))], trialsECOG, ordTemp, "UniformOutput", false);
end
%%
[tIdx, chIdx] = excludeTrials(trialsECOG, tTh, chTh);
trialsECOG(tIdx) = [];
trialsECOG_Lag(tIdx) = [];
trialAll(tIdx) = [];




