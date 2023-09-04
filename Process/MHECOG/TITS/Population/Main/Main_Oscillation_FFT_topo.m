   close all; clc; clear;
%%%%%%%%%%%Fig3.Oscillation:FFT
addpath(genpath("I:\Programe\ECOGProcess"), "-begin");

MonkeyID = 2;
ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
params.posIndex = 1; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;
AREANAME = ["AC", "PFC"];
AREANAME = AREANAME(params.posIndex);
Protocol = 'TITS_in_Osc';

if MonkeyID == 1
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'Oscillation', 'A2:D4');
    monkeyStr = 'CC';
elseif MonkeyID == 2
    [~,~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_TITS.xlsx',...
        'Oscillation', 'A5:D9');   
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
FFTMethod = 3; %1: power(dB); 2: magnitude; 3: amplitude
fftScale = [60, 60; 450, 450; 10, 10];
% CRI
quantWin_new = [0 300];%反应窗口
sponWin_new = [-300 0];%基线窗口
CRIScale = {[0.8, 2; -0.1 0.7], [0.8, 2; -0.1 0.3]};
badCH_self = {[], []};
badCh = {[], []};
flp_filte = 10;
fhp_filte = 0.1;
icaOpt = "on";

%% Single day
% for mIndex = 1 : length(DATEStrs)
% 
%     FIGPATH = [ROOTPATH, 'Single_Figure6_Osci_Control\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
%     FIGPATH_rawsig = [FIGPATH, 'Population\fft_raw\'];
%     FIGPATH_zscoresig = [FIGPATH, 'Population\fft_zscore\'];
%     mkdir(FIGPATH);mkdir(FIGPATH_rawsig);mkdir(FIGPATH_zscoresig);
% 
%     %% process
%     fs = fs_temp(mIndex);
%     run("tb_loadsingleData.m");
%     run("tb_ICA.m");
%     run("tb_interpolateBadChs");
%     trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, CTLparams.fs);
%     run("Oscillation_FFT_topo_sigplot.m");
%     %% save
%     save(strcat(FIGPATH, 'FFT(', string(FFTMethod), ')cdrPlot_', AREANAME, '.mat'), "cdrPlot");
%     save(strcat(FIGPATH, 'cdrPlot_fft(', string(FFTMethod), ')tunning_', AREANAME, '.mat'), "cdrTunning_TB", "cdrTunning_ICI1", "cdrTunning_ICI2",...
%         "topo_TB_mean_se", "topo_ICI1_mean_se", "topo_ICI2_mean_se");  
% end

%% Batch
FIGROOTPATH = [ROOTPATH, 'Population_Figure6_Osci_Control\', SRIMethodStr, '\', monkeyStr, '\'];
trialsECOG_pop = []; trialAll_pop = [];
fs_pop = 1200;
fs = fs_pop;
indexpool = find(fs_temp == fs_pop);
for Index = 1:numel(indexpool)
    mIndex = indexpool(Index);
    clear temp maxnum minnum temp_zscore
    FIGPATH = [ROOTPATH, 'Single_Figure6_Osci_Control\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    FIGPATH_raw = strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\fft_raw\');
    FIGPATH_zscore = strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\fft_zscore\');
    mkdir(FIGPATH_raw);mkdir(FIGPATH_zscore);
    %% process
    run("tb_loadsingleData.m");
    run("tb_ICA.m");
    run("tb_interpolateBadChs");
    trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
    trialsECOG_Merge_temp = trialsECOG_Merge;
    trialAll_temp = trialAll;
    trialsECOG_pop = [trialsECOG_pop; trialsECOG_Merge_temp];
    trialAll_pop = [trialAll_pop; trialAll_temp];

end
    run("Oscillation_FFT_topo_popplot.m");
    % save
    save(strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\', 'FFT(', string(FFTMethod), ')cdrPlot_pop_', AREANAME, '.mat'), "cdrPlot_pop");
    save(strcat(FIGROOTPATH, 'fs_', string(fs_pop), '\', 'cdrPlot_pop_fft(', string(FFTMethod), ')tunning_', AREANAME, '.mat'), "cdrTunning_TB", "cdrTunning_ICI1", "cdrTunning_ICI2",...
        "topo_TB_mean_se", "topo_ICI1_mean_se", "topo_ICI2_mean_se");  




