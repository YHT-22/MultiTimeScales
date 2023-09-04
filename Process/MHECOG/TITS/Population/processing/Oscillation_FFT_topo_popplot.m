%% diff stim type
    devType = unique([trialAll_pop.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';

    %% FFT(local response)
    for dIndex = 1:length(devType) 
        tIndex = [trialAll_pop.devOrdr] == devType(dIndex);
        trials = trialAll_pop(tIndex);
        trialsECOG = trialsECOG_pop(tIndex);
        chMean{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));

        % fft_magnitude
        tIdx_whole = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
        [ff_whole, PMean_whole{dIndex}, trialsFFT_whole{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_whole, [], FFTMethod);
        % topo
        [tarMean_TB{dIndex}, idx_whole] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.96, 1.04] * correspFreq(dIndex));
        [tarMean_ICI1{dIndex}, idx_ICI1] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor1(dIndex));
        [tarMean_ICI2{dIndex}, idx_ICI2] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor2(dIndex));
        topo_TB{dIndex} = mean(tarMean_TB{dIndex},2);
        topo_ICI1{dIndex} = mean(tarMean_ICI1{dIndex},2);
        topo_ICI2{dIndex} = mean(tarMean_ICI2{dIndex},2);
        topo_TB_mean_se(dIndex,1) = mean(topo_TB{dIndex});topo_TB_mean_se(dIndex,2) = std(topo_TB{dIndex})/sqrt(numel(topo_TB{dIndex}));
        topo_ICI1_mean_se(dIndex,1) = mean(topo_ICI1{dIndex});topo_ICI1_mean_se(dIndex,2) = std(topo_ICI1{dIndex})/sqrt(numel(topo_ICI1{dIndex}));
        topo_ICI2_mean_se(dIndex,1) = mean(topo_ICI2{dIndex});topo_ICI2_mean_se(dIndex,2) = std(topo_ICI2{dIndex})/sqrt(numel(topo_ICI2{dIndex}));
        
        % for significant test(5Hz ±8%: 4.6±0.2, 5±0.2, 5.4±0.2; cursor1 ±20%)
        run("Cal_Oscillation_TB_ICI1_ICI2_fft.m");
%         eachTrial_ICI1_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI1{dIndex}, "UniformOutput", false);
%         eachTrial_ICI1Base_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI1Base{dIndex}, "UniformOutput", false);
        [h_TB{dIndex}, pvalue_TB{dIndex}] = cellfun(@(x, y) ttest(x, y, "Tail", "right"), eachTrial_TB{dIndex}, eachTrial_TBBase{dIndex}, "UniformOutput", false);
%         eachTrial_ICI1_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI1{dIndex}, "UniformOutput", false);
%         eachTrial_ICI1Base_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI1Base{dIndex}, "UniformOutput", false);
        [h_ICI1{dIndex}, pvalue_ICI1{dIndex}] = cellfun(@(x, y) ttest(x, y, "Tail", "right"), eachTrial_ICI1{dIndex}, eachTrial_ICI1Base{dIndex}, "UniformOutput", false);
%         eachTrial_ICI2_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI2{dIndex}, "UniformOutput", false);
%         eachTrial_ICI2Base_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_ICI2Base{dIndex}, "UniformOutput", false);
        [h_ICI2{dIndex}, pvalue_ICI2{dIndex}] = cellfun(@(x, y) ttest(x, y, "Tail", "right"), eachTrial_ICI2{dIndex}, eachTrial_ICI2Base{dIndex}, "UniformOutput", false);

        % cdr_plot
        for ch = 1 : size(chMean{dIndex}, 1)
            cdrPlot_pop(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot_pop(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot_pop(ch).FFT(:, 2 * dIndex - 1) = ff_whole;
            cdrPlot_pop(ch).FFT(:, 2 * dIndex) = PMean_whole{dIndex}(ch, :)';
            cdrTunning_TB(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_TB(dIndex + length(devType) * (ch - 1), 2) = topo_TB{dIndex}(ch);
            cdrTunning_TB(dIndex + length(devType) * (ch - 1), 3) = h_TB{dIndex}{ch};
            cdrTunning_ICI1(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_ICI1(dIndex + length(devType) * (ch - 1), 2) = topo_ICI1{dIndex}(ch);
            cdrTunning_ICI1(dIndex + length(devType) * (ch - 1), 3) = h_ICI1{dIndex}{ch};
            cdrTunning_ICI2(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_ICI2(dIndex + length(devType) * (ch - 1), 2) = topo_ICI2{dIndex}(ch);  
            cdrTunning_ICI2(dIndex + length(devType) * (ch - 1), 3) = h_ICI2{dIndex}{ch};
        end

    end

    % FFT_topo
    FFT_topo_RawandZscore(topo_TB, "TB", stimStrs, FIGPATH_raw, FIGPATH_zscore);
    FFT_topo_RawandZscore(topo_ICI1, "ICI1", stimStrs, FIGPATH_raw, FIGPATH_zscore);
    FFT_topo_RawandZscore(topo_ICI2, "ICI2", stimStrs, FIGPATH_raw, FIGPATH_zscore);
