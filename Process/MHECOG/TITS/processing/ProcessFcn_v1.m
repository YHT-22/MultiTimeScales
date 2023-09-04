%%
clear; clc; close all;
disp("Loading ClickTrain_Timeint&Timesynchron passive MatData...");
[~,RawMessage] = xlsread('I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\ClickTrain_Time_int_in_synchron.xlsx', 'Sheet1', 'A2:D2');
params.ROOTPATH = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\';
DATESTRs = RawMessage(:,2);
MonkeyID = 1;%1-CC 2-XX
if MonkeyID == 1 
     
elseif MonkeyID == 2
    
end
%% Preprocess
% for index = 1:length(DATESTRs)
%     params.DATESTRs = DATESTRs(index);
%     params.PrePATH = [params.ROOTPATH, 'Preprocess\', DATESTRs{index}, '\'];
% 
%     % Exclude trials and bad channels
%     params.icaOpt = "on"; % "on" here will perform ICA on all channels and decide bad channels after ICA
%     params.userDefineOpt = "on";
%     Pre_ProcessFcn(params);
% end
%% compare and plot rawWave
devType = [1:7];
for  dIndex = 1 : length(devType)-1
    fftPValue(dIndex).info = stimStrs(dIndex);
    Successive(1).chMean = PMean{dIndex}; Successive(1).color = "r";
    Successive(2).chMean = PMean{length(devType)}; Successive(2).color = "k";
    [H, P] = waveFFTPower_pValue(trialsFFT{dIndex}, trialsFFT{length(devType)}, [{ff}, {ff}], targetIdx(dIndex), 2);
    fftPValue(dIndex).(strcat(stimStrs(dIndex), "_pValue")) = P;
    fftPValue(dIndex).(strcat(stimStrs(dIndex), "_H")) = H;
    % plot raw wave
    FigWave = plotRawWaveMulti_SPR(Successive, [0 fs/2], strcat(stimStrs(dIndex), " Oscillation"), [8, 8]);
    FigWave = deleteLine(FigWave, "LineStyle", "--");
    scaleAxes(FigWave, "y", [0 fftScale(FFTMethod, mIndex)]);
    scaleAxes(FigWave, "x", [0 50]);
    %     setAxes(FigWave, "Xscale", "log");
    lines(1).X = correspFreq(dIndex); lines(1).color = "k";
    addLines2Axes(FigWave, lines);
    orderLine(FigWave, "LineStyle", "--", "bottom");
    setAxes(FigWave, 'yticklabel', '');
    setAxes(FigWave, 'xticklabel', '');
    setAxes(FigWave, 'visible', 'off');
    setLine(FigWave, "YData", [-fftScale(FFTMethod, mIndex) fftScale(FFTMethod, mIndex)], "LineStyle", "--");
    pause(1);
    set(FigWave, "outerposition", [300, 100, 800, 670]);
    plotLayout(FigWave, params.posIndex + 2 * (mIndex - 1), 0.3);
    print(FigWave, strcat(FIGPATH, Protocol, "_FFT_", stimStrs(dIndex)), "-djpeg", "-r200");
    close(FigWave);
end