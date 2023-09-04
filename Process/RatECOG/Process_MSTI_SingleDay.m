close all; clc; clear;
addpath(genpath("K:\Programe\ECOGProcess"), "-begin");
rmpath(genpath("K:\Programe\Tool_box"));

[~, ~, RawMessage] = xlsread('K:\DATA_202307_RatECOG_MSTI\RatECOG_MSTI_DataRecording.xlsx', 'Sheet1', 'A14:E14');
SaveROOTPATH = 'K:\ANALYSIS_202307_RatECOG_MSTI\';
MATPATH = 'K:\DATA_202307_RatECOG_MSTI\Data\Mat\';
SubjName = RawMessage(:, 1);
DateStrs = RawMessage(:, 2);
ProtocolStrs = RawMessage(:, 5);
params.posIndex = 3; % 1-AC, 2-PFC, 3-Llfp
params.processFcn = @PassiveProcess_clickTrainContinuous;
AREANAME = {['NaN'], ['NaN'], ['AC']};
AREANAME = AREANAME{params.posIndex};
MATPATHs = cellfun(@(x, y, z) [MATPATH, x, '\', y, '\', z, '_', AREANAME], SubjName, ProtocolStrs, DateStrs, "UniformOutput", false);
%others
icaOpt = "on";
FFTMethod = 3;%1-power , 2-magnitude, 3-amplitude
fhp_filte2 = 0.1;
flp_filte2 = 20;
topoSize = [6, 6];
RatECOGPos = RatECOGPosConfig();

%%
for mIndex = 1 : length(MATPATHs)
    clear cdrPlot RawWave FilteWave FFT group
    %% make dir
    temp = string(split(MATPATHs{mIndex}, '\'));
    DateStr_temp = regexpi(temp(end), '_', 'split');
    DateStr = DateStr_temp(end - 1);
    ProtocolStr = temp(end - 1);
    FIGPATH = strcat(SaveROOTPATH, ProtocolStr, "\", DateStr, "\");
    mkdir(fullfile(FIGPATH));

    %% load data .mat
    run("MSTIParamsSetting_ECOG.m");
    run("MSTILoadData_ECOG.m");
    run("RatECOG_ICA.m");
    % badCH
    trialsECOG = interpolateBadChs_RatECOG(trialsECOG, badCHs);
    %% process
    ordertemp = cell2mat({trialAll.ordrSeq}');
    devtype = unique(ordertemp);
    trialsECOG_Filtered = ECOGFilter(trialsECOG, fhp_filte2, flp_filte2, fs);
    if contains(ProtocolStr, ["Change", "Insert", "MSTI"])
        dataselectWin = devonset_Win;
    elseif contains(ProtocolStr, "Oscillation")
        dataselectWin = trialonset_Win;
    end
    t = linspace(dataselectWin(1), dataselectWin(2), diff(dataselectWin) / 1000 * fs + 1);
    tIdx_fft = find(t > FFTWin(1) & t < FFTWin(2));

    for dIndex = 1:length(devtype)

        trial_idx = find(ordertemp == devtype(dIndex));
        trialsECOG_temp = trialsECOG(trial_idx);
        trialsECOG_Filtered_temp = trialsECOG_Filtered(trial_idx);

        chMean{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_temp), "UniformOutput", false));
        chStd{dIndex} = cell2mat(cellfun(@(x) std(x)/sqrt(length(trial_idx)), changeCellRowNum(trialsECOG_temp), "UniformOutput", false));
        chMean_filte{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_Filtered_temp), "UniformOutput", false));
        chStd_filte{dIndex} = cell2mat(cellfun(@(x) std(x)/sqrt(length(trial_idx)), changeCellRowNum(trialsECOG_Filtered_temp), "UniformOutput", false));

        if contains(ProtocolStrs, "MSTI")
            trialsECOG_Lagtemp = trialsECOG_Lag(trial_idx);
            chMeanLag{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_Lagtemp), "UniformOutput", false));
            chStdLag{dIndex} = cell2mat(cellfun(@(x) std(x)/sqrt(length(trial_idx)), changeCellRowNum(trialsECOG_Lagtemp), "UniformOutput", false));
        end

        % raw fft power
        [ff, PMean{dIndex}, trialsFFT{dIndex}]  = trialsECOGFFT(trialsECOG_temp, fs, tIdx_fft, [], FFTMethod);
        targethead_idx = find(ff > (cursor1(dIndex) - 0.5) & ff < (cursor1(dIndex) + 0.5));
        targettail_idx = find(ff > (cursor2(dIndex) - 0.5) & ff < (cursor2(dIndex) + 0.5));
        targethead_fftPower{dIndex} = sum(PMean{dIndex}(:, targethead_idx), 2);
        targettail_fftPower{dIndex} = sum(PMean{dIndex}(:, targettail_idx), 2);

        for ch = 1 : size(trialsECOG{dIndex}, 1)
            cdrPlot(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot(ch).Wavefilte(:, 2 * dIndex - 1) = t';
            cdrPlot(ch).Wavefilte(:, 2 * dIndex) = chMean_filte{dIndex}(ch, :)';            
            cdrPlot(ch).FFT(:, 2 * dIndex - 1) = ff;
            cdrPlot(ch).FFT(:, 2 * dIndex) = PMean{dIndex}(ch, :)';
        end
    end

    % fft power normalization
    targethead_fftPower_normal = num2cell(zscore(cell2mat(targethead_fftPower), 0, "all"), 1);
    for dIndex = 1 : length(devtype)
        Normaltopomap_init{dIndex} = zeros(36, 1); Rawtopomap_init{dIndex} = zeros(36, 1);
        Normaltopomap_init{dIndex}(RatECOGPos) = targethead_fftPower_normal{dIndex};
        NormaltopoReshapemap_init = reshape(Normaltopomap_init{dIndex}, [6, 6])';
%         Rawtopomap_init{dIndex}(RatECOGPos) = targethead_fftPower{dIndex};

        idx = find(NormaltopoReshapemap_init == 0);
        neighbor = FindNeighbor(idx, NormaltopoReshapemap_init);
        patch = cellfun(@(x) mean(NormaltopoReshapemap_init(x), 'all'), neighbor(:, 2));
        NormaltopoReshapemap_init(idx) = patch;
        Normaltopomap_patch{dIndex} = reshape(NormaltopoReshapemap_init', numel(NormaltopoReshapemap_init), 1);
    end

    %% plot
    if contains(ProtocolStr, ["Change", "Oscillation"], "IgnoreCase", true)
        % fft topo(raw & normalization)
        FigTopoNormal0 = plotTopo_RatECOG(cell2mat(Normaltopomap_patch), [6, 6], [2, ceil(numel(TrialTypes) / 2)], [1:ceil(numel(TrialTypes) / 2); (ceil(numel(TrialTypes) / 2) + 1):2 * ceil(numel(TrialTypes) / 2)], TrialTypes, "independent");
        print(FigTopoNormal0, strcat(FIGPATH, "LocalfftTopoNormal_indepClim.jpg"),  "-djpeg", "-r200");
        FigTopoNormal1 = plotTopo_RatECOG(cell2mat(Normaltopomap_patch), [6, 6], [2, ceil(numel(TrialTypes) / 2)], [1:ceil(numel(TrialTypes) / 2); (ceil(numel(TrialTypes) / 2) + 1):2 * ceil(numel(TrialTypes) / 2)], TrialTypes, "union");
        print(FigTopoNormal1, strcat(FIGPATH, "LocalfftTopoNormal_unionClim.jpg"),  "-djpeg", "-r200");
    end 

    for groupnum = 1:numel(GroupTypes)
        for sublines = 1:numel(GroupTypes{groupnum})
            RawWave(GroupTypes{groupnum}(sublines)).chMean = chMean{GroupTypes{groupnum}(sublines)};
            RawWave(GroupTypes{groupnum}(sublines)).color = Colors(GroupTypes{groupnum}(sublines));
            FilteWave(GroupTypes{groupnum}(sublines)).chMean = chMean_filte{GroupTypes{groupnum}(sublines)};
            FilteWave(GroupTypes{groupnum}(sublines)).color = Colors(GroupTypes{groupnum}(sublines));
            FFT(1).chMean = PMean{GroupTypes{groupnum}(sublines)}; FFT(1).color = "k";
            titleStr{groupnum}(sublines) = TrialTypes(GroupTypes{groupnum}(sublines)); 
            % level1:click
            FigFFTWave(sublines) = plotRawWaveMulti_RatECOG(FFT, [0 fs/2], RatECOGPos, titleStr{groupnum}(sublines));
            scaleAxes(FigFFTWave(sublines), "y", [0 20]);
            scaleAxes(FigFFTWave(sublines), "x", [0 cursor1(GroupTypes{groupnum}(sublines))+30]);
            orderLine(FigFFTWave(sublines), "LineStyle", "--", "bottom");
            lines1(1).X = cursor1(GroupTypes{groupnum}(sublines)); lines1(1).color = "b";
            lines1(2).X = cursor2(GroupTypes{groupnum}(sublines)); lines1(2).color = "b";
            if contains(ProtocolStr, ["Oscillation", "MSTI"], "IgnoreCase", true)
                lines1(3).X = cursor3; lines1(3).color = "b";
            end
            addLines2Axes(FigFFTWave(sublines), lines1);
            print(FigFFTWave(sublines), strcat(FIGPATH, "FFTWave_", titleStr{groupnum}(sublines), ".jpg"), "-djpeg", "-r200");
            % level2:local
            if contains(ProtocolStr, ["Oscillation", "MSTI"], "IgnoreCase", true)
                pause(1);
                scaleAxes(FigFFTWave(sublines), "y", [0 10]);
                scaleAxes(FigFFTWave(sublines), "x", [0 10]);
                print(FigFFTWave(sublines), strcat(FIGPATH, "FFTWaveEnlarge_", titleStr{groupnum}(sublines), ".jpg"), "-djpeg", "-r200");
            end
            close all;
        end

        legendStrs = strrep(TrialTypes(GroupTypes{groupnum})', "_", "-");
        if contains(ProtocolStr, ["Change", "Insert"], "IgnoreCase", true)
            FigRawwave(groupnum) = plotRawWaveMulti_RatECOG(RawWave(GroupTypes{groupnum}), dataselectWin, RatECOGPos);
            scaleAxes(FigRawwave(groupnum), "x", plotWin);
            scaleAxes(FigRawwave(groupnum), "y", "on");
            orderLine(FigRawwave(groupnum), "LineStyle", "--", "bottom");
            lines2(1).X = 0; lines2(1).color = "k";
            addLines2Axes(FigRawwave(groupnum), lines2);
            h_FigRawwave = get(FigRawwave(groupnum));
            legend(h_FigRawwave.Children(32), legendStrs);
            print(FigRawwave(groupnum), strcat(FIGPATH, "RawWave_", join(legendStrs, "_"), ".jpg"), "-djpeg", "-r200");

            pause(1);
            scaleAxes(FigRawwave(groupnum), "y", "on");
            scaleAxes(FigRawwave(groupnum), "x", plotChangeWin);
            print(FigRawwave(groupnum), strcat(FIGPATH, "RawWaveChange_", join(legendStrs, "_"), ".jpg"), "-djpeg", "-r200");
        elseif contains(ProtocolStr, ["Oscillation", "Change", "Insert"], "IgnoreCase", true)
            % change(filter)
            FigFiltewave(groupnum) = plotRawWaveMulti_RatECOG(FilteWave(GroupTypes{groupnum}), dataselectWin, RatECOGPos);
            scaleAxes(FigFiltewave(groupnum), "x", plotChangeWin);
            scaleAxes(FigFiltewave(groupnum), "y", "on");
            orderLine(FigFiltewave(groupnum), "LineStyle", "--", "bottom");
            if contains(ProtocolStr, ["Change", "Insert"], "IgnoreCase", true)
                lines2(1).X = 0; lines2(1).color = "k";
            elseif contains(ProtocolStr, "Oscillation", "IgnoreCase", true)
                for changeNum = 1:(SoundLength / Duration - 1)
                    lines2(changeNum).X = Duration * changeNum; lines2(changeNum).color = "k";
                end
            end
            addLines2Axes(FigFiltewave(groupnum), lines2);
            h_FigFiltewave = get(FigFiltewave(groupnum));
            legend(h_FigFiltewave.Children(32), legendStrs);
            print(FigFiltewave(groupnum), strcat(FIGPATH, "FilteWave_", join(legendStrs, "_"), ".jpg"), "-djpeg", "-r200");

        elseif contains(ProtocolStr, "MSTI", "IgnoreCase", true)
            legendStrGroup = ["Odd Std", "Odd Dev"];
            for gIndex = 1 : numel(MMNcompare)
                LagIdx(gIndex) = MMNcompare(1, gIndex).StdOrder_Lagidx;
                DevIdx(gIndex) = MMNcompare(1, gIndex).DevOrder;
            
                % Odd_Std
                group(2 * gIndex -1).chMean = chMeanLag{LagIdx(gIndex)};
                group(2 * gIndex -1).color = "b";
                % Odd_Dev
                group(2 * gIndex).chMean = chMean{DevIdx(gIndex)};
                group(2 * gIndex).color = "r";
            
                % plot
                stimStr_group(gIndex) = strrep(MMNcompare(1, gIndex).sound, "Std", "ICI");
                FigMMNGroup(gIndex) = plotRawWaveMulti_RatECOG(group((2 * gIndex -1):2 * gIndex), dataselectWin, RatECOGPos);
                scaleAxes(FigMMNGroup(gIndex), "x", plotWin);
                scaleAxes(FigMMNGroup(gIndex), "y", "on");
                h_FigMMNGroup = get(FigMMNGroup(gIndex));
                legend(h_FigMMNGroup.Children(32), strrep(legendStrGroup, "Odd", stimStr_group(gIndex)));
                %print
                print(FigMMNGroup(gIndex), strcat(FIGPATH, strrep(stimStr_group(gIndex), ".", "o"), "_", AREANAME), "-djpeg", "-r200");
                close(FigMMNGroup(gIndex));
            end

        end
    end
    close all;
end
