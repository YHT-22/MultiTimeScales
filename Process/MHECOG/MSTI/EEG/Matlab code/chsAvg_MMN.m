figure;maximizeFig;
%F_Fp
mSubplot(4, 3, 2, 'margins', margins);
chMean_F_Fp = mean(chMeanData(DevIdx).chMean(chsAvg.F_Fp, :), 1);
chMeanmove_F_Fp = mean(chMeanData(StdIdx).chMean_move(chsAvg.F_Fp, :), 1);
RMS_F_Fp = rms(chMean_F_Fp(:, tIdx_RMS), 2);
RMSmove_F_Fp = rms(chMeanmove_F_Fp(:, tIdx_RMS), 2);
plot(t, chMean_F_Fp, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_F_Fp, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);ylabel("ERP(muV)");title("F Fp");
% 
% %Central
mSubplot(4, 3, 5, 'margins', margins);
chMean_Central = mean(chMeanData(DevIdx).chMean(chsAvg.Central, :), 1);
chMeanmove_Central = mean(chMeanData(StdIdx).chMean_move(chsAvg.Central, :), 1);
RMS_Central = rms(chMean_Central(:, tIdx_RMS), 2);
RMSmove_Central = rms(chMeanmove_Central(:, tIdx_RMS), 2);
plot(t, chMean_Central, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_Central, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);ylabel("ERP(muV)");title("Central");
% 
% %Left_temporal
mSubplot(4, 3, 7, 'margins', margins);
chMean_Left_temporal = mean(chMeanData(DevIdx).chMean(chsAvg.Left_temporal, :), 1);
chMeanmove_Left_temporal = mean(chMeanData(StdIdx).chMean_move(chsAvg.Left_temporal, :), 1);
RMS_Left_temporal = rms(chMean_Left_temporal(:, tIdx_RMS), 2);
RMSmove_Left_temporal = rms(chMeanmove_Left_temporal(:, tIdx_RMS), 2);
plot(t, chMean_Left_temporal, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_Left_temporal, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);xlabel("Time (ms)");ylabel("ERP(muV)");title("Left temporal");
% 
% %Right_temporal 
mSubplot(4, 3, 9, 'margins', margins);
chMean_Right_temporal = mean(chMeanData(DevIdx).chMean(chsAvg.Right_temporal, :), 1);
chMeanmove_Right_temporal = mean(chMeanData(StdIdx).chMean_move(chsAvg.Right_temporal, :), 1);
RMS_Right_temporal = rms(chMean_Right_temporal(:, tIdx_RMS), 2);
RMSmove_Right_temporal = rms(chMeanmove_Right_temporal(:, tIdx_RMS), 2);
plot(t, chMean_Right_temporal, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_Right_temporal, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);xlabel("Time (ms)");ylabel("ERP(muV)");title("Right temporal");
% 
% %Parietal 
mSubplot(4, 3, 8, 'margins', margins);
chMean_Parietal = mean(chMeanData(DevIdx).chMean(chsAvg.Parietal, :), 1);
chMeanmove_Parietal = mean(chMeanData(StdIdx).chMean_move(chsAvg.Parietal, :), 1);
RMS_Parietal = rms(chMean_Parietal(:, tIdx_RMS), 2);
RMSmove_Parietal = rms(chMeanmove_Parietal(:, tIdx_RMS), 2);
plot(t, chMean_Parietal, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_Parietal, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);ylabel("ERP(muV)");title("Parietal");

%Occipital
mSubplot(4, 3, 11, 'margins', margins);
chMean_Occipital = mean(chMeanData(DevIdx).chMean(chsAvg.Occipital, :), 1);
chMeanmove_Occipital = mean(chMeanData(StdIdx).chMean_move(chsAvg.Occipital, :), 1);
RMS_Occipital = rms(chMean_Occipital(:, tIdx_RMS), 2);
RMSmove_Occipital = rms(chMeanmove_Occipital(:, tIdx_RMS), 2);
plot(t, chMean_Occipital, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_Occipital, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 10);xlabel("Time (ms)");ylabel("ERP(muV)");title("Occipital");

scaleAxes("x", [Sound(Devsound_idx).Std_Dev_onset(end)*1000 - 100, Sound(Devsound_idx).Std_Dev_onset(end)*1000 + moveTime(Stdsound_idx)]);
scaleAxes("y", [-6,6]);        
lines(1).X = Sound(Devsound_idx).Std_Dev_onset(end)*1000;lines(1).color = 'k';
addLines2Axes(lines);
FigchsAvg_MMNCompare = gcf;
print(FigchsAvg_MMNCompare, fullfile(FIGPATH, strcat(strrep(chMeanData(DevIdx).soundname, '.', 'o'), "-MMN Comparison")), "-djpeg", "-r200");

% %auditory
figure;maximizeFig;
chMean_auditory = mean(chMeanData(DevIdx).chMean(chsAvg.auditory, :), 1);
chMeanmove_auditory = mean(chMeanData(StdIdx).chMean_move(chsAvg.auditory, :), 1);
RMS_auditory = rms(chMean_auditory(:, tIdx_RMS), 2);
RMSmove_auditory = rms(chMeanmove_auditory(:, tIdx_RMS), 2);

plot(t, chMean_auditory, "Color", 'r', 'LineWidth', 2, 'DisplayName', "Dev");hold on;
plot(t, chMeanmove_auditory, "Color", 'b',  'LineWidth', 2, 'DisplayName', "Std");
legend;
set(gca,'FontSize', 15);xlabel("Time (ms)");ylabel("ERP(muV)");title("auditory");

scaleAxes("x", [Sound(Devsound_idx).Std_Dev_onset(end)*1000 - 100, Sound(Devsound_idx).Std_Dev_onset(end)*1000 + moveTime(Stdsound_idx)]);
scaleAxes("y", [-6,6]);        
lines(1).X = Sound(Devsound_idx).Std_Dev_onset(end)*1000;lines(1).color = 'k';
addLines2Axes(lines);
FigAudichsAvg_MMNCompare = gcf;
print(FigAudichsAvg_MMNCompare, fullfile(FIGPATH, strcat("audi", strrep(chMeanData(DevIdx).soundname, '.', 'o'), "-MMN Comparison")), "-djpeg", "-r200");