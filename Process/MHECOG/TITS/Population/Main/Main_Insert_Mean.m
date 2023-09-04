close all; clc; clear;
%%%%%%%%%%%Fig2.Insert:CSI
addpath(genpath("I:\Programe\ECOGProcess"), "-begin");

ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
MonkeyID = 1;

params.posIndex = 1; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;
Test_Control_PairGroup = {[2,1],[3,1],[4,1],[5,1]};
AREANAME = ["AC", "PFC"];
AREANAME = AREANAME(params.posIndex);
Protocol = 'TITS_in_BasClick';
protStr = Protocol;

if MonkeyID == 1
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'Insert', 'A2:D4');
    monkeyStr = 'CC';
elseif MonkeyID == 2
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'Insert', 'A6:D8');   
    monkeyStr = 'XX';  
end
monkeyName = RawMessage(:,1);
DATEStrs = RawMessage(:,2);
MATPATH = RawMessage(:,3);    
fs_temp = cell2mat(RawMessage(:,4));
MATPATHs = cellfun(@(x, y, z) [x, '\', y, '\', z, '\'], MATPATH, monkeyName, DATEStrs, "UniformOutput", false);

% Synchronize response index
SRIMethod = 2;
CRIMethod = SRIMethod;
if SRIMethod == 1
    SRIMethodStr = 'Resp_devided_by_Spon';
elseif SRIMethod == 2
    SRIMethodStr = 'R_minus_S_devide_R_plus_S';
end
%others
badCH_self = {[], []};badCh = {[], []};
yScale = [25 35];
flp_filte = 40;
fhp_filte = 0.1;
RMS_window = [0 300];
icaOpt = "on";

%% Single day
% for mIndex = 4:length(DATEStrs)
%     FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
%     FIGPATH_Insertsig = [FIGPATH, 'Population\Insert\'];
%     mkdir(FIGPATH);mkdir(FIGPATH_Insertsig);
%     %% process
%     fs = fs_temp(mIndex);
%     run("tb_loadsingleData_insert.m");
%     run("tb_ICA.m");
%     run("tb_interpolateBadChs");
%     trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
% 
%     run("Insert_Mean_sigplot.m");
% end

%% Batch
FIGROOTPATH = [ROOTPATH, 'Population_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\'];
FIGPATH_Insert0 = [FIGROOTPATH, 'Insert\'];
trialsECOG_pop = []; trialsECOG_pop_Filtered = []; trialAll_pop = [];
fs_pop = 1000;
fs = fs_pop;
indexpool = find(fs_temp == fs_pop);

for Index = 1:numel(indexpool)
    mIndex = indexpool(Index);
    clear temp maxnum minnum temp_zscore
    FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    FIGPATH_Insert = strcat(FIGPATH_Insert0, 'fs_', string(fs), '\');
    mkdir(FIGPATH_Insert);
    %% process
    run("tb_loadsingleData_insert.m");
    run("tb_ICA.m");
    run("tb_interpolateBadChs");
    trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
    trialsECOG_Merge_temp = trialsECOG_Merge;
    trialsECOG_Merge_Filtered_temp = trialsECOG_Merge_Filtered;
    trialAll_temp = trialAll;
    trialsECOG_pop = [trialsECOG_pop; trialsECOG_Merge_temp];
    trialsECOG_pop_Filtered = [trialsECOG_pop_Filtered; trialsECOG_Merge_Filtered_temp];
    trialAll_pop = [trialAll_pop; trialAll_temp];

end
run("Insert_Mean_popplot.m");
run("Insert_Meanminus_popplot.m");
%% save
save(strcat(FIGPATH_Insert, "popMean_CDRplot.mat"), "popCDRplot");
save(strcat(FIGPATH_Insert, "popMeanminus.mat"), "minusStim", "minusStim_filte", "CH_minusRMS", "CHmean_minusRMS", "CHse_minusRMS");





