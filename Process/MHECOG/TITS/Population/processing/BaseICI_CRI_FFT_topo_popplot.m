%% diff stim type
    devType = unique([trialAll_pop.devOrdr]);
    % initialize
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';

    for dIndex = 1:length(devType) 
        tIndex = [trialAll_pop.devOrdr] == devType(dIndex);
        trials = trialAll_pop(tIndex);
        trialsECOG = trialsECOG_pop(tIndex);
        trialsECOG_Filtered = trialsECOG_pop_Filtered(tIndex);

        chMean{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG), 'UniformOutput', false));
        chStd = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG), 'UniformOutput', false));
        chMean_filter{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));
        chStd_filter = cell2mat(cellfun(@(x) std(x)/sqrt(length(tIndex)), changeCellRowNum(trialsECOG_Filtered), 'UniformOutput', false));

        %% compute CRI
        [temp, temp_rand, amp, rmsSpon] = cellfun(@(x) Y_waveAmp_Norm(x, Window, quantWin_new, CRIMethod, sponWin_new), trialsECOG, 'UniformOutput', false);
        CRI(dIndex).info = stimStrs(dIndex);
        CRI(dIndex).mean = cellfun(@mean, changeCellRowNum(temp));
        CRI(dIndex).se = cellfun(@(x) std(x)/sqrt(length(x)), changeCellRowNum(temp));
        CRI(dIndex).raw = changeCellRowNum(temp);
        CRI(dIndex).rsp = changeCellRowNum(amp);
        CRI(dIndex).base = changeCellRowNum(rmsSpon);
        CRI(dIndex).raw_randlevel = cellfun(@mean, changeCellRowNum(temp_rand));
        CRI_mean_se(dIndex,1) = mean(CRI(dIndex).mean);CRI_mean_se(dIndex,2) = std(CRI(dIndex).mean)/sqrt(numel(CRI(dIndex).mean));
        CRIRandom_mean_se(dIndex,1) = mean(CRI(dIndex).raw_randlevel);CRIRandom_mean_se(dIndex,2) = std(CRI(dIndex).raw_randlevel)/sqrt(numel(CRI(dIndex).raw_randlevel));
           
%         % CRI topo
%         topo_Reg = CRI(dIndex).mean;
%         FigTopo_CRI(dIndex) = plotTopo_Raw(topo_Reg, [8, 8]);
%         colormap(FigTopo_CRI(dIndex), "jet");
%         ck=colorbar('horiz');
%         set(ck,'Position',[0.2 0.06 0.6 0.02]);
%         scaleAxes(FigTopo_CRI(dIndex), "c", CRIScale{MonkeyID}(CRIMethod, :));
%         pause(1);
%         set(FigTopo_CRI(dIndex), "outerposition", [0, 100, 800, 670]);
%         plotLayout(FigTopo_CRI(dIndex), (2 * MonkeyID - 1) * params.posIndex);
%         print(FigTopo_CRI(dIndex), strcat(FIGPATH_CRI,  stimStrs(dIndex), "_CRI_Topo"), "-djpeg", "-r200");
%         close;

        %% FFT(local response)
        %trialmean(head & tail)
        tIdx_head = find(t > FFTWin_head(1) & t < FFTWin_head(2));
        [ff_head, PMean_head{dIndex}, trialsFFT_head{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_head, [], FFTMethod);
        [tarMean_head{dIndex}, idx_head] = findWithinWindow(PMean_head{dIndex}, ff_head, [0.9, 1.1] * cursor1(dIndex));
        topo_head{dIndex} = mean(tarMean_head{dIndex},2);
        topo_head_mean_se(dIndex,1) = mean(topo_head{dIndex});topo_head_mean_se(dIndex,2) = std(topo_head{dIndex})/sqrt(numel(topo_head{dIndex}));

        tIdx_tail = find(t > FFTWin_tail(1) & t < FFTWin_tail(2));
        [ff_tail, PMean_tail{dIndex}, trialsFFT_tail{dIndex}]  = trialsECOGFFT(trialsECOG, fs, tIdx_tail, [], FFTMethod);
        [tarMean_tail{dIndex}, idx_tail] = findWithinWindow(PMean_tail{dIndex}, ff_tail, [0.9, 1.1] * cursor2(dIndex));
        topo_tail{dIndex} = mean(tarMean_tail{dIndex},2);
        topo_tail_mean_se(dIndex,1) = mean(topo_tail{dIndex});topo_tail_mean_se(dIndex,2) = std(topo_tail{dIndex})/sqrt(numel(topo_tail{dIndex}));

        %tunning(each trial(head & tail))
%         run("Cal_BaseICI_head_tail_fft.m");
% %         eachTrial_head_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_head{dIndex}, "UniformOutput", false);
% %         eachTrial_headBase_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_headBase{dIndex}, "UniformOutput", false);
%         [h_head{dIndex}, pvalue_head{dIndex}] = cellfun(@(x, y) ttest(x, y, "Tail", "right"), eachTrial_head{dIndex}, eachTrial_headBase{dIndex}, "UniformOutput", false);
% %         eachTrial_tail_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_tail{dIndex}, "UniformOutput", false);
% %         eachTrial_tailBase_resample{dIndex} = cellfun(@(x) bootstrp(1000, @mean, x), eachTrial_tailBase{dIndex}, "UniformOutput", false);
%         [h_tail{dIndex}, pvalue_tail{dIndex}] = cellfun(@(x, y) ttest(x, y, "Tail", "right"), eachTrial_tail{dIndex}, eachTrial_tailBase{dIndex}, "UniformOutput", false);
        % cdr_plot

        for ch = 1 : size(chMean{dIndex}, 1)
            cdrPlot_pop(ch).Wave(:, 2 * dIndex - 1) = t';
            cdrPlot_pop(ch).Wave(:, 2 * dIndex) = chMean{dIndex}(ch, :)';
            cdrPlot_pop(ch).Wave_filter(:, 2 * dIndex - 1) = t';
            cdrPlot_pop(ch).Wave_filter(:, 2 * dIndex) = chMean_filter{dIndex}(ch, :)';
            cdrPlot_pop(ch).FFThead(:, 2 * dIndex - 1) = ff_head;
            cdrPlot_pop(ch).FFThead(:, 2 * dIndex) = PMean_head{dIndex}(ch, :)';
            cdrPlot_pop(ch).FFTtail(:, 2 * dIndex - 1) = ff_tail;
            cdrPlot_pop(ch).FFTtail(:, 2 * dIndex) = PMean_tail{dIndex}(ch, :)';
            cdrTunning_head(dIndex, 1) = dIndex;            
            cdrTunning_head(dIndex, 1 + ch) = topo_head{dIndex}(ch);
%             cdrTunning_head(dIndex + length(devType) * (ch - 1), 3) = h_head{dIndex}{ch};
            cdrTunning_tail(dIndex, 1) = dIndex;            
            cdrTunning_tail(dIndex, 1 + ch) = topo_tail{dIndex}(ch);  
%             cdrTunning_tail(dIndex + length(devType) * (ch - 1), 3) = h_tail{dIndex}{ch};
            cdrTunning_CRI(dIndex, 1) = dIndex;            
            cdrTunning_CRI(dIndex, 1 + ch) = CRI(dIndex).mean(ch);  
            cdrTunning_CRIRandom(dIndex, 1) = dIndex;            
            cdrTunning_CRIRandom(dIndex, 1 + ch) = CRI(dIndex).raw_randlevel(ch);
        end


    end

%     % FFT_topo
%     % find max&min
%     maxnum = max(cell2mat(topo_head'));
%     minnum = min(cell2mat(topo_head'));
%     % zscore
%     temp_zscore = cell2mat(topo_head);
%     result_z = zscore(temp_zscore, 0, "all");
%     output_z = num2cell(result_z, 1);
%     
%     for dIndex = 1:numel(topo_head)
%         % raw mean
%         FigTopo_FFT(dIndex) = plotTopo_Raw(topo_head{dIndex}, [8, 8]);
%         colormap(FigTopo_FFT(dIndex), "jet");
%         ck=colorbar('horiz');
%         set(ck,'Position',[0.2 0.06 0.6 0.02]);
%         pause(1);
%         set([FigTopo_FFT(dIndex)], "outerposition", [300, 100, 800, 670]);
%         scaleAxes(FigTopo_FFT(dIndex), "c", [minnum maxnum]);
%         plotLayout(FigTopo_FFT(dIndex), (2 * MonkeyID - 1) * params.posIndex);
%         print(FigTopo_FFT(dIndex), strcat(FIGPATH_localraw, stimStrs(dIndex), "_FFT_RawTopo"), "-djpeg", "-r200");
%         close;
%     end
% 
%     for dIndex = 1:numel(topo_head)
%         % zscore
%         FigTopo_FFTnormal(dIndex) = plotTopo_Raw(output_z{dIndex}, [8, 8]);
%         colormap(FigTopo_FFTnormal(dIndex), "jet");
%         ck=colorbar('horiz');
%         set(ck,'Position',[0.2 0.06 0.6 0.02]);
%         pause(1);
%         set([FigTopo_FFTnormal(dIndex)], "outerposition", [300, 100, 800, 670]);
%         scaleAxes(FigTopo_FFTnormal(dIndex), "c", [min(result_z, [], "all") max(result_z, [], "all")]);
%         plotLayout(FigTopo_FFTnormal(dIndex), (2 * MonkeyID - 1) * params.posIndex);        
%         print(FigTopo_FFTnormal(dIndex), strcat(FIGPATH_localzscore, stimStrs(dIndex), "_FFT_NormTopo"), "-djpeg", "-r200");
%         close;
%     end