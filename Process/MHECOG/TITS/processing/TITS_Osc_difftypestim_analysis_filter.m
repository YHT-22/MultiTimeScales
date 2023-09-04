disp("TITS_Osc_difftypestim_analysis_filter...");

trialsECOG_filtered = trialsECOG_Merge_Filtered(tIndex);

chMean_filter{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG_filtered), 'UniformOutput', false));
chStd_filter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG_filtered), 'UniformOutput', false));

% FFT during successive sound
tIdx = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
[ff_filter, PMean_filter{dIndex}, trialsFFT_filtered{dIndex}]  = trialsECOGFFT(trialsECOG_filtered, fs, tIdx, [], FFTMethod);
[tarMean_filter, idx_filter] = findWithinWindow(PMean_filter{dIndex}, ff_filter, [0.9, 1.1] * correspFreq(dIndex));
[~, targetIndex_filter] = max(tarMean_filter, [], 2);
targetIdx_filter(dIndex) = mode(targetIndex_filter) + idx_filter(1) - 1;


for ch = 1 : size(chMean_filter{dIndex}, 1)
    cdrPlot(ch).Wave_filter(:, 2 * dIndex - 1) = t';
    cdrPlot(ch).Wave_filter(:, 2 * dIndex) = chMean_filter{dIndex}(ch, :)';
    cdrPlot(ch).FFT_filter(:, 2 * dIndex - 1) = ff_filter;
    cdrPlot(ch).FFT_filter(:, 2 * dIndex) = PMean_filter{dIndex}(ch, :)';
end