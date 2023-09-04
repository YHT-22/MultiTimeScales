%% process across diff devTypes
devType = unique([trialAll.devOrdr]);
% initialize
t = linspace(Window(1), Window(2), size(trialsECOG_Merge{1}, 2))';
for ch = 1 : 64
    cdrPlot(ch).(strcat(monkeyStr, "info")) = strcat("Ch", num2str(ch));
    cdrPlot(ch).(strcat(monkeyStr, "Wave")) = zeros(length(t), 2 * length(devType));
end
PMean = cell(1, length(devType));
chMean = cell(1, length(devType));
chMeanLag = cell(1, length(devType));
chMeanFilterd = cell(1, length(devType));
trialsECOGFilterd = cell(1, length(devType));
trialsECOGLag = cell(1, length(devType));
chMean_RMS = cell(1, length(devType));
chMeanLag_RMS = cell(1, length(devType));

% process
for dIndex = devType
    tIndex = [trialAll.devOrdr] == dIndex;
    trials = trialAll(tIndex);
    trialsECOG = trialsECOG_pop(tIndex);
    trialsECOGFilterd = trialsECOG_pop_Filtered(tIndex);
    trialsECOGLag = trialsECOG_pop_Lag(tIndex);

    % fft
    tIdx_local = find(t > FFTWin_local(1) & t < FFTWin_local(2));
    [ff_local, PMean_local{dIndex}, trialsFFT_local{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_local, [], FFTMethod);
    tIdx_change = find(t > FFTWin_change(1) & t < FFTWin_change(2));
    [ff_change, PMean_change{dIndex}, trialsFFT_change{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_change, [], FFTMethod);

    % raw wave
    chMean{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
    chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));

    % filter
    chMeanFilterd{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));
    chStdFilter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));

    % lag
    chMeanLag{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOGLag), 'UniformOutput', false));
    chStdLag = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOGLag), 'UniformOutput', false));
 
    % RMS
    tIdx_RMS = find(t > RMSWin(1) & t < RMSWin(2));
    chMean_RMS{1, dIndex} = rms(chMean{1, dIndex}(:, tIdx_RMS), 2);
    chMeanLag_RMS{1, dIndex} = rms(chMeanLag{1, dIndex}(:, tIdx_RMS), 2);

    % data for corelDraw plot
    for ch = 1 : size(chMean{1, dIndex}, 1)
        cdrPlot(ch).(strcat(monkeyStr, "Wave"))(:, 2 * dIndex - 1) = t';
        cdrPlot(ch).(strcat(monkeyStr, "Wave"))(:, 2 * dIndex) = chMean{1, dIndex}(ch, :)';
        cdrPlot(ch).(strcat(monkeyStr, "WaveFilted"))(:, 2 * dIndex - 1) = t';
        cdrPlot(ch).(strcat(monkeyStr, "WaveFilted"))(:, 2 * dIndex) = chMeanFilterd{1, dIndex}(ch, :)';
        cdrPlot(ch).(strcat(monkeyStr, "WaveLag"))(:, 2 * dIndex - 1) = t';
        cdrPlot(ch).(strcat(monkeyStr, "WaveLag"))(:, 2 * dIndex) = chMeanLag{1, dIndex}(ch, :)';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_local"))(:, 2 * dIndex - 1) = ff_local';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_local"))(:, 2 * dIndex) = PMean_local{1, dIndex}(ch, :)';  
        cdrPlot(ch).(strcat(monkeyStr, "FFT_change"))(:, 2 * dIndex - 1) = ff_change';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_change"))(:, 2 * dIndex) = PMean_change{1, dIndex}(ch, :)';
        cdrPlot(ch).ChRMS(dIndex) = chMean_RMS{1, dIndex}(ch);
        cdrPlot(ch).ChRMS_Lag(dIndex) = chMeanLag_RMS{1, dIndex}(ch);
    end


end

if ~exist(FIGPATH_pop, "dir")
    mkdir(FIGPATH_pop);
end
%% change response
for dIndex = 1:length(devType)
    FFT_Wave(1).chMean = PMean_change{dIndex};FFT_Wave(1).color = 'k';
    FigFFTWave = plotRawWaveMulti_SPR(FFT_Wave, [0 fs/2], strcat(strrep(stimStrs(dIndex),'_','-'), "MSTI"), [8, 8]);
    lines(1).X = 1000/duration;lines(1).color = "r";

    scaleAxes(FigFFTWave, "x", [0 10]);
    scaleAxes(FigFFTWave, "y", [0 5]);
    addLines2Axes(FigFFTWave,lines);
    pause(1);
    set(FigFFTWave, "outerposition", [300, 100, 800, 670]);
    plotLayout(FigFFTWave, params.posIndex + 2 * (monkeyId - 1), 0.3);
    print(FigFFTWave, strcat(FIGPATH_pop, "FFT(", string(FFTMethod_idx) , ")_", AREANAME, "_", stimStrs(dIndex)), "-djpeg", "-r200");
    close(FigFFTWave);
end
%% comparison between devTypes
legendStr = ["Odd Std", "Odd Dev"];
legendStr_diff = ["Odd Std diff", "Odd Dev diff"];
for gIndex = 1 : length(comparePool)

    parseStruct(comparePool, gIndex);
    % Odd_Std
    group(2 * gIndex -1).chMean = chMeanLag{1, Odd_Std_Index};
    group(2 * gIndex -1).color = colors(2);
    % Odd_Dev
    group(2 * gIndex).chMean = chMean{1, Odd_Dev_Index};
    group(2 * gIndex).color = colors(1);

    % plot
    FigGroup(gIndex) = plotRawWaveMulti_SPR(group((2 * gIndex -1):2 * gIndex), Window, DevStr);
    addLegend2Fig(FigGroup(gIndex), legendStr);

end
scaleAxes(FigGroup, "x", DevPlotWin);
scaleAxes(FigGroup, "y", "on");

for gIndex = 1 : length(FigGroup)
    parseStruct(comparePool, gIndex);
    % print figure
    print(FigGroup(gIndex), strcat(FIGPATH_pop, DevStr, "_", AREANAME), "-djpeg", "-r200");
    close(FigGroup(gIndex));
end
%% RMS Compare
figure;
for gIndex = 1 : length(comparePool)
    parseStruct(comparePool, gIndex);
    RMSCompare(gIndex).info = strcat("Dev:", DevStr);
    RMSCompare(gIndex).x = cellfun(@(x) x(1, Odd_Std_Index), {cdrPlot.ChRMS_Lag})';
    RMSCompare(gIndex).y = cellfun(@(x) x(1, Odd_Dev_Index), {cdrPlot.ChRMS})';   

    subplot(1,2,gIndex);
    plot(RMSCompare(gIndex).x, RMSCompare(gIndex).y, '.', [0:10], [0:10], 'k--');hold on;
    title(DevStr);xlabel("Std-RMS");ylabel("Dev-RMS");
end
print(gcf, strcat(FIGPATH_pop, "RMSCompare_", AREANAME), "-djpeg", "-r200");
close;
%% save
ResName1 = strcat(FIGPATH_pop, "cdrPlot(fft_", string(FFTMethod_idx), ")_", AREANAME, ".mat");
ResName2 = strcat(FIGPATH_pop, "RMSCompareScatter_", AREANAME, ".mat");
save(ResName1, "cdrPlot", "chMean", "Protocol", "group", "comparePool", "-mat");
save(ResName2, "RMSCompare", "-mat");