disp("diff stim type anaylysis(no filter)...")
tIndex = [trialAll.devOrdr] == devType(dIndex);
trials = trialAll(tIndex);
trialsECOG = trialsECOG_Merge(tIndex);

chMean{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));

% FFT during successive sound
tIdx_baseline = find(t > FFTWin_baseline(1) & t < FFTWin_baseline(2));
[ff_baseline, PMean_baseline{dIndex}, trialsFFT_baseline{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_baseline, [], FFTMethod);
% [tarMean_base_f1, idx_base_f1] = findWithinWindow(PMean_baseline{dIndex}, ff_baseline, [0.9, 1.1] * cursor1(dIndex));
% [tarMean_base_f2, idx_base_f2] = findWithinWindow(PMean_baseline{dIndex}, ff_baseline, [0.9, 1.1] * cursor2(dIndex));
% [~, targetIndex_base_f1] = max(tarMean_base_f1, [], 2);
% [~, targetIndex_base_f2] = max(tarMean_base_f2, [], 2);
% targetIdx_base_f1(dIndex) = mode(targetIndex_base_f1) + idx_base_f1(1) - 1;
% targetIdx_base_f2(dIndex) = mode(targetIndex_base_f2) + idx_base_f2(1) - 1;

tIdx_head = find(t > FFTWin_head(1) & t < FFTWin_head(2));
[ff_head, PMean_head{dIndex}, trialsFFT_head{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_head, [], FFTMethod);
% [tarMean_head, idx_head] = findWithinWindow(PMean_head{dIndex}, ff_head, [0.9, 1.1] * cursor1(dIndex));
% [~, targetIndex_head] = max(tarMean_head, [], 2);
% targetIdx_head(dIndex) = mode(targetIndex_head) + idx_head(1) - 1;

tIdx_tail = find(t > FFTWin_tail(1) & t < FFTWin_tail(2));
[ff_tail, PMean_tail{dIndex}, trialsFFT_tail{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_tail, [], FFTMethod);
% [tarMean_tail, idx_tail] = findWithinWindow(PMean_tail{dIndex}, ff_tail, [0.9, 1.1] * cursor2(dIndex));
% [~, targetIndex_tail] = max(tarMean_tail, [], 2);
% targetIdx_tail(dIndex) = mode(targetIndex_tail) + idx_tail(1) - 1;


for ch = 1 : size(chMean{dIndex}, 1)
    cdrPlot(ch).Wave(:, 2 * dIndex - 1) = t';
    cdrPlot(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
    cdrPlot(ch).FFT_baseline(:, 2 * dIndex - 1) = ff_baseline;
    cdrPlot(ch).FFT_baseline(:, 2 * dIndex) = PMean_baseline{dIndex}(ch, :)';    
    cdrPlot(ch).FFT_head(:, 2 * dIndex - 1) = ff_head;
    cdrPlot(ch).FFT_head(:, 2 * dIndex) = PMean_head{dIndex}(ch, :)';
    cdrPlot(ch).FFT_tail(:, 2 * dIndex - 1) = ff_tail;
    cdrPlot(ch).FFT_tail(:, 2 * dIndex) = PMean_tail{dIndex}(ch, :)';   
end