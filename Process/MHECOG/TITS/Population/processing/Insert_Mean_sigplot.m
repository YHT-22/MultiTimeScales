    %% diff stim type
    devType = unique([trialAll.devOrdr]);
    t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';
    for dIndex = 1 : length(devType)
        tIndex = [trialAll.devOrdr] == devType(dIndex);
        trials = trialAll(tIndex);
        trialsECOG = trialsECOG_Merge(tIndex);
        trialsECOG_filte = trialsECOG_Merge_Filtered(tIndex);

        if dIndex == 1
            chMean_temp{dIndex} = cell2mat(cellfun(@mean, changeCellRowNum(trialsECOG), 'UniformOutput', false));
            % view raw wave and select channels
            singleStim.chMean = chMean_temp{dIndex}; singleStim.color = 'k';
            FigWave_review = plotRawWaveMulti_SPR(singleStim, Window, stimStrs(dIndex), [8, 8]);
            setAxes(FigWave_review, 'yticklabel', '');
            setAxes(FigWave_review, 'xticklabel', '');
            setAxes(FigWave_review, 'visible', 'off');
            setLine(FigWave_review, "YData", [-yScale(MonkeyID) yScale(MonkeyID)], "LineStyle", "--");
            pause(1);
            if exist(strcat(FIGPATH_Insertsig, "SelectCHs.mat"), "file")
                load(strcat(FIGPATH_Insertsig, "SelectCHs.mat"));
            else
                SelectCHs = validateInput('SelectCHs(eg:[1,2,...]):', @(x) validateattributes(x, {'numeric'}, {'2d'}));  
                save(strcat(FIGPATH_Insertsig, "SelectCHs.mat"), "SelectCHs");
            end
            close;
        end

        tempECOG = changeCellRowNum(trialsECOG);
        tempECOG = cell2mat(tempECOG(SelectCHs));%所选channel的所有trial取平均
        Mean_select{dIndex} = mean(tempECOG, 1);
        SE_select{dIndex} = std(tempECOG)/sqrt(size(tempECOG,1));

        tempECOG_filte = changeCellRowNum(trialsECOG_filte);
        tempECOG_filte = cell2mat(tempECOG_filte(SelectCHs));%所选channel的所有trial取平均
        Meanfilte_select{dIndex} = mean(tempECOG_filte, 1);
        SEfilte_select{dIndex} = std(tempECOG_filte)/sqrt(size(tempECOG_filte,1));

        popCDRplot(dIndex).info = stimStrs(dIndex);
        popCDRplot(dIndex).MeanandSE_select(:,1) = t';
        popCDRplot(dIndex).MeanandSE_select(:,2) = mean(tempECOG, 1)';
        popCDRplot(dIndex).MeanandSE_select(:,3) = mean(tempECOG, 1)' + (std(tempECOG)/sqrt(size(tempECOG_filte,1)))';
        popCDRplot(dIndex).MeanandSE_select(:,4) = mean(tempECOG, 1)' - (std(tempECOG)/sqrt(size(tempECOG_filte,1)))';

        popCDRplot(dIndex).MeanandSEfilte_select(:,1) = t';
        popCDRplot(dIndex).MeanandSEfilte_select(:,2) = mean(tempECOG_filte, 1)';
        popCDRplot(dIndex).MeanandSEfilte_select(:,3) = mean(tempECOG_filte, 1)' + (std(tempECOG_filte)/sqrt(size(tempECOG_filte,1)))';
        popCDRplot(dIndex).MeanandSEfilte_select(:,4) = mean(tempECOG_filte, 1)' - (std(tempECOG_filte)/sqrt(size(tempECOG_filte,1)))';
    end
    save(strcat(FIGPATH_Insertsig, "popMean_CDRplot.mat"), "popCDRplot");

    for gIndex = 1:numel(Test_Control_PairGroup) 
        Test_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(1);
        Control_GroupIdx(gIndex) = Test_Control_PairGroup{gIndex}(2);

        pairStim(2).chMean = Mean_select{Test_GroupIdx(gIndex)}; pairStim(2).color = 'r';
        pairStim(1).chMean = Mean_select{Control_GroupIdx(gIndex)}; pairStim(1).color = 'b'; 
        stimStr(gIndex) = strcat(stimStrs(Test_GroupIdx(gIndex)), "_", stimStrs(Control_GroupIdx(gIndex)));
        FigWaveMean_pair(gIndex) = plotRawWaveMulti_SPR(pairStim, Window, strrep(stimStr(gIndex),"_","-"), [1,1]);

        scaleAxes(FigWaveMean_pair(gIndex), "x", [-100 600]);
        scaleAxes(FigWaveMean_pair(gIndex), "y", "on");
        print(FigWaveMean_pair(gIndex), strcat(FIGPATH_Insertsig, stimStr(gIndex), "_CH_Trial_Mean"), "-djpeg", "-r200");

        pairStim(2).chMean = Meanfilte_select{Test_GroupIdx(gIndex)}; pairStim(2).color = 'r';
        pairStim(1).chMean = Meanfilte_select{Control_GroupIdx(gIndex)}; pairStim(1).color = 'b'; 
        stimStr(gIndex) = strcat(stimStrs(Test_GroupIdx(gIndex)), "_", stimStrs(Control_GroupIdx(gIndex)));
        FigWaveMeanfilte_pair(gIndex) = plotRawWaveMulti_SPR(pairStim, Window, strrep(stimStr(gIndex),"_","-"), [1,1]);

        scaleAxes(FigWaveMeanfilte_pair(gIndex), "x", [-100 600]);
        scaleAxes(FigWaveMeanfilte_pair(gIndex), "y", "on");
        print(FigWaveMeanfilte_pair(gIndex), strcat(FIGPATH_Insertsig, stimStr(gIndex), "_CH_Trial_Meanfilte"), "-djpeg", "-r200");
    end
    close all;