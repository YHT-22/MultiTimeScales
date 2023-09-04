figure;
maximizeFig;
%F_Fp
mSubplot(4, 3, 2, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.F_Fp, :), 1), temp, "UniformOutput", false);
[ff, PMean_F_Fp, trialsFFT_F_Fp]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_F_Fp, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);ylabel("Amplitude");title("F_Fp");

%Central
mSubplot(4, 3, 5, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.Central, :), 1), temp, "UniformOutput", false);
[ff, PMean_Central, trialsFFT_Central]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_Central, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);ylabel("Amplitude");title("Central");

%Left_temporal
mSubplot(4, 3, 7, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.Left_temporal, :), 1), temp, "UniformOutput", false);
[ff, PMean_Left_temporal, trialsFFT_Left_temporal]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_Left_temporal, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);xlabel("Frequence(Hz)");ylabel("Amplitude");title("Left temporal");

%Right_temporal
mSubplot(4, 3, 9, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.Right_temporal, :), 1), temp, "UniformOutput", false);
[ff, PMean_Right_temporal, trialsFFT_Right_temporal]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_Right_temporal, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);xlabel("Frequence(Hz)");ylabel("Amplitude");title("Right temporal");

%Parietal
mSubplot(4, 3, 8, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.Parietal, :), 1), temp, "UniformOutput", false);
[ff, PMean_Parietal, trialsFFT_Parietal]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_Parietal, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);ylabel("Amplitude");title("Parietal");

%Occipital
mSubplot(4, 3, 11, 'margins', margins);
area_temp = cellfun(@(x) mean(x(chsAvg.Occipital, :), 1), temp, "UniformOutput", false);
[ff, PMean_Occipital, trialsFFT_Occipital]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_Occipital, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);xlabel("Frequence(Hz)");ylabel("Amplitude");title("Occipital");

scaleAxes("x", [0 10]);
scaleAxes("y", "on");
lines(1).X = 1000 ./ 300; lines(1).color = "k";
addLines2Axes(lines);
FigchsAvg_FFT = gcf;
print(FigchsAvg_FFT, fullfile(FIGPATH, strcat(plotstr, "-FFT")), "-djpeg", "-r200");

%auditory
figure;
maximizeFig;
area_temp = cellfun(@(x) mean(x(chsAvg.auditory, :), 1), temp, "UniformOutput", false);
[ff, PMean_auditory, trialsFFT_auditory]  = trialsECOGFFT(area_temp, fs, tIdx, [], "amplitude");
plot(ff, PMean_auditory, 'color', 'k', 'LineWidth', 2);
set(gca,'FontSize', 10);xlabel("Frequence(Hz)");ylabel("Amplitude");title("auditory");
scaleAxes("x", [0 10]);
scaleAxes("y", "on");
lines(1).X = 1000 ./ 300; lines(1).color = "k";
addLines2Axes(lines);
FigAudichsAvg_FFT = gcf;
print(FigAudichsAvg_FFT, fullfile(FIGPATH, strcat("audi", plotstr, "-FFT")), "-djpeg", "-r200");