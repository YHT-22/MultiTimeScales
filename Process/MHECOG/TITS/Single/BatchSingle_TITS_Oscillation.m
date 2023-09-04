   close all; clc; clear;

addpath(genpath("I:\Programe\ECOGProcess"), "-begin");

MonkeyID = 1;
Protocol = 'TITS_in_Osc';  

if MonkeyID == 1
    monkeyStr = 'CC';
%     DATEStrs = {'cc20230321','cc20230322', 'cc20230325_1', 'cc20230325_2', 'cc20230328_2', 'cc20230328_3',...
%         'cc20230329_1', 'cc20230329_2', 'cc20230330_1', 'cc20230330_2',...
%         'cc20230414_2', 'cc20230415_2', 'cc20230417', 'cc20230418_1', 'cc20230418_2',...
%         'cc20230419_2', 'cc20230419_3'};
%     MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\chouchou\';
    DATEStrs = {'cc20230426_2', 'cc20230427_2', 'cc20230502'};
    MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat_Nodft\chouchou\';  
elseif MonkeyID ==2
    monkeyStr = 'XX';
%     DATEStrs = {'xx20230321','xx20230322', 'xx20230327_1', 'xx20230327_2', 'xx20230328_2', 'xx20230328_3',...
%         'xx20230329', 'xx20230330_1', 'xx20230330_2', 'xx20230414_2', 'xx20230415_2',...
%         'xx20230417', 'xx20230419_1', 'xx20230419_2'};
%     MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\xiaoxiao\';
    DATEStrs = {'xx20230426_1', 'xx20230426_2', 'xx20230506', 'xx20230509_1', 'xx20230511'};
    MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat_Nodft\xiaoxiao\'; 
end
MATPATHs = cellfun(@(x) [MATPATH, x, '\'], DATEStrs, "UniformOutput", false);


ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
params.posIndex = 1; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;

% Synchronize response index
SRIMethod = 2;
if SRIMethod == 1
    SRIMethodStr = 'Resp_devided_by_Spon';
elseif SRIMethod == 2
    SRIMethodStr = 'R_minus_S_devide_R_plus_S';
end
SRIScale = [0.8, 2; 0 0.2];
SRITest = [1, 0];
pBase = 0.05;

% FFT method
FFTMethod = 2; %1: power(dB); 2: magnitude
fftScale = [60, 60; 350, 900];
icaOpt = "on";
badCH_self = {[], []};
flp = 10;
fhp = 1;
segOption = ["trial onset", "dev onset"];
s1OnsetOrS2Onset = 1; % 1, s1onset; 2, s2Onset
colors = ["#FF0000", "#FFA500", "#0000FF", "#000000", "#AAAAAA"];


AREANAME = ["AC", "PFC"];
AREANAME = AREANAME(params.posIndex);

fs = 1200;

badCh = {[], []};

for mIndex = 3%1 : length(DATEStrs)

    temp = string(split(MATPATH, '\'));
    if strcmp(Protocol, 'TITS_in_Osc')
        FIGPATH = [ROOTPATH, 'Single_Figure6_Osci_Control\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    elseif strcmp(Protocol, 'TITS_in_BasClick')
        FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    end
    mkdir(FIGPATH);
    %% process

    run("Y_CTLconfig.m");
    run("tb_loadsingleData.m");
    run("tb_ICA.m");
%     run("tb_chPatch.m");
    run("tb_interpolateBadChs");

    trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp, flp, fs);

%% diff stim type
    devType = unique([trialAll.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
    for dIndex = 1:length(devType)
        tIndex = [trialAll.devOrdr] == devType(dIndex);
        trials = trialAll(tIndex);
        run("TITS_Osc_difftypestim_analysis_filter.m");
        run("TITS_Osc_difftypestim_analysis_nofilter.m");
    end

    %% compare and plot rawWave
    run("Raw_Wave_Plot.m");
    run("Raw_Wave_filter_Plot.m");
    % plot raw wave
    run("FFT_Wave_Plot.m");

%% save
ResName = strcat(FIGPATH, "cdrPlot_", AREANAME, ".mat");

save(ResName, "cdrPlot", "Protocol", "-mat");
end
if ~isempty(gcp('nocreate'))
    delete(gcp('nocreate'));
end
close all
