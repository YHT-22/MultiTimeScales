%%  compute CRI/ORI and plot CRI/ORI topo
devType = unique([trialAll.devOrdr]);
t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
for dIndex = 1:length(devType)
    tIndex = [trialAll.devOrdr] == devType(dIndex);
    trials = trialAll(tIndex);
    trialsECOG = trialsECOG_Merge(tIndex);
%     trialsECOG_S1 = trialsECOG_S1_Merge(tIndex);

    % compute CRI
    [temp, amp, rmsSpon] = cellfun(@(x) waveAmp_Norm(x, Window, quantWin, CRIMethod, sponWin), trialsECOG, 'UniformOutput', false);
    CRI(dIndex).info = stimStrs(dIndex);
    CRI(dIndex).mean = cellfun(@mean, changeCellRowNum(temp));
    CRI(dIndex).se = cellfun(@(x) std(x)/sqrt(length(x)), changeCellRowNum(temp));
    CRI(dIndex).raw = changeCellRowNum(temp);
    CRI(dIndex).rsp = changeCellRowNum(amp);
    CRI(dIndex).base = changeCellRowNum(rmsSpon);


end
close all