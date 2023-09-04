
disp('Plot FFT wave now...');
for  dIndex = 1 : length(devType)
%     fftPValue(dIndex).info = stimStrs(dIndex);
    if strcmp(Protocol,"TITS_in_Osc")
        Successive(1).chMean = PMean{dIndex}; Successive(1).color = "r";

    elseif strcmp(Protocol,"TITS_in_BasClick")
        Successive(1).chMean = PMean_head{dIndex}; Successive(1).color = "r";
        Successive(2).chMean = PMean_tail{dIndex}; Successive(2).color = "k";

    end

    FigFFTWave = plotRawWaveMulti_SPR(Successive, [0 fs/2], strcat(stimStrs(dIndex), " Oscillation"), [8, 8]);
    FigFFTWave = deleteLine(FigFFTWave, "LineStyle", "--");
    scaleAxes(FigFFTWave, "y", [0 fftScale(FFTMethod, MonkeyID)]);
    scaleAxes(FigFFTWave, "x", [0 cursor1(dIndex)+10]);
    lines(1).X = cursor1(dIndex); lines(1).color = "g";
    lines(2).X = cursor2(dIndex); lines(2).color = "g";

    if strcmp(Protocol, "TITS_in_Osc")
        lines(3).X = correspFreq(dIndex); lines(3).color = "m";
    end
    addLines2Axes(FigFFTWave, lines);
    orderLine(FigFFTWave, "LineStyle", "--", "bottom");
    setAxes(FigFFTWave, 'yticklabel', '');
    setAxes(FigFFTWave, 'xticklabel', '');
    setAxes(FigFFTWave, 'visible', 'off');
    setLine(FigFFTWave, "LineWidth", 0.5,  "Color", [1, 0, 0]);
    setLine(FigFFTWave, "YData", [-fftScale(FFTMethod, MonkeyID) fftScale(FFTMethod, MonkeyID)], "LineStyle", "--");
    pause(1);
    set(FigFFTWave, "outerposition", [300, 100, 800, 670]);
    plotLayout(FigFFTWave, params.posIndex + 2 * (MonkeyID - 1), 0.3);
    print(FigFFTWave, strcat(FIGPATH, Protocol, "_FFT_", AREANAME, "_", stimStrs(dIndex)), "-djpeg", "-r200");
    close(FigFFTWave);

    if strcmp(Protocol, "TITS_in_Osc")

        FigFFTWave_enlarge = plotRawWaveMulti_SPR(Successive, [0 fs/2], strcat(stimStrs(dIndex), " Oscillation"), [8, 8]);
        FigFFTWave_enlarge = deleteLine(FigFFTWave_enlarge, "LineStyle", "--");
        scaleAxes(FigFFTWave_enlarge, "y", [0 fftScale(FFTMethod, MonkeyID)]);
        scaleAxes(FigFFTWave_enlarge, "x", [0 correspFreq(dIndex)+10]);

        addLines2Axes(FigFFTWave_enlarge, lines(3));
        orderLine(FigFFTWave_enlarge, "LineStyle", "--", "bottom");
        setAxes(FigFFTWave_enlarge, 'yticklabel', '');
        setAxes(FigFFTWave_enlarge, 'xticklabel', '');
        setAxes(FigFFTWave_enlarge, 'visible', 'off');
        setLine(FigFFTWave_enlarge, "LineWidth", 0.5,  "Color", [1, 0, 0]);
        setLine(FigFFTWave_enlarge, "YData", [-fftScale(FFTMethod, MonkeyID) fftScale(FFTMethod, MonkeyID)], "LineStyle", "--");
        pause(1);
        set(FigFFTWave_enlarge, "outerposition", [300, 100, 800, 670]);
        plotLayout(FigFFTWave_enlarge, params.posIndex + 2 * (MonkeyID - 1), 0.3);
        print(FigFFTWave_enlarge, strcat(FIGPATH, Protocol, "_FFT_", AREANAME, "_", stimStrs(dIndex), "_enlarge"), "-djpeg", "-r200");
        close(FigFFTWave_enlarge);

    end

end

%%
if exist("PMean_addchoose_filted", "var")
    if controlflag
        for gIndex = 1 : numel(Test_Control_PairGroup)
            Successive_add_filted(1).chMean = PMean_addchoose_filted{Control_GroupIdx(gIndex)}; Successive_add_filted(1).color = "b";
            Successive_add_filted(2).chMean = PMean_addchoose_filted{Test_GroupIdx(gIndex)}; Successive_add_filted(2).color = "r";
            stimStr(gIndex) = strcat(stimStrs(Test_GroupIdx(gIndex)), "_", stimStrs(Control_GroupIdx(gIndex)));
            FigFFTWave_addchoose_filted_pair(gIndex) = plotRawWaveMulti_SPR(Successive_add_filted, [0 fs/2], strcat(stimStr(gIndex), " Oscillation"), [8, 8]);
        end
%             FigFFTWave_addchoose_filted = deleteLine(FigFFTWave_addchoose_filted, "LineStyle", "--");
            scaleAxes(FigFFTWave_addchoose_filted_pair, "y", [0 fftScale(FFTMethod, MonkeyID)]);
            scaleAxes(FigFFTWave_addchoose_filted_pair, "x", [fhp flp]);
            setAxes(FigFFTWave_addchoose_filted_pair, 'yticklabel', '');
            setAxes(FigFFTWave_addchoose_filted_pair, 'xticklabel', '');
            setAxes(FigFFTWave_addchoose_filted_pair, 'visible', 'off');
            setLine(FigFFTWave_addchoose_filted_pair, "LineWidth", 0.5,  "Color", [1, 0, 0]);
            setLine(FigFFTWave_addchoose_filted_pair, "YData", [-fftScale(FFTMethod, MonkeyID) fftScale(FFTMethod, MonkeyID)], "LineStyle", "--");
            pause(1);
            set(FigFFTWave_addchoose_filted_pair, "outerposition", [300, 100, 800, 670]);
            plotLayout(FigFFTWave_addchoose_filted_pair, params.posIndex + 2 * (MonkeyID - 1), 0.3);
        for gIndex = 1 : numel(Test_Control_PairGroup)
            print(FigFFTWave_addchoose_filted_pair(gIndex), strcat(FIGPATH, Protocol, "_FFT_choose_filted_", AREANAME, "_", stimStr(gIndex), "_win[", num2str(FFTWin_addchoose(1)), " ", num2str(FFTWin_addchoose(2)), "]_pair"), "-djpeg", "-r200");
        end
            close(FigFFTWave_addchoose_filted_pair);
    else
        for  dIndex = 1 : length(devType)
            Successive_add_filted(1).chMean = PMean_addchoose_filted{dIndex}; Successive_add_filted(1).color = "b";
            FigFFTWave_addchoose_filted = plotRawWaveMulti_SPR(Successive_add_filted, [0 fs/2], strcat(stimStrs(dIndex), " Oscillation"), [8, 8]);
            FigFFTWave_addchoose_filted = deleteLine(FigFFTWave_addchoose_filted, "LineStyle", "--");
            scaleAxes(FigFFTWave_addchoose_filted, "y", [0 fftScale(FFTMethod, MonkeyID)]);
            scaleAxes(FigFFTWave_addchoose_filted, "x", [fhp flp]);
            setAxes(FigFFTWave_addchoose_filted, 'yticklabel', '');
            setAxes(FigFFTWave_addchoose_filted, 'xticklabel', '');
            setAxes(FigFFTWave_addchoose_filted, 'visible', 'off');
            setLine(FigFFTWave_addchoose_filted, "LineWidth", 0.5,  "Color", [1, 0, 0]);
            setLine(FigFFTWave_addchoose_filted, "YData", [-fftScale(FFTMethod, MonkeyID) fftScale(FFTMethod, MonkeyID)], "LineStyle", "--");
            pause(1);
            set(FigFFTWave_addchoose_filted, "outerposition", [300, 100, 800, 670]);
            plotLayout(FigFFTWave_addchoose_filted, params.posIndex + 2 * (MonkeyID - 1), 0.3);
            print(FigFFTWave_addchoose_filted, strcat(FIGPATH, Protocol, "_FFT_filted_", AREANAME, "_", stimStrs(dIndex), "_win[", num2str(FFTWin_addchoose(1)), " ", num2str(FFTWin_addchoose(2)), "]"), "-djpeg", "-r200");
            close(FigFFTWave_enlarge);
        end
    end

end