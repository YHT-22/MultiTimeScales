%% diff stim type
devType = unique([trialAll_pop.devOrdr]);
t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
t_RMSidx = find(t > RMS_window(1) &  t < RMS_window(2));

for dIndex = 1 : length(devType)
    tIndex = [trialAll_pop.devOrdr] == devType(dIndex);
    trials = trialAll_pop(tIndex);
    trialsECOG = trialsECOG_pop(tIndex);
    trialsECOG_filte = trialsECOG_pop_Filtered(tIndex);
    %mean
    tempECOG = changeCellRowNum(trialsECOG);
    trialMean{dIndex} = cellfun(@(x) mean(x, 1), tempECOG, "uni", false);
    tempECOG = cell2mat(tempECOG(SelectCHs));%所选channel的所有trial取平均
    Mean_select{dIndex} = mean(tempECOG, 1);
    SE_select{dIndex} = std(tempECOG)/sqrt(size(tempECOG,1));

    tempECOG_filte = changeCellRowNum(trialsECOG_filte);
    trialMean_filte{dIndex} = cellfun(@(x) mean(x, 1), tempECOG_filte, "uni", false);
    tempECOG_filte = cell2mat(tempECOG_filte(SelectCHs));%所选channel的所有trial取平均
    Meanfilte_select{dIndex} = mean(tempECOG_filte, 1);
    SEfilte_select{dIndex} = std(tempECOG_filte)/sqrt(size(tempECOG_filte,1));

end

colors = ['r','m','b','k'];
for gIndex = 1:numel(Test_Control_PairGroup) 
    Test_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(1);
    Control_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(2);
    %所选通道，所有trial取平均
    %minus raw
    minusStim(gIndex).chMean = Mean_select{Test_GroupIdx(gIndex)} - Mean_select{Control_GroupIdx(gIndex)};minusStim(gIndex).color = colors(gIndex);
    %minus filter
    minusStim_filte(gIndex).chMean = Meanfilte_select{Test_GroupIdx(gIndex)} - Meanfilte_select{Control_GroupIdx(gIndex)};minusStim_filte(gIndex).color = colors(gIndex);    
    %对于每个通道，所有trial平均之后再减，计算RMS    
    CH_minusStim{gIndex} = cellfun(@(x ,y) x - y, trialMean{Test_GroupIdx(gIndex)}, trialMean{Control_GroupIdx(gIndex)}, "UniformOutput", false);
    CH_minusRMS{gIndex, 1} = cellfun(@(x) rms(x(:, t_RMSidx)), CH_minusStim{gIndex}');
end
CH_minusRMS = cell2mat(CH_minusRMS);
CHmean_minusRMS = mean(CH_minusRMS, 2);
CHse_minusRMS = std(CH_minusRMS, 0, 2)/sqrt(size(CH_minusRMS,2));
   
FigWaveMean_minus = plotRawWaveMulti_SPR(minusStim, Window, [], [1,1]);
scaleAxes(FigWaveMean_minus, "x", [-100 600]);
scaleAxes(FigWaveMean_minus, "y", "on");
print(FigWaveMean_minus, strcat(FIGPATH_Insert, "CH_Trial_Meanminus"), "-djpeg", "-r200");      
FigWaveMeanfilte_minus = plotRawWaveMulti_SPR(minusStim_filte, Window, [], [1,1]);
scaleAxes(FigWaveMeanfilte_minus, "x", [-100 600]);
scaleAxes(FigWaveMeanfilte_minus, "y", "on");
print(FigWaveMeanfilte_minus, strcat(FIGPATH_Insert, "CH_Trial_Meanminusfilte"), "-djpeg", "-r200");  
close all;




