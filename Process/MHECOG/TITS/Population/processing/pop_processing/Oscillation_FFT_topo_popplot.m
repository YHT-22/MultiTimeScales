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

        tIdx_whole = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
        [ff_whole, PMean_whole{dIndex}, trialsFFT_whole{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_whole, [], FFTMethod);
        [tarMean_TB{dIndex}, idx_whole] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.96, 1.04] * correspFreq(dIndex));
        [tarMean_localICI1{dIndex}, idx_localICI1] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor1(dIndex));
        [tarMean_localICI2{dIndex}, idx_localICI2] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor2(dIndex));

        topo_TB{dIndex} = mean(tarMean_TB{dIndex},2);
        topo_localICI1{dIndex} = mean(tarMean_localICI1{dIndex},2);
        topo_localICI2{dIndex} = mean(tarMean_localICI2{dIndex},2);

        % cdr_plot
        for ch = 1 : size(chMean{dIndex}, 1)
            cdrPlot_pop(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot_pop(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot_pop(ch).FFT(:, 2 * dIndex - 1) = ff_whole;
            cdrPlot_pop(ch).FFT(:, 2 * dIndex) = PMean_whole{dIndex}(ch, :)';
        end
    end
    % FFT_topo
    FFT_topo_RawandZscore(topo_TB, "TB", stimStrs, FIGPATH_raw, FIGPATH_zscore);
    FFT_topo_RawandZscore(topo_localICI1, "localICI1", stimStrs, FIGPATH_raw, FIGPATH_zscore);
    FFT_topo_RawandZscore(topo_localICI2, "localICI2", stimStrs, FIGPATH_raw, FIGPATH_zscore);
