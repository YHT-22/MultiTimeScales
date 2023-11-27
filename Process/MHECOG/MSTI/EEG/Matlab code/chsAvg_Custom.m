% keyboard
chsAvg.all = 1:64;
chsAvg.all([47, 60:64]) = [];
chsAvg.auditory = 33:64;
chsAvg.auditory(ismember(chsAvg.auditory, [60:64])) = [];
chsAvg.F_Fp = [1:25];%Frontal&Prefrontol
chsAvg.Central = [26:30,35:38];%Central
chsAvg.Left_temporal = [31,33,39,41,44,46,48,51,53,55,58];%Left temporal
chsAvg.Right_temporal = [32,34,40,42,45,47,49,52,54,56,59];%Right temporal
chsAvg.Parietal = [43,50,57];%Parietal
chsAvg.Occipital = [61,62];%Occipital

save([MATDirPATH, '\', 'chsAvg.mat'], "chsAvg", '-mat');