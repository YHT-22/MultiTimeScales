function FFT_topo_RawandZscore(topo_Reg_FFT, fft_message, stimStrs, FIGPATH_localraw, FIGPATH_localzscore)
 % find max&min
maxnum = max(cell2mat(topo_Reg_FFT'));
minnum = min(cell2mat(topo_Reg_FFT'));
% zscore
temp_zscore = cell2mat(topo_Reg_FFT);
result_z = zscore(temp_zscore, 0, "all");
output_z = num2cell(result_z, 1);

    for dIndex = 1:numel(topo_Reg_FFT)
        % raw mean
        FigTopo_FFT(dIndex) = plotTopo_Raw(topo_Reg_FFT{dIndex}, [8, 8]);
        colormap(FigTopo_FFT(dIndex), "jet");
        pause(1);
        set([FigTopo_FFT(dIndex)], "outerposition", [300, 100, 800, 670]);
        scaleAxes(FigTopo_FFT(dIndex), "c", [minnum maxnum]);
        mkdir(fullfile(FIGPATH_localraw, stimStrs(dIndex)));
        print(FigTopo_FFT(dIndex), strcat(FIGPATH_localraw, stimStrs(dIndex), "\", fft_message, "_FFT_RawTopo"), "-djpeg", "-r200");

    end
   
    for dIndex = 1:numel(topo_Reg_FFT)
        % zscore
        FigTopo_FFTnormal(dIndex) = plotTopo_Raw(output_z{dIndex}, [8, 8]);
        colormap(FigTopo_FFTnormal(dIndex), "jet");
        pause(1);
        set([FigTopo_FFTnormal(dIndex)], "outerposition", [300, 100, 800, 670]);
        scaleAxes(FigTopo_FFTnormal(dIndex), "c", [min(result_z, [], "all") max(result_z, [], "all")]);
        mkdir(fullfile(FIGPATH_localzscore, stimStrs(dIndex)));        
        print(FigTopo_FFTnormal(dIndex), strcat(FIGPATH_localzscore, stimStrs(dIndex), "\", fft_message, "_FFT_NormTopo"), "-djpeg", "-r200");

    end
    close all;
end