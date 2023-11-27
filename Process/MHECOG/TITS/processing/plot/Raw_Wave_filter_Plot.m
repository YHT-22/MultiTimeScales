disp('Plot Raw wave(filted) now...');

devType = unique([trialAll.devOrdr]);
t = linspace(Window(1), Window(2), diff(Window) /1000 * fs + 1)';

    if controlflag  
        for gIndex = 1 : numel(Test_Control_PairGroup)
%             pairStim(1).chMean = chMean_filter{Test_GroupIdx(gIndex)}; pairStim(1).color = 'r';
%             pairStim(2).chMean = chMean_filter{Control_GroupIdx(gIndex)}; pairStim(2).color = 'b';
            pairStim(2).chMean = chMean_filter{Test_GroupIdx(gIndex)}; pairStim(2).color = 'r';
            pairStim(1).chMean = chMean_filter{Control_GroupIdx(gIndex)}; pairStim(1).color = 'b'; 
            stimStr(gIndex) = strcat(stimStrs(Test_GroupIdx(gIndex)), "_", stimStrs(Control_GroupIdx(gIndex)));
            FigWave_filter_pair(gIndex) = plotRawWaveMulti_SPR(pairStim, Window, stimStr(gIndex), [8, 8]);
        end
        setAxes(FigWave_filter_pair, 'yticklabel', '');
        setAxes(FigWave_filter_pair, 'xticklabel', '');
        setAxes(FigWave_filter_pair, 'visible', 'off');
        setLine(FigWave_filter_pair, "YData", [-yScale(MonkeyID) yScale(MonkeyID)], "LineStyle", "--");
        pause(1);
        for plotcount = 1 : length(plotWin)
            set(FigWave_filter_pair, "outerposition", [300, 100, 800, 670]);
            scaleAxes(FigWave_filter_pair, "x", plotWin_filter{plotcount});
            scaleAxes(FigWave_filter_pair, "y", [-yScale(MonkeyID) yScale(MonkeyID)]);
            if exist("lines", "var")
                addLines2Axes(FigWave_filter_pair, lines);
            end 
            plotLayout(FigWave_filter_pair, params.posIndex + 2 * (MonkeyID - 1), 0.3);
            for gIndex = 1 : numel(Test_Control_PairGroup)
                print(FigWave_filter_pair(gIndex), strcat(FIGPATH, Protocol, stimStr(gIndex), "_CRI_Wave_filter_pair"), "-djpeg", "-r200");
            end
        end
    else
        %% plot single wave
        for dIndex = 1 : length(devType)
            singleStim.chMean = chMean_filter{dIndex}; singleStim.color = colors(dIndex);
            FigWave_filter(dIndex) = plotRawWaveMulti_SPR(singleStim, Window, stimStrs(dIndex), [8, 8]);
            if exist("cursor_sound", "var")
                lines1 = [];
                for linenum  = 1 : numel(cursor_sound{dIndex})
                    lines1(linenum).X = cursor_sound{dIndex}(linenum); lines1(linenum).color = "k";
                end
                addLines2Axes(FigWave_filter(dIndex), lines1);
            end
        end
        setAxes(FigWave_filter, 'yticklabel', '');
        setAxes(FigWave_filter, 'xticklabel', '');
        setAxes(FigWave_filter, 'visible', 'off');
        setLine(FigWave_filter, "YData", [-yScale(MonkeyID) yScale(MonkeyID)], "LineStyle", "--");
        pause(1);
        for plotcount = 1 : length(plotWin_filter)
            set(FigWave_filter, "outerposition", [300, 100, 800, 670]);
            scaleAxes(FigWave_filter, "x", plotWin_filter{plotcount});
            scaleAxes(FigWave_filter, "y", [-yScale(MonkeyID) yScale(MonkeyID)]);

            plotLayout(FigWave_filter, params.posIndex + 2 * (MonkeyID - 1), 0.3);
            for dIndex = 1 : length(devType)
                print(FigWave_filter(dIndex), strcat(FIGPATH, Protocol, stimStrs(dIndex), "_win", num2str(plotWin{plotcount}), "_CRI_Wave_filter"), "-djpeg", "-r200");
            end
        end
    end

    % whole wave
    if plotWhole
        for dIndex = 1 : length(devType)
            singleStim.chMean = chMean_filter{dIndex}; singleStim.color = colors(dIndex);
            FigWave_Whole(dIndex) = plotRawWaveMulti_SPR(singleStim, Window, stimStr(1), [8, 8]);
        end
        setAxes(FigWave_Whole, 'yticklabel', '');
        setAxes(FigWave_Whole, 'xticklabel', '');
        setAxes(FigWave_Whole, 'visible', 'off');
        setLine(FigWave_Whole, "YData", [-yScale(MonkeyID) yScale(MonkeyID)], "LineStyle", "--");

        pause(1);
        set(FigWave_Whole, "outerposition", [300, 100, 800, 670]);
        
        plotLayout(FigWave_Whole, params.posIndex + 2 * (MonkeyID - 1), 0.3);
        for dIndex = 1 : length(devType)
            print(FigWave_Whole(dIndex), strcat(FIGPATH, Protocol, stimStrs(dIndex), "_CRI_Wave_Whole_filter"), "-djpeg", "-r200");
        end
    end

    close all