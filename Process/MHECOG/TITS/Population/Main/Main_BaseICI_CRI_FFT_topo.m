close all; clc; clear;
%%%%%%%%%%%Fig1.BaseICI:CRI
addpath(genpath("I:\Programe\ECOGProcess"), "-begin");
rmpath(genpath("I:\Programe\Tool_box"));
ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
MonkeyID = 1;
params.posIndex = 1; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;
AREANAME = ["AC", "PFC"];
AREANAME = AREANAME(params.posIndex);
stimStrs = ["2_2o04ms", "3_3o06ms", "4o5_4o59ms", "6o8_6o936ms", "10o1_10o302ms", "12o4_12o648ms",...
    "15o2_15o504ms", "18o6_18o972ms", "22o8_23o256ms", "34o2_34o884ms"];
Protocol = 'TITS_in_BasClick';

if MonkeyID == 1
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'BaseICI', 'A2:D5');
    monkeyStr = 'CC';
elseif MonkeyID == 2
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'BaseICI', 'A6:D11');   
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

% FFT method
FFTMethod = 3; %1: power(dB); 2: magnitude; 3:amplitude
fftScale = [60, 60; 450, 450; 10, 10];
% CRI
quantWin_new = [0 300];%反应窗口
sponWin_new = [-300 0];%基线窗口
CRIScale = {[0.8, 2; -0.1 0.7], [0.8, 2; -0.1 0.3]};
badCH_self = {[], []};badCh = {[], []};
flp_filte = 10;
fhp_filte = 0.1;
icaOpt = "on";

%% Single day
% for mIndex = 1 : length(DATEStrs)
%     clear temp maxnum minnum temp_zscore
%     
%     FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
%     FIGPATH_CRIsig = [FIGPATH, 'Population\CRI\'];
%     FIGPATH_localrawsig = [FIGPATH, 'Population\local_fft_raw\'];
%     FIGPATH_localzscoresig = [FIGPATH, 'Population\local_fft_zscore\'];
%     mkdir(FIGPATH);mkdir(FIGPATH_CRIsig);mkdir(FIGPATH_localrawsig);mkdir(FIGPATH_localzscoresig);
% 
%     % process
%     fs = fs_temp(mIndex);
%     run("tb_loadsingleData.m");
%     run("tb_ICA.m");
%     run("tb_interpolateBadChs");
%     trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
%     run("BaseICI_CRI_FFT_topo_sigplot.m");
%     %% save
%     ResName_cdrPlot = strcat(FIGPATH, "cdrPlot_fft(", string(FFTMethod), ")_", AREANAME, ".mat");
%     save(ResName_cdrPlot, "cdrPlot", "-mat");
%     ResName_CRI = strcat(FIGPATH, "CRI_", AREANAME, ".mat");
%     save(ResName_CRI, "CRI", "-mat");
%     close all;
% end

%% Batch 
FIGROOTPATH = [ROOTPATH, 'Population_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\BaseICI\'];
trialsECOG_pop = []; trialsECOG_pop_Filtered = []; trialAll_pop = [];
fs_pop = 1000;
fs = fs_pop;
indexpool = find(fs_temp == fs_pop);
for Index = 1:numel(indexpool)
    mIndex = indexpool(Index);
    clear temp maxnum minnum temp_zscore
    FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    FIGPATH_CRI = strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\CRI\');
    FIGPATH_localraw = strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\local_fft_raw\');
    FIGPATH_localzscore = strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\local_fft_zscore\');
    mkdir(FIGPATH_CRI);mkdir(FIGPATH_localraw);mkdir(FIGPATH_localzscore);
    % process
    run("tb_loadsingleData.m");
    run("tb_ICA.m");
    run("tb_interpolateBadChs");
    trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
    trialsECOG_Merge_temp = trialsECOG_Merge;
    trialAll_temp = trialAll;
    trialsECOG_pop = [trialsECOG_pop; trialsECOG_Merge_temp];
    trialsECOG_pop_Filtered = [trialsECOG_pop_Filtered; trialsECOG_Merge_Filtered];
    trialAll_pop = [trialAll_pop; trialAll_temp];

end
    run("BaseICI_CRI_FFT_topo_popplot.m");
    % save
    save(strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\', 'CRI_pop.mat'), "CRI");
    save(strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\', 'cdrPlot_pop.mat'), "cdrPlot_pop");
    save(strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\', 'cdrPlot_pop_tunning.mat'), "cdrTunning_CRI", "cdrTunning_CRIRandom", "cdrTunning_head", "cdrTunning_tail",...
        "CRI_mean_se", "CRIRandom_mean_se", "topo_head_mean_se", "topo_tail_mean_se");  
    