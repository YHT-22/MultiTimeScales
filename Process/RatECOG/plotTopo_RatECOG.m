function Fig = plotTopo_RatECOG(TopoData, topoSize, plotSize, plotNums, titleStrs, climSetting)
    narginchk(1, 6);

    if nargin < 2
        topoSize = [8, 4]; % [nx, ny]
    end

    if nargin < 3
        plotSize = autoPlotSize(size(TopoData, 2));
    end

    if nargin < 4
        plotNums = reshape(1:(plotSize(1) * plotSize(2)), plotSize(2), plotSize(1))';
    end

    if nargin < 5
        titleStrs = plotNums;
    end

    if nargin < 6
        climSetting = "union";
    end

    if size(plotNums, 1) ~= plotSize(1) || size(plotNums, 2) ~= plotSize(2)
        disp("chs option not matched with plotSize. Resize chs...");
        plotNums = reshape(plotNums(1):(plotNums(1) + plotSize(1) * plotSize(2) - 1), plotSize(2), plotSize(1))';
    end

    Fig = figure;
    maximizeFig(Fig);
    margins = [0.05, 0.05, 0.1, 0.1];
    paddings = [0.01, 0.03, 0.01, 0.01];
    
    for rIndex = 1:plotSize(1)
    
        for cIndex = 1:plotSize(2)
            Num = plotNums(rIndex, cIndex);

            if plotNums(rIndex, cIndex) > size(TopoData, 2)
                continue;
            end

            mAxe = mSubplot(Fig, plotSize(1), plotSize(2), (rIndex - 1) * plotSize(2) + cIndex, [1, 1], margins, paddings);
            plotTopo(mAxe, TopoData(:, Num), topoSize);
            title(titleStrs(Num));

            if strcmp(climSetting, "union")
                scaleAxes(mAxe, "c", [min(TopoData, [], "all"), max(TopoData, [], "all")]);
            elseif strcmp(climSetting, "independent")
                scaleAxes(mAxe, "c", [min(TopoData(:, Num), [], "all"), max(TopoData(:, Num), [], "all")]);
            end

            colormap(mAxe, "jet");
            colorbar;
        end
    
    end

    return;
end