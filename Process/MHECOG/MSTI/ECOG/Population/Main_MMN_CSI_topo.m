   close all; clc; clear;
%%%%%%%%%%%Fig.MSTI:CSI Topo
addpath(genpath("I:\Programe\ECOGProcess"), "-begin");
rmpath(genpath("I:\Programe\Tool_box"));

AREAS = ["AC", "PFC"];
NAMES = ["cc", "xx"];
AREASindex = 1;
NAMESindex = 2;
areaSel = AREAS(AREASindex);
monkeyName = NAMES(NAMESindex);
rootPathFig = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTI\';

CSIWin = [0 200];% 0 for dev onset

%% set protocols
temp = dir(rootPathFig);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
% areaSel = "AC";
dateSel = [""];
protSel = [""];

for rIndex = 1 : length(protocols)

    protPath = strcat(rootPathFig, protocols(rIndex), "\");
    protPath = protPath(contains(protPath, protSel));
    protocolStr = strrep(protocols(rIndex), 'Figure_', '');

    %% Single day
%     run("MMN_CSI_topo_sig.m");
    %% Batch
    run("MMN_CSI_topo_pop.m");
end


