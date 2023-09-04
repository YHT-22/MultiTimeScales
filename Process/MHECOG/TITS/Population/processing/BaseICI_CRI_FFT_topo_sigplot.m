%% diff stim type
    devType = unique([trialAll.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';

    %% CRI
    for dIndex = 1:length(devType) 
        tIndex = [trialAll.devOrdr] == devType(dIndex);
        trials = trialAll(tIndex);
        trialsECOG = trialsECOG_Merge(tIndex);
        trialsECOG_Filtered = trialsECOG_Merge_Filtered(tIndex);

        chMean{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG), 'UniformOutput', false));
        chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));
        chMean_filter{dIndex} = cell2mat(cellfun(@mean , changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));
        chStd_filter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));

        % compute CRI
        [temp, temp_rand, amp, rmsSpon] = cellfun(@(x) Y_waveAmp_Norm(x, Window, quantWin_new, CRIMethod, sponWin_new), trialsECOG, 'UniformOutput', false);
        CRI(dIndex).info = stimStrs(dIndex);
        CRI(dIndex).mean = cellfun(@mean, changeCellRowNum(temp));
        CRI(dIndex).se = cellfun(@(x) std(x)/sqrt(length(x)), changeCellRowNum(temp));
        CRI(dIndex).raw = changeCellRowNum(temp);
        CRI(dIndex).rsp = changeCellRowNum(amp);
        CRI(dIndex).base = changeCellRowNum(rmsSpon);
        CRI(dIndex).raw_randlevel = temp_rand;

        % CRI topo
        topo_Reg = CRI(dIndex).mean;
        FigTopo_CRI(dIndex) = plotTopo_Raw(topo_Reg, [8, 8]);
        colormap(FigTopo_CRI(dIndex), "jet");
        ck=colorbar('horiz');
        set(ck,'Position',[0.2 0.06 0.6 0.02]);
        scaleAxes(FigTopo_CRI(dIndex), "c", CRIScale{MonkeyID}(CRIMethod, :));
        pause(1);
        set(FigTopo_CRI(dIndex), "outerposition", [300, 100, 800, 670]);
        plotLayout(FigTopo_CRI(dIndex), (2 * MonkeyID - 1) * params.posIndex);
        print(FigTopo_CRI(dIndex), strcat(FIGPATH_CRIsig,  stimStrs(dIndex), "_CRI_Topo"), "-djpeg", "-r200");
        close;

        % FFT(local response)
        tIdx_head = find(t > FFTWin_head(1) & t < FFTWin_head(2));
        [ff_head, PMean_head{dIndex}, trialsFFT_head{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_head, [], FFTMethod);
        [tarMean_head{dIndex}, idx_head] = findWithinWindow(PMean_head{dIndex}, ff_head, [0.9, 1.1] * cursor1(dIndex));
        topo_head{dIndex} = mean(tarMean_head{dIndex},2);

        tIdx_tail = find(t > FFTWin_tail(1) & t < FFTWin_tail(2));
        [ff_tail, PMean_tail{dIndex}, trialsFFT_tail{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_tail, [], FFTMethod);
        [tarMean_tail{dIndex}, idx_tail] = findWithinWindow(PMean_tail{dIndex}, ff_tail, [0.9, 1.1] * cursor2(dIndex));
        topo_tail{dIndex} = mean(tarMean_tail{dIndex},2);

        for ch = 1 : size(chMean{dIndex}, 1)
            cdrPlot(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot(ch).Wave_filter(:, 2 * dIndex - 1) = t';
            cdrPlot(ch).Wave_filter(:, 2 * dIndex) = chMean_filter{dIndex}(ch, :)'; 
            cdrPlot(ch).FFT_head(:, 2 * dIndex - 1) = ff_head;
            cdrPlot(ch).FFT_head(:, 2 * dIndex) = PMean_head{dIndex}(ch, :)';
            cdrPlot(ch).FFT_tail(:, 2 * dIndex - 1) = ff_tail;
            cdrPlot(ch).FFT_tail(:, 2 * dIndex) = PMean_tail{dIndex}(ch, :)';   
        end
    end

    % FFT_topo
    % find max&min
    maxnum = max(cell2mat(topo_head'));
    minnum = min(cell2mat(topo_head'));
    % zscore
    temp_zscore = cell2mat(topo_head);
    result_z = zscore(temp_zscore, 0, "all");
    output_z = num2cell(result_z, 1);
    
    for dIndex = 1:numel(topo_head)
        % raw mean
        FigTopo_FFT(dIndex) = plotTopo_Raw(topo_head{dIndex}, [8, 8]);
        colormap(FigTopo_FFT(dIndex), "jet");
        ck=colorbar('horiz');
        set(ck,'Position',[0.2 0.06 0.6 0.02]);
        pause(1);
        set([FigTopo_FFT(dIndex)], "outerposition", [300, 100, 800, 670]);
        scaleAxes(FigTopo_FFT(dIndex), "c", [minnum maxnum]);
        plotLayout(FigTopo_FFT(dIndex), (2 * MonkeyID - 1) * params.posIndex);
        print(FigTopo_FFT(dIndex), strcat(FIGPATH_localrawsig, stimStrs(dIndex), "_FFT_RawTopo"), "-djpeg", "-r200");
        close;
    end

    for dIndex = 1:numel(topo_head)
        % zscore
        FigTopo_FFTnormal(dIndex) = plotTopo_Raw(output_z{dIndex}, [8, 8]);
        colormap(FigTopo_FFTnormal(dIndex), "jet");
        ck=colorbar('horiz');
        set(ck,'Position',[0.2 0.06 0.6 0.02]);
        pause(1);
        set([FigTopo_FFTnormal(dIndex)], "outerposition", [300, 100, 800, 670]);
        scaleAxes(FigTopo_FFTnormal(dIndex), "c", [min(result_z, [], "all") max(result_z, [], "all")]);
        plotLayout(FigTopo_FFTnormal(dIndex), (2 * MonkeyID - 1) * params.posIndex);
        print(FigTopo_FFTnormal(dIndex), strcat(FIGPATH_localzscoresig, stimStrs(dIndex), "_FFT_NormTopo"), "-djpeg", "-r200");
        close;
    end