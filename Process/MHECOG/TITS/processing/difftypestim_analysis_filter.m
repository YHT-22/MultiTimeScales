disp("diff stim type anaylysis(filter)...")
tIndex = [trialAll.devOrdr] == devType(dIndex);
trials = trialAll(tIndex);
trialsECOG_Filtered = trialsECOG_Merge_Filtered(tIndex);

chMean_filter{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));
chStd_filter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));

% FFT during successive sound
tIdx_whole = find(t > FFTWin_whole(1) & t < FFTWin_whole(2));
[ff_whole_filted, PMean_whole_filted{dIndex}, trialsFFT_whole_filted{dIndex}]  = trialsECOGFFT(trialsECOG_Filtered, fs, tIdx_whole, [], FFTMethod);
% [tarMean, idx] = findWithinWindow(PMean{dIndex}, ff, [0.9, 1.1] * correspFreq(dIndex));
% [~, targetIndex] = max(tarMean, [], 2);
% targetIdx(dIndex) = mode(targetIndex) + idx(1) - 1;
if exist("FFTWin_addchoose", "var")
    tIdx_addchose = find(t > FFTWin_addchoose(1) & t < FFTWin_addchoose(2));
    [ff_addchoose_filted, PMean_addchoose_filted{dIndex}, trialsFFT_addchoose_filted{dIndex}]  = trialsECOGFFT(trialsECOG_Filtered, fs, tIdx_addchose, [], FFTMethod);
end

for ch = 1 : size(chMean_filter{dIndex}, 1)
    cdrPlot(ch).Wave_filter(:, 2 * dIndex - 1) = t';
    cdrPlot(ch).Wave_filter(:, 2 * dIndex) = chMean_filter{dIndex}(ch, :)';
    cdrPlot(ch).FFT_filter(:, 2 * dIndex - 1) = ff_whole_filted;
    cdrPlot(ch).FFT_filter(:, 2 * dIndex) = PMean_whole_filted{dIndex}(ch, :)';
end