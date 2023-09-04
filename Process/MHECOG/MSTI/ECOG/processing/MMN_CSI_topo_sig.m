
if ~isempty(protPath)
    temp = dir(protPath);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];
    temp(cellfun(@(x) x == false, {temp.isdir})) = [];

    TargetPATHS = cellfun(@(x) string([char(protPath), x, '\']), {temp.name}', "UniformOutput", false);
    TargetPATHS = TargetPATHS(contains(string(TargetPATHS), monkeyName) & contains(string(TargetPATHS), dateSel) );
    monkey_date = cellfun(@(x) x(end - 1), cellfun(@(x) strsplit(x, "\"), TargetPATHS, "UniformOutput", false));

    Targetfig_savePATHS = cellfun(@(x) strcat(x, "Figures", "\"), TargetPATHS, "UniformOutput", false);
    MATPATHS = cellfun(@(x, y) strcat(x, "cdrPlot", "_", areaSel, ".mat"), Targetfig_savePATHS, "uni", false);

    for mIndex = 1:numel(MATPATHS)
        cdrPlot = []; chMean = []; group = []; comparePool = [];
        load(MATPATHS{mIndex}, "cdrPlot", "chMean", "group", "comparePool");
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
%                 print(FigCSITopo, strcat(Targetfig_savePATHS{mIndex}, "CSITopo"), "-djpeg", "-r200");
            print(FigCSITopo, strcat(protPath, monkey_date(mIndex), "_CSITopo"), "-djpeg", "-r200");
            %save
            save(strcat(Targetfig_savePATHS{mIndex}, "CSI_topo.mat"), "CSI_topo");
            close;
        end
    end
end