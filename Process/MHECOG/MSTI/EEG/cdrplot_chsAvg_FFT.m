%F_Fp
chsAvg_areaFFT(1).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(1).chsAvgFFT(:, 2 * i) = PMean_F_Fp';
chsAvg_areaFFT(1).area = "F Fp";
%Central
chsAvg_areaFFT(2).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(2).chsAvgFFT(:, 2 * i) = PMean_Central';
chsAvg_areaFFT(2).area = "Central";
%Left_temporal
chsAvg_areaFFT(3).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(3).chsAvgFFT(:, 2 * i) = PMean_Left_temporal';
chsAvg_areaFFT(3).area = "Left_temporal";
%Right_temporal
chsAvg_areaFFT(4).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(4).chsAvgFFT(:, 2 * i) = PMean_Right_temporal';
chsAvg_areaFFT(4).area = "Right_temporal";
%Parietal
chsAvg_areaFFT(5).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(5).chsAvgFFT(:, 2 * i) = PMean_Parietal';
chsAvg_areaFFT(5).area = "Parietal";
%Occipital
chsAvg_areaFFT(6).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(6).chsAvgFFT(:, 2 * i) = PMean_Parietal';
chsAvg_areaFFT(6).area = "Occipital";
%auditory
chsAvg_areaFFT(7).chsAvgFFT(:, 2 * i - 1) = ff';
chsAvg_areaFFT(7).chsAvgFFT(:, 2 * i) = PMean_auditory';
chsAvg_areaFFT(7).area = "auditory";