%% diff stim type
    devType = unique([trialAll.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
    %% FFT(local response)
    for dIndex = 1:length(devType) 
        tIndex = [trialAll.devOrdr] == devType(dIndex);
        trials = trialAll(tIndex);
        trialsECOG = trialsECOG_Merge(tIndex);
        chMean{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));

        tIdx_whole = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
        [ff_whole, PMean_whole{dIndex}, trialsFFT_whole{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_whole, [], FFTMethod);
        [tarMean_TB{dIndex}, idx_whole] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.96, 1.04] * correspFreq(dIndex));
        [tarMean_localICI1{dIndex}, idx_localICI1] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor1(dIndex));
        [tarMean_localICI2{dIndex}, idx_localICI2] = findWithinWindow(PMean_whole{dIndex}, ff_whole, [0.9, 1.1] * cursor2(dIndex));

        topo_TB{dIndex} = mean(tarMean_TB{dIndex},2);
        topo_ICI1{dIndex} = mean(tarMean_localICI1{dIndex},2);
        topo_ICI2{dIndex} = mean(tarMean_localICI2{dIndex},2);
        topo_TB_mean_se(dIndex,1) = mean(topo_TB{dIndex});topo_TB_mean_se(dIndex,2) = std(topo_TB{dIndex})/sqrt(numel(topo_TB{dIndex}));
        topo_ICI1_mean_se(dIndex,1) = mean(topo_ICI1{dIndex});topo_ICI1_mean_se(dIndex,2) = std(topo_ICI1{dIndex})/sqrt(numel(topo_ICI1{dIndex}));
        topo_ICI2_mean_se(dIndex,1) = mean(topo_ICI2{dIndex});topo_ICI2_mean_se(dIndex,2) = std(topo_ICI2{dIndex})/sqrt(numel(topo_ICI2{dIndex}));
       
        % cdr_plot
        for ch = 1 : size(chMean{dIndex}, 1)
            cdrPlot(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot(ch).FFT(:, 2 * dIndex - 1) = ff_whole;
            cdrPlot(ch).FFT(:, 2 * dIndex) = PMean_whole{dIndex}(ch, :)';
            cdrTunning_TB(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_TB(dIndex + length(devType) * (ch - 1), 2) = topo_TB{dIndex}(ch);
            cdrTunning_ICI1(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_ICI1(dIndex + length(devType) * (ch - 1), 2) = topo_ICI1{dIndex}(ch);
            cdrTunning_ICI2(dIndex + length(devType) * (ch - 1), 1) = dIndex;            
            cdrTunning_ICI2(dIndex + length(devType) * (ch - 1), 2) = topo_ICI2{dIndex}(ch);            
        end
    end
    % FFT_topo
%     FFT_topo_RawandZscore(topo_TB, "TB", stimStrs, FIGPATH_rawsig, FIGPATH_zscoresig);
%     FFT_topo_RawandZscore(topo_ICI1, "ICI1", stimStrs, FIGPATH_rawsig, FIGPATH_zscoresig);
%     FFT_topo_RawandZscore(topo_ICI2, "ICI2", stimStrs, FIGPATH_rawsig, FIGPATH_zscoresig);