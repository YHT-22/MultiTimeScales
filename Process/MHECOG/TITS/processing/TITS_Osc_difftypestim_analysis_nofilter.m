disp("TITS_Osc_difftypestim_analysis_nofilter...");

trialsECOG = trialsECOG_Merge(tIndex);

chMean{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));

% FFT during successive sound
tIdx = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
[ff, PMean{dIndex}, trialsFFT{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx, [], FFTMethod);
[tarMean, idx] = findWithinWindow(PMean{dIndex}, ff, [0.9, 1.1] * correspFreq(dIndex));
[~, targetIndex] = max(tarMean, [], 2);
targetIdx(dIndex) = mode(targetIndex) + idx(1) - 1;


for ch = 1 : size(chMean{dIndex}, 1)
    cdrPlot(ch).Wave(:, 2 * dIndex - 1) = t';
    cdrPlot(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
    cdrPlot(ch).FFT(:, 2 * dIndex - 1) = ff;
    cdrPlot(ch).FFT(:, 2 * dIndex) = PMean{dIndex}(ch, :)';
end