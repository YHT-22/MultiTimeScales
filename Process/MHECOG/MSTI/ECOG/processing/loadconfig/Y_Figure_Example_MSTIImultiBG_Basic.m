clc; close all;
MATPATH = MATPATHS{mIndex};
fftScale = [60, 60; 450, 450];
if contains(MATPATH, "chouchou")
    monkeyId = 1;  % 1：chouchou; 2：xiaoxiao
    monkeyStr = "CC";
    badCHs = {[],[]};
elseif contains(MATPATH, "xiaoxiao")
    monkeyId = 2;
    monkeyStr = "XX";
    badCHs = {[],[]};   
end

AREANAME = ["AC", "PFC"];
params.posIndex = find(matches(AREANAME, areaSel)); % 1-AC, 2-PFC
params.processFcn = @PassiveProcess_clickTrainContinuous;
AREANAME = AREANAME(params.posIndex);
badCHs = badCHs{params.posIndex};

%% load parameters
MSTIParams = Y_ParseMSTImultiBGParams(protocolStr);
parseStruct(MSTIParams);

%% process
temp = string(split(MATPATH, '\'));
DateStr = temp(end - 1);
Protocol = temp(end - 2);
FIGPATH = strcat(rootPathFig, "Figure_", protStr,"\", DateStr, "_", AREANAME, "\Figures\");
% if exist(FIGPATH, "dir")
%     return
% end
DateStrtemp = regexpi(DateStr, "\d*", "match");
if str2double(DateStrtemp(1)) >= 20230227
    MSTIParams.patch = "matchIssue";
else
    MSTIParams.patch = "bankIssue";
end
tic
[trialAll, trialsECOG_Merge] =  mergeMSTImultiBGTrialsECOG(MATPATH, params.posIndex, MSTIParams);
toc


%% ICA
% align to certain duration
ICPATH = strrep(FIGPATH, "Figures", "ICA");
mkdir(ICPATH);
ICAName = strcat(ICPATH, "comp.mat");
trialsECOG_MergeTemp = trialsECOG_Merge;
channels = 1 : size(trialsECOG_Merge{1}, 1);

if ~exist(ICAName, "file")
    chs2doICA = channels;
    chs2doICA(ismember(chs2doICA, badCHs)) = [];
    [comp, ICs, FigTopoICA, FigWave, FigIC] = ICA_Population(trialsECOG_MergeTemp, fs, Window, chs2doICA);
    temp = validateInput(['Input bad channel number (empty for default: ', num2str(badCHs'), '): '], @(x) validateattributes(x, {'numeric'}, {'2d', 'integer', 'positive'}));
    icaOpt = "on";
    if ~isempty(temp)
        badCHs = unique([badCHs; reshape(temp, [numel(temp), 1])]);
    end
    compT = comp;
    compT.topo(:, ~ismember(1:size(compT.topo, 2), ICs)) = 0;

    if length(chs2doICA) < length(channels) || ~isempty(temp)
        
        trialsECOG_MergeTemp = cellfun(@(x) x(chs2doICA, :), trialsECOG_MergeTemp, "UniformOutput", false);
        trialsECOG_MergeTemp = reconstructData(trialsECOG_MergeTemp, comp, ICs);
        trialsECOG_Merge = cellfun(@(x) insertRows(x, channels(ismember(channels, badCHs) & ~ismember(channels, chs2doICA))), trialsECOG_MergeTemp, "UniformOutput", false);
    else
        trialsECOG_Merge = cellfun(@(x) compT.topo * comp.unmixing * x, trialsECOG_MergeTemp, "UniformOutput", false);
    end

    print(FigWave(2), strcat(ICPATH, "ICA_IC_Rescutction_", protStr), "-djpeg", "-r200");
    print(FigTopoICA, strcat(ICPATH, "ICA_IC_Topo_", protStr), "-djpeg", "-r200");
    print(FigIC, strcat(ICPATH, "ICA_IC_Raw_", protStr), "-djpeg", "-r200");
    close(FigTopoICA); close(FigWave); close(FigIC);
    save(ICAName, "compT", "comp", "ICs", "icaOpt", "chs2doICA", "badCHs", "-mat");
else
    load(ICAName);
    if strcmpi(icaOpt, "on")
        trialsECOG_MergeTemp = cellfun(@(x) x(chs2doICA, :), trialsECOG_MergeTemp, "UniformOutput", false);
        trialsECOG_MergeTemp = reconstructData(trialsECOG_MergeTemp, comp, ICs);
        trialsECOG_Merge = cellfun(@(x) insertRows(x, channels(ismember(channels, badCHs) & ~ismember(channels, chs2doICA))), trialsECOG_MergeTemp, "UniformOutput", false);

    else
        trialsECOG_Merge = cellfun(@(x) compT.topo * comp.unmixing * x, trialsECOG_MergeTemp, "UniformOutput", false);
    end

end
trialsECOG_Merge = interpolateBadChs(trialsECOG_Merge,  badCHs);

%% double exclude
[~, ~, idx] = excludeTrialsChs(trialsECOG_Merge,0.1, Window, DevPlotWin);
trialAll = trialAll(idx);
trialsECOG_Merge = trialsECOG_Merge(idx);
% trialsECOG_Test = trialsECOG_Merge(idx);
%% filter
trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp2, flp2, fs);

%% lag
tSD = cellfun(@(x) round((x(end)-x(end-1)) * fs), Std_Dev_Onset, "UniformOutput", false);
trialsECOG_Merge_Lag = cellfun(@(x, y) [zeros(size(x, 1), tSD{y}), x(:, 1:end-tSD{y})], trialsECOG_Merge, num2cell(vertcat(trialAll.devOrdr)), "UniformOutput", false);

%% process across diff devTypes
devType = unique([trialAll.devOrdr]);
% initialize
t = linspace(Window(1), Window(2), size(trialsECOG_Merge{1}, 2))';
for ch = 1 : 64
    cdrPlot(ch).(strcat(monkeyStr, "info")) = strcat("Ch", num2str(ch));
    cdrPlot(ch).(strcat(monkeyStr, "Wave")) = zeros(length(t), 2 * length(devType));
end
PMean = cell(length(MATPATH), length(devType));
chMean = cell(length(MATPATH), length(devType));
chMeanLag = cell(length(MATPATH), length(devType));
chMeanFilterd = cell(length(MATPATH), length(devType));
trialsECOGFilterd = cell(length(MATPATH), length(devType));
trialsECOGLag = cell(length(MATPATH), length(devType));

% process
for dIndex = devType
    tIndex = [trialAll.devOrdr] == dIndex;
    trials = trialAll(tIndex);
    trialsECOG = trialsECOG_Merge(tIndex);
    trialsECOGFilterd = trialsECOG_Merge_Filtered(tIndex);
    trialsECOGLag = trialsECOG_Merge_Lag(tIndex);

    % fft
    tIdx_local = find(t > FFTWin_local(1) & t < FFTWin_local(2));
    [ff_local, PMean_local{dIndex}, trialsFFT_local{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_local, [], 'amplitude');
    tIdx_change = find(t > FFTWin_change(1) & t < FFTWin_change(2));
    [ff_change, PMean_change{dIndex}, trialsFFT_change{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_change, [], 'amplitude');

    % raw wave
    chMean{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
    chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));

    % filter
    chMeanFilterd{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));
    chStdFilter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));

    % lag
    chMeanLag{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOGLag), 'UniformOutput', false));
    chStdLag = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOGLag), 'UniformOutput', false));

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
    end


end

if ~exist(FIGPATH, "dir")
    mkdir(FIGPATH);
end
%% change response & local click
for dIndex = 1:length(devType)
    stistrtemp = strsplit(char(strrep(stimStrs(dIndex), "o", ".")), '_');
    tempfreq = cellfun(@(x) x{1,2}, cellfun(@(x) strsplit(x, "-"), stistrtemp, "UniformOutput", false), "UniformOutput", false);
    tempfreq = cellfun(@(x) str2double(x), tempfreq);
    freq1 = max(tempfreq);
    freq2 = min(tempfreq);

    FFT_Wave(1).chMean = PMean_change{dIndex};FFT_Wave(1).color = 'k';
    FigFFTWave = plotRawWaveMulti_SPR(FFT_Wave, [0 fs/2], strcat(string(stistrtemp{1}), " ", string(stistrtemp{2})), [8, 8]);
    lines(1).X = 1000/duration;lines(1).color = "r";

    scaleAxes(FigFFTWave, "x", [0 10]);
    scaleAxes(FigFFTWave, "y", "on");
    addLines2Axes(FigFFTWave,lines);
    pause(1);
    set(FigFFTWave, "outerposition", [300, 100, 800, 670]);
    plotLayout(FigFFTWave, params.posIndex + 2 * (monkeyId - 1), 0.3);
    print(FigFFTWave, strcat(FIGPATH, "FFT_change", AREANAME, "_", stimStrs(dIndex)), "-djpeg", "-r200");
    close(FigFFTWave);

    lines = [];
    FigFFTWave_enlarge = plotRawWaveMulti_SPR(FFT_Wave, [0 fs/2], strcat(strrep(stimStrs(dIndex),'_','-')), [8, 8]);

    lines(1).X = 1000/freq1;lines(1).color = "r";
    lines(2).X = 1000/freq2;lines(2).color = "r";

    scaleAxes(FigFFTWave_enlarge, "x", [(1000 / freq1 - 50) (1000 / freq2 + 50)]);
    scaleAxes(FigFFTWave_enlarge, "y", "on");
    addLines2Axes(FigFFTWave_enlarge,lines);
    pause(1);
    set(FigFFTWave_enlarge, "outerposition", [300, 100, 800, 670]);
    plotLayout(FigFFTWave_enlarge, params.posIndex + 2 * (monkeyId - 1), 0.3);
    print(FigFFTWave_enlarge, strcat(FIGPATH, "FFT_local", AREANAME, "_", stimStrs(dIndex)), "-djpeg", "-r200");

    close(FigFFTWave_enlarge);
end
%% comparison between devTypes
if exist(strcat(FIGPATH, "GroupMessage.mat"), "file")
    load(strcat(FIGPATH, "GroupMessage.mat"));
else
    Test_Control_PairGroup = validateInput('Input Pair group typenum({[Test_order, control_order]}, eg:{[1,2],[3,4]}): ', ...
    @(x) validateattributes(x, {'cell'}, {'2d'}));  
    save(strcat(FIGPATH, "GroupMessage.mat"), "Test_Control_PairGroup");
end
legendStrGroup = ["Odd Std", "Odd Dev"];
for gIndex = 1 : numel(Test_Control_PairGroup)
    Test_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(1);
    Control_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(2);

    % Odd_Std
    group(2 * gIndex -1).chMean = chMeanLag{1, Control_GroupIdx(gIndex)};
    group(2 * gIndex -1).color = colors(2);
    % Odd_Dev
    group(2 * gIndex).chMean = chMean{1, Test_GroupIdx(gIndex)};
    group(2 * gIndex).color = colors(1);

    % plot
    stimStr_group(gIndex) = strcat(strrep(stimStrs(Test_GroupIdx(gIndex)),'_','-'), "-vs-",...
    strrep(stimStrs(Control_GroupIdx(gIndex)),'_','-'));
    FigGroup(gIndex) = plotRawWaveMulti_SPR(group((2 * gIndex -1):2 * gIndex), Window, stimStr_group(gIndex));
    addLegend2Fig(FigGroup(gIndex), legendStrGroup);
    scaleAxes(FigGroup(gIndex), "x", DevPlotWin);
    scaleAxes(FigGroup(gIndex), "y", [-20 20]);

    %print
    print(FigGroup(gIndex), strcat(FIGPATH, stimStr_group(gIndex), "_", AREANAME), "-djpeg", "-r200");
    close(FigGroup(gIndex));
end

%%
ResName = strcat(FIGPATH, "cdrPlot_", AREANAME, ".mat");
save(ResName, "cdrPlot", "chMean", "Protocol", "group", "-mat");


