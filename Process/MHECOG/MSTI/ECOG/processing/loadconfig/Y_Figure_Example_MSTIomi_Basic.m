clc; close all;
MATPATH = MATPATHS{mIndex};
% temp = regexp(MATPATH,'\','split');
% Date = temp(end - 1);
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
disp(protocolStr);
[MSTIParams, sound] = Y_ParseMSTIomiParams(protocolStr);
parseStruct(MSTIParams);

%% process
temp = string(split(MATPATH, '\'));
DateStr = temp(end - 1);
Protocol = temp(end - 2);
FIGPATH = strcat(rootPathFig, "Figure_", protStr,"\", DateStr, "_", AREANAME, "\Figures\");
DateStrtemp = regexpi(DateStr, "\d*", "match");
if str2double(DateStrtemp(1)) >= 20230227
    MSTIParams.patch = "matchIssue";
else
    MSTIParams.patch = "bankIssue";
end
tic
[trialAll, trialsECOG_Merge] =  mergeMSTIomiTrialsECOG(MATPATH, params.posIndex, MSTIParams,sound);
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

%% filter
trialsECOG_Merge_Filtered = ECOGFilter(trialsECOG_Merge, fhp2, flp2, fs);

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
chMeanFilterd = cell(length(MATPATH), length(devType));
trialsECOGFilterd = cell(length(MATPATH), length(devType));

% process
for dIndex = devType
    tIndex = [trialAll.devOrdr] == dIndex;
    trials = trialAll(tIndex);
    trialsECOG = trialsECOG_Merge(tIndex);
    trialsECOGFilterd = trialsECOG_Merge_Filtered(tIndex);

    % fft
    tIdx_local = find(t > FFTWin_local(1) & t < FFTWin_local(2));
    [ff_local, PMean_local{dIndex}, trialsFFT_local{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_local, []);
    tIdx_change = find(t > FFTWin_change(1) & t < FFTWin_change(2));
    [ff_change, PMean_change{dIndex}, trialsFFT_change{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_change, []);

    % raw wave
    chMean{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
    chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));

    % filter
    chMeanFilterd{1, dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));
    chStdFilter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOGFilterd), 'UniformOutput', false));


    % data for corelDraw plot
    for ch = 1 : size(chMean{1, dIndex}, 1)
        cdrPlot(ch).(strcat(monkeyStr, "Wave"))(:, 2 * dIndex - 1) = t';
        cdrPlot(ch).(strcat(monkeyStr, "Wave"))(:, 2 * dIndex) = chMean{1, dIndex}(ch, :)';
        cdrPlot(ch).(strcat(monkeyStr, "WaveFilted"))(:, 2 * dIndex - 1) = t';
        cdrPlot(ch).(strcat(monkeyStr, "WaveFilted"))(:, 2 * dIndex) = chMeanFilterd{1, dIndex}(ch, :)';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_local"))(:, 2 * dIndex - 1) = ff_local';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_local"))(:, 2 * dIndex) = PMean_local{1, dIndex}(ch, :)';  
        cdrPlot(ch).(strcat(monkeyStr, "FFT_change"))(:, 2 * dIndex - 1) = ff_change';
        cdrPlot(ch).(strcat(monkeyStr, "FFT_change"))(:, 2 * dIndex) = PMean_change{1, dIndex}(ch, :)';
    end


end

if ~exist(FIGPATH, "dir")
    mkdir(FIGPATH);
end
%% omission response
legendStrSingle = ["oddball"];
legendStrGroup = ["oddball", "manystd"];
if controlFlag == 1
    if exist(strcat(FIGPATH, "GroupMessage.mat"), "file")
        load(strcat(FIGPATH, "GroupMessage.mat"));
    else
        Test_Control_PairGroup = validateInput('Input Pair group typenum({[Test_order, ManyStd_order]}, eg:{[1,2],[3,4]}): ', ...
        @(x) validateattributes(x, {'cell'}, {'2d'}));  
        save(strcat(FIGPATH, "GroupMessage.mat"), "Test_Control_PairGroup");
    end

    for gIndex = 1 : numel(Test_Control_PairGroup)
        Test_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(1);
        Control_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(2);

        % omission
        group_raw(2 * gIndex - 1).chMean = chMean{Test_GroupIdx(gIndex)};
        group_raw(2 * gIndex - 1).color = colors(1);
        % ManyStd
        group_raw(2 * gIndex).chMean = chMean{Control_GroupIdx(gIndex)};
        group_raw(2 * gIndex).color = colors(2);
        % plot
        stimStr_group(gIndex) = strcat(strrep(stimStrs(Test_GroupIdx(gIndex)),'.','o'), "_vs_",...
        strrep(stimStrs(Control_GroupIdx(gIndex)),'.','o'));
        FigGroup(gIndex) = plotRawWaveMulti_SPR(group_raw((2 * gIndex - 1):2 * gIndex), Window, stimStr_group(gIndex));
        addLegend2Fig(FigGroup(gIndex), legendStrGroup);
        scaleAxes(FigGroup(gIndex), "x", DevPlotWin);
        scaleAxes(FigGroup(gIndex), "y", [-30 30]);
        lines(1).X = duration;
        addLines2Axes(FigGroup(gIndex), lines);
        %print
        print(FigGroup(gIndex), strcat(FIGPATH, stimStr_group(gIndex), "_", AREANAME), "-djpeg", "-r200");
        close(FigGroup(gIndex));
    end

else

    for dIndex = 1 : length(devType)
        % omission
        group_raw(dIndex).chMean = chMean{dIndex};
        group_raw(dIndex).color = colors(1);
        % plot
        FigSingle(dIndex) = plotRawWaveMulti_SPR(group_raw(dIndex), Window, stimStrs(dIndex));
        addLegend2Fig(FigSingle(dIndex), legendStrSingle);
        scaleAxes(FigSingle(dIndex), "x", DevPlotWin);
        scaleAxes(FigSingle(dIndex), "y", [-30 30]);
        lines(1).X = duration;
        addLines2Axes(FigSingle(dIndex), lines);
        %print
        print(FigSingle(dIndex), strcat(FIGPATH, strrep(stimStrs(dIndex),'.','o'), "_", AREANAME), "-djpeg", "-r200");
        close(FigSingle(dIndex));
    end
end


%% fft
for aIndex = 1:length(PMean_change)    
    Successive(1).chMean = PMean_change{aIndex}; Successive(1).color = "r";

    FigFFTWave(aIndex) = plotRawWaveMulti_SPR(Successive, [0 fs/2], strcat(stimStrs(aIndex), "Omission"), [8, 8]);
    FigFFTWave(aIndex) = deleteLine(FigFFTWave(aIndex), "LineStyle", "--");
    scaleAxes(FigFFTWave(aIndex), "x", [0 10]);
    scaleAxes(FigFFTWave(aIndex), "y", [0 600]);
    lines(1).X = 1000/duration;
    addLines2Axes(FigFFTWave(aIndex), lines);
    print(FigFFTWave(aIndex), strcat(FIGPATH, "FFT_", AREANAME, "_", strrep(stimStrs(aIndex),'.','o')), "-djpeg", "-r200");
    close(FigFFTWave(aIndex));
end
%% save
ResName = strcat(FIGPATH, "cdrPlot_", AREANAME, ".mat");
mSave(ResName, "cdrPlot", "chMean", "Protocol", "-mat");
