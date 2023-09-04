
if ~isempty(protPath)
    temp = dir(protPath);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    temp(cellfun(@(x) x == false, {temp.isdir})) = [];

    TargetPATH = cellfun(@(x) string([char(protPath), x, '\']), {temp.name}');
    
    if monkeyName == "xx"
        TargetPATH = TargetPATH(contains(string(TargetPATH), "xiaoxiao_pop"));
    elseif monkeyName == "cc"
        TargetPATH = TargetPATH(contains(string(TargetPATH), "chouchou_pop"));
    end

    MATPATH = cellfun(@(x, y) strcat(x, "cdrPlot", "_", areaSel, ".mat"), TargetPATH);
    cdrPlot = []; chMean = []; group = []; comparePool = [];
    if exist(MATPATH, "file")
        load(MATPATH, "cdrPlot", "chMean", "group", "comparePool");
        if monkeyName == "xx"
            t = cdrPlot(1).XXWave(:, 1);
            fs = (numel(cdrPlot(1).XXWave(:, 1)) - 1) / ((cdrPlot(1).XXWave(end, 1) - cdrPlot(1).XXWave(1, 1)) / 1000);
        elseif monkeyName == "cc"
            t = cdrPlot(1).CCWave(:, 1);
            fs = (numel(cdrPlot(1).CCWave(:, 1)) - 1) / ((cdrPlot(1).CCWave(end, 1) - cdrPlot(1).CCWave(1, 1)) / 1000);
        end
    
        if contains(protocolStr, "MSTI_")
            %calculate CSI(rms)
            tIndex = t > CSIWin(1) & t < CSIWin(2);
            Devindex = cellfun(@isempty, cellfun(@(x) find(x(:,1) == zeros(64, 1)), {group.chMean}, "UniformOutput", false));
            Stdindex = cellfun(@(x) ~isempty(x), cellfun(@(x) find(x(:,1) == zeros(64, 1)), {group.chMean}, "UniformOutput", false));
            rms_temp = cellfun(@(x) rms(x(:, tIndex), 2), {group.chMean}, "UniformOutput", false)';
            CSI_temp = changeCellRowNum(rms_temp);
            CSI_topo = cellfun(@(x) (sum(x(Devindex)) - sum(x(Stdindex))) / (sum(x(Devindex)) + sum(x(Stdindex))), CSI_temp);
            %plot CSI topo
            FigCSITopo = plotTopo_Raw(CSI_topo, [8, 8]);
            colormap(FigCSITopo, "jet");
            pause(1);
            set(FigCSITopo, "outerposition", [300, 100, 800, 670]);
            scaleAxes(FigCSITopo, "c", [-0.3 0.3]);
            print(FigCSITopo, strcat(TargetPATH, "CSITopo"), "-djpeg", "-r200");
            %save
            save(strcat(TargetPATH, "CSI_topo.mat"), "CSI_topo");
            close;
        end
    end

end