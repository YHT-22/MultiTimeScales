function passive3ProcessFcn(trialAll, trialsEEG, window, fs, params)
%% Length
close all;
parseStruct(params);
mkdir(FIGPATH);
margins = [0.05, 0.05, 0.1, 0.1];
colors = ["#FF0000", "#FFA500", "#0000FF", "#000000"];
FFTWin = [2000 7400];%same as monkey ECOG
t = linspace(window(1), window(2), diff(window) /1000 * fs + 1)';
%% REG
n = 1;
idx = find(cell2mat(regexpi([trialAll.type], "Reg")) == 1);
trials = trialAll(idx);
trialsEEG_temp = trialsEEG(idx);
soundtypes = unique([trials.code])';
Sound = reshape(Sound, 1, numel(Sound));

for index = 1:length(soundtypes)
    temp = trialsEEG_temp([trials.code] == soundtypes(index));
    
    if ~isempty(temp)
        targetsound_idx = find(soundtypes(index) == cell2mat({Sound.code}));
        soundname = Sound(targetsound_idx).name;
        %% find std_dev onset
        run("get_std_dev_soundonset.m");
        Sound(targetsound_idx).Std_Dev_onset = changeinfo(1:2:end, 5);
        moveTime(index) = diff(Sound(targetsound_idx).Std_Dev_onset(end-1:end)) * 1000;
        moveSmpPoint = round(moveTime(index) / 1000 * fs);

        %% chMean
        chMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum(temp), "UniformOutput", false));
        chMean_move = [zeros(size(chMean, 1), moveSmpPoint), chMean(:, 1:(end - moveSmpPoint))];
        chMeanData(n, 1).chMean = chMean;
        chMeanData(n, 1).chMean_move = chMean_move;
        chMeanData(n, 1).soundcode = soundtypes(index);
        chMeanData(n, 1).soundname = soundname;
        % RMS
        RMSWin = [Sound(targetsound_idx).Std_Dev_onset(end)*1000, Sound(targetsound_idx).Std_Dev_onset(end)*1000 + 600];
        tIdx_RMS = find(t > RMSWin(1) & t < RMSWin(2));
        RMSCompare(n, 1).rms = rms(chMean(:, tIdx_RMS), 2);%dev
        RMSCompare(n, 1).rms_move = rms(chMean_move(:, tIdx_RMS), 2);%std
        RMSCompare(n, 1).soundname = soundname;
        n = n + 1;
        
        nametemp = regexp(soundname, '_', 'split');
        plotstr = strjoin(nametemp(cellfun(@(x) contains(x ,{'Std', 'Dev'}), nametemp)), '_');

        if ~dataOnlyOpt
            EEGPos = EEGPosConfig("Trigger Type", "neuracle");
            plotRawWaveEEG(chMean, [], window, Sound(targetsound_idx).Std_Dev_onset(end)*1000, ['soundcode', num2str(soundtypes(index))], EEGPos);
            scaleAxes("x", [-300,Sound(targetsound_idx).sLength]);
            scaleAxes("y", "cutoffRange", [-10, 10]);
            print(gcf, fullfile(FIGPATH, strcat("Passive3 REG-", string(plotstr))), "-djpeg", "-r200");
        end
        %% CWT
        [Fig_CWT, res] = plot_TFAEEG(chMean, 1000, 80, window, [], "on", EEGPos);
        print(Fig_CWT, fullfile(FIGPATH, strcat("Passive3 REG(cwt)-", string(plotstr))), "-djpeg", "-r200");
        close;
        
        %% FFT
        tIdx = find(t > FFTWin(1) & t < FFTWin(2));
        [ff, PMean{index}, trialsFFT{index}]  = trialsECOGFFT(temp, fs, tIdx, [], "amplitude");
        Successive(1).chMean = PMean{index}; Successive(1).color = "r";

        EEGPos = EEGPosConfig("Trigger Type", "neuracle");
        FigFFTWave = plotRawWaveEEG(Successive(1).chMean, [], [0 fs/2], 5, ['soundcode', num2str(soundtypes(index))], EEGPos);
        FigFFTWave = deleteLine(FigFFTWave, "LineStyle", "--");
        scaleAxes(FigFFTWave, "y", [0 3]);
        scaleAxes(FigFFTWave, "x", [0 10]);

        lines(1).X = 1000 ./ 300; lines(1).color = "k";
        addLines2Axes(FigFFTWave, lines);
        orderLine(FigFFTWave, "LineStyle", "--", "bottom");
        setAxes(FigFFTWave, 'yticklabel', '');
        setAxes(FigFFTWave, 'xticklabel', '');
        setAxes(FigFFTWave, 'visible', 'off');
        setLine(FigFFTWave, "LineWidth", 0.5,  "Color", [1, 0, 0]);

        print(FigFFTWave, strcat(FIGPATH, "\", "passive3_FFT_", plotstr), "-djpeg", "-r200");
        close(FigFFTWave);
    end

end
save(fullfile(SAVEPATH, "chMean_P3.mat"), "chMeanData");
save(fullfile(SAVEPATH, "RMSCompare_P3.mat"), "RMSCompare");

%% MMN
if exist(strcat(SAVEPATH, "\", "GroupMessage.mat"), "file")
    load(strcat(SAVEPATH, "\", "GroupMessage.mat"));
else
    Dev_Std_code_Group = validateInput(['Input Pair group typenum({[Dev_typenum, Std_typenum]}, eg:{[1,2],[3,4]}): '], ...
    @(x) validateattributes(x, {'cell'}, {'2d'}));  
    save(strcat(SAVEPATH, "\", "GroupMessage.mat"), "Dev_Std_code_Group");
end

for gIndex = 1 : numel(Dev_Std_code_Group)
    Dev_GroupIdx(gIndex) = Dev_Std_code_Group{gIndex}(1);
    Std_GroupIdx(gIndex) = Dev_Std_code_Group{gIndex}(2);
    DevIdx = find(Dev_GroupIdx(gIndex) == cell2mat({chMeanData.soundcode}));
    StdIdx = find(Std_GroupIdx(gIndex) == cell2mat({chMeanData.soundcode}));
    chData(2).chMean = chMeanData(DevIdx).chMean;%dev
    chData(1).chMean = chMeanData(StdIdx).chMean_move;%std
    chData(2).color = "red";
    chData(1).color = "blue";

    Devsound_idx = find(Dev_GroupIdx(gIndex) == cell2mat({Sound.code}));
    Stdsound_idx = find(Std_GroupIdx(gIndex) == cell2mat({Sound.code}));    
    EEGPos = EEGPosConfig("Trigger Type", "neuracle");
%     plotRawWaveMultiEEG(chData, window, Sound(Devsound_idx).Std_Dev_onset(end)*1000, [], EEGPos);    
    plotRawWaveMultiEEG(chData, window, Sound(Devsound_idx).Std_Dev_onset(end)*1000, ['DevScode', num2str(chMeanData(DevIdx).soundcode)], EEGPos);
    scaleAxes("x", [Sound(Devsound_idx).Std_Dev_onset(end)*1000 - 100, Sound(Devsound_idx).Std_Dev_onset(end)*1000 + moveTime(Stdsound_idx)]);
    scaleAxes("y", "cutoffRange", [-8, 8]);

    nametemp = regexp(chMeanData(DevIdx).soundname, '_', 'split');
    plotMMNstr = strjoin(nametemp(cellfun(@(x) contains(x ,{'Std', 'Dev'}), nametemp)), '_');
    print(gcf, fullfile(FIGPATH, strcat("Passive3 MMN-", plotMMNstr)), "-djpeg", "-r200");

end
close all;

%% average MMN
if exist(fullfile(SAVEPATH, "chsAvg.mat"), "file")
    load(fullfile(SAVEPATH, "chsAvg.mat"));
% 
    for gIndex = 1 : numel(Dev_Std_code_Group)
        Dev_GroupIdx(gIndex) = Dev_Std_code_Group{gIndex}(1);
        Std_GroupIdx(gIndex) = Dev_Std_code_Group{gIndex}(2);
        DevIdx = find(Dev_GroupIdx(gIndex) == cell2mat({chMeanData.soundcode}));
        StdIdx = find(Std_GroupIdx(gIndex) == cell2mat({chMeanData.soundcode}));
        Devsound_idx = find(Dev_GroupIdx(gIndex) == cell2mat({Sound.code}));
        Stdsound_idx = find(Std_GroupIdx(gIndex) == cell2mat({Sound.code}));  
        run("chsAvg_MMN.m");
        run("cdrplot_chsAvg_MMN.m");
    end
    %save(cdrplot)
    save(fullfile(SAVEPATH, "CDRchsAvg_MMN.mat"), "chsAvg_MMNcompare");

    for i = 1:length(soundtypes)
        figure;
        maximizeFig;
        tIdx = find(t > FFTWin(1) & t < FFTWin(2));
        temp = trialsEEG_temp([trials.code] == soundtypes(i));
        plotstr = strrep(chMeanData(i).soundname,'.', 'o');

        run("chsAvg_FFT.m");
        run("cdrplot_chsAvg_FFT.m");
    end
    save(fullfile(SAVEPATH, "CDRchsAvg_FFT.mat"), "chsAvg_areaFFT");
    close all;

end