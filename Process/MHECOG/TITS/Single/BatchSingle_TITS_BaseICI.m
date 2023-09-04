close all; clc; clear;

addpath(genpath("I:\Programe\ECOGProcess"), "-begin");
rmpath(genpath("I:\Programe\Tool_box"));

MonkeyID = 1;
Protocol = 'TITS_in_BasClick';

if MonkeyID == 1
    monkeyStr = 'CC';
    DATEStrs = {'cc20230323', 'cc20230324_1', 'cc20230324_2', 'cc20230327_1', 'cc20230327_2',...
        'cc20230328_1', 'cc20230401', 'cc20230403', 'cc20230408_1', 'cc20230408_2',...
        'cc20230410_1', 'cc20230410_2','cc20230414_1', 'cc20230415_1', 'cc20230419_1',...
        'cc20230505_2', 'cc20230620', 'cc20230626', 'cc20230627'};
    MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\chouchou\';
%     DATEStrs = {'cc20230426_1', 'cc20230426_3', 'cc20230427_1', 'cc20230505_1'};
%     MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat_Nodft\chouchou\';   
elseif MonkeyID == 2
    monkeyStr = 'XX';
%     DATEStrs = {'xx20230323', 'xx20230324_1', 'xx20230324_2', 'xx20230328_1',...
%         'xx20230401_1', 'xx20230401_2', 'xx20230401_3', 'xx20230408_1', 'xx20230408_2',...
%         'xx20230410_1', 'xx20230410_2', 'xx20230414_1', 'xx20230415_1', 'xx20230418',...
%         'xx20230424'};
%     MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\xiaoxiao\';
    DATEStrs = {'xx20230425_1', 'xx20230425_2', 'xx20230505', 'xx20230508_1', 'xx20230508_2',...
        'xx20230509_2', 'xx20230510_1', 'xx20230510_2', 'xx20230516'};
    MATPATH = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat_Nodft\xiaoxiao\';    
end
MATPATHs = cellfun(@(x) [MATPATH, x, '\'], DATEStrs, "UniformOutput", false);


ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
params.posIndex = 1; % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;

% Synchronize response index
SRIMethod = 2;
CRIMethod = SRIMethod;
if SRIMethod == 1
    SRIMethodStr = 'Resp_devided_by_Spon';
elseif SRIMethod == 2
    SRIMethodStr = 'R_minus_S_devide_R_plus_S';
end
SRIScale = [0.8, 2; 0 0.2];
SRITest = [1, 0];
pBase = 0.05;

% FFT method
FFTMethod = 3; %1: power(dB); 2: magnitude; 3:amplitude
fftScale = [60, 60; 450, 450; 10, 10];
% correspFreq = 1000./repmat(8000, 1, 12);
icaOpt = "on";
badCH_self = {[], []};
flp_filte = 10;
fhp_filte = 0.1;
segOption = ["trial onset", "dev onset"];
s1OnsetOrS2Onset = 1; % 1, s1onset; 2, s2Onset


AREANAME = ["AC", "PFC"];
AREANAME = AREANAME(params.posIndex);

fs = 1000;

badCh = {[], []};

for mIndex = 19%1 : length(DATEStrs)

    temp = string(split(MATPATH, '\'));
    FIGPATH = [ROOTPATH, 'Single_Figure3_DiffICI\', SRIMethodStr, '\', monkeyStr, '\', DATEStrs{mIndex}, '\'];
    mkdir(FIGPATH);
    %% process
    run("Y_CTLConfig.m");
    run("tb_loadsingleData.m");
    run("tb_ICA.m");
%     run("tb_chPatch.m");
    run("tb_interpolateBadChs");
    trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp_filte, flp_filte, fs);
    if controlflag
        if exist(strcat(FIGPATH, "GroupMessage.mat"), "file")
            load(strcat(FIGPATH, "GroupMessage.mat"));
        else
            Test_Control_PairGroup = validateInput('Input Pair group typenum({[Test_typenum, Control_typenum]}, eg:{[1,2],[3,4]}): ', ...
            @(x) validateattributes(x, {'cell'}, {'2d'}));  
            save(strcat(FIGPATH, "GroupMessage.mat"), "Test_Control_PairGroup");
        end

        for gIndex = 1 : numel(Test_Control_PairGroup)
            Test_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(1);
            Control_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(2);
        end
    end
%% diff stim type
    devType = unique([trialAll.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
    for dIndex = 1:length(devType) 
        run("difftypestim_analysis_nofilter.m");%head and tail跟随反应
        run("difftypestim_analysis_filter.m");
    end
    %% CRI significance(change response)
    run("TITS_BaseICI_compute_CRI.m");
    run("TITS_BaseICI_CRI_significance.m");
    %% compare and plot rawWave
    run("Raw_Wave_Plot.m");%no filter(取2个窗口主要看跟随反应)
    run("Raw_Wave_filter_Plot.m");%filter(取整段主要change反应)
    %% 
    %% plot FFT_raw wave
%     run("FFT_Wave_Plot.m");


%% save
ResName_cdrPlot = strcat(FIGPATH, "cdrPlot_fft(", string(FFTMethod), ")_", AREANAME, ".mat");
save(ResName_cdrPlot, "cdrPlot", "-mat");
ResName_CRI = strcat(FIGPATH, "CRI_", AREANAME, ".mat");
save(ResName_CRI, "CRI", "-mat");

end
close all;
