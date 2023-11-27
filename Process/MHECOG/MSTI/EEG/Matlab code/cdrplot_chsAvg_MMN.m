%F_Fp
chsAvg_MMNcompare(1).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(1).chsAvgMean(:, 3 * gIndex - 1) = chMean_F_Fp;%dev
chsAvg_MMNcompare(1).chsAvgMean(:, 3 * gIndex) = chMeanmove_F_Fp;%std
chsAvg_MMNcompare(1).chsAvgRMS{gIndex}(1,2) = RMS_F_Fp;%dev
chsAvg_MMNcompare(1).chsAvgRMS{gIndex}(1,1) = RMSmove_F_Fp;%std
chsAvg_MMNcompare(1).area = "F Fp";
%Central
chsAvg_MMNcompare(2).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(2).chsAvgMean(:, 3 * gIndex - 1) = chMean_Central;%dev
chsAvg_MMNcompare(2).chsAvgMean(:, 3 * gIndex) = chMeanmove_Central;%std
chsAvg_MMNcompare(2).chsAvgRMS{gIndex}(1,2) = RMS_Central;%dev
chsAvg_MMNcompare(2).chsAvgRMS{gIndex}(1,1) = RMSmove_Central;%std
chsAvg_MMNcompare(2).area = "Central";
%Left_temporal
chsAvg_MMNcompare(3).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(3).chsAvgMean(:, 3 * gIndex - 1) = chMean_Left_temporal;%dev
chsAvg_MMNcompare(3).chsAvgMean(:, 3 * gIndex) = chMeanmove_Left_temporal;%std
chsAvg_MMNcompare(3).chsAvgRMS{gIndex}(1,2) = RMS_Left_temporal;%dev
chsAvg_MMNcompare(3).chsAvgRMS{gIndex}(1,1) = RMSmove_Left_temporal;%std
chsAvg_MMNcompare(3).area = "Left_temporal";
%Right_temporal
chsAvg_MMNcompare(4).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(4).chsAvgMean(:, 3 * gIndex - 1) = chMean_Right_temporal;%dev
chsAvg_MMNcompare(4).chsAvgMean(:, 3 * gIndex) = chMeanmove_Right_temporal;%std
chsAvg_MMNcompare(4).chsAvgRMS{gIndex}(1,2) = RMS_Right_temporal;%dev
chsAvg_MMNcompare(4).chsAvgRMS{gIndex}(1,1) = RMSmove_Right_temporal;%std
chsAvg_MMNcompare(4).area = "Right_temporal";
%Parietal
chsAvg_MMNcompare(5).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(5).chsAvgMean(:, 3 * gIndex - 1) = chMean_Parietal;%dev
chsAvg_MMNcompare(5).chsAvgMean(:, 3 * gIndex) = chMeanmove_Parietal;%std
chsAvg_MMNcompare(5).chsAvgRMS{gIndex}(1,2) = RMS_Parietal;%dev
chsAvg_MMNcompare(5).chsAvgRMS{gIndex}(1,1) = RMSmove_Parietal;%std
chsAvg_MMNcompare(5).area = "Parietal";
%Occipital
chsAvg_MMNcompare(6).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(6).chsAvgMean(:, 3 * gIndex - 1) = chMean_Occipital;%dev
chsAvg_MMNcompare(6).chsAvgMean(:, 3 * gIndex) = chMeanmove_Occipital;%std
chsAvg_MMNcompare(6).chsAvgRMS{gIndex}(1,2) = RMS_Occipital;%dev
chsAvg_MMNcompare(6).chsAvgRMS{gIndex}(1,1) = RMSmove_Occipital;%std
chsAvg_MMNcompare(6).area = "Occipital";
%auditory
chsAvg_MMNcompare(7).chsAvgMean(:, 3 * gIndex - 2) = t';
chsAvg_MMNcompare(7).chsAvgMean(:, 3 * gIndex - 1) = chMean_auditory;%dev
chsAvg_MMNcompare(7).chsAvgMean(:, 3 * gIndex) = chMeanmove_auditory;%std
chsAvg_MMNcompare(7).chsAvgRMS{gIndex}(1,2) = RMS_auditory;%dev
chsAvg_MMNcompare(7).chsAvgRMS{gIndex}(1,1) = RMSmove_auditory;%std
chsAvg_MMNcompare(7).area = "auditory";