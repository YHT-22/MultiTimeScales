function [Fig, res] = plot_TFAEEG(chMean, fs0, fsD, window, titleStr, visible, EEGPos)
    narginchk(4, 7);
    
    if nargin < 5
        titleStr = '';
    elseif ~isempty(titleStr) && ~strcmp(titleStr, '')
        titleStr = [' | ', char(titleStr)];
    else
        titleStr = '';
    end

    if nargin < 6
        visible = "on";
    end

    if nargin < 7
        EEGPos = EEGPosConfig();
    end

    Fig = figure("Visible", visible);
    margins = [0.05, 0.05, 0.1, 0.1];
    paddings = [0.1, 0.1, 0.03, 0.06];
    plotSize = [10, 9];
    maximizeFig(Fig);

    res.TFR = [];
    
    for rIndex = 1:plotSize(1)
    
        for cIndex = 1:plotSize(2)
            chNum = (rIndex - 1) * plotSize(2) + cIndex;

            if chNum > size(chMean, 1)
                continue;
            end

            mSubplot(Fig, plotSize(1), plotSize(2), EEGPos(chNum), [1, 1], margins, paddings);
            [t, Y, CData, coi] = mCWT(double(chMean(chNum, :)), fs0, 'morlet', fsD, [1, 80]);
            X = t * 1000 + window(1);
            imagesc('XData', X, 'YData', Y, 'CData', CData);
            res.TFR = [res.TFR; {CData}];
            colormap("jet");
            hold on;
            plot(X, coi, 'w--', 'LineWidth', 0.6);
            title(['CH ', num2str(chNum), titleStr]);
            set(gca, "YScale", "log");
            yticks([0, 2.^(0:nextpow2(max(Y)) - 1)]);
            xlim(window);
            ylim([min(Y), max(Y)]);
    
            if ~mod(((rIndex - 1) * plotSize(2) + cIndex - 1), plotSize(2)) == 0
                yticklabels('');
            end

            if (rIndex - 1) * plotSize(2) + cIndex < (plotSize(1) - 1) * plotSize(2) + 1
                xticklabels('');
            end
    
        end
    end
    
    colorbar('position', [1 - paddings(2), 0.1, 0.2 * paddings(2), 0.8]);
    
    yRange = scaleAxes(Fig);
%     scaleAxes(Fig, "c");
    allAxes = findobj(Fig, "Type", "axes");
    
    for aIndex = 1:length(allAxes)
        plot(allAxes(aIndex), [0, 0], yRange, "w--", "LineWidth", 0.6);
    end
    
    res.t = t;
    res.f = Y;
    res.coi = coi;
    return;
end
