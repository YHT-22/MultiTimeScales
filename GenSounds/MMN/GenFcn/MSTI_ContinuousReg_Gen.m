function RegMMNSequence = MSTI_ContinuousReg_Gen(MSTIParams)
parseStruct(MSTIParams);
%% validate parameters
% stdNum and ICI seq(if length of ICI > 1)


% sequence setting
BG_Epoc_Dur = ISI-stdDur;

% ICI setting
BG_ICI = BG_Base * scaleFactor; % background ICI
S1_ICI = S1_S2_Base(1) * scaleFactor;
S2_ICI = S1_S2_Base(2) * scaleFactor;


%% save folder
rootPath = fullfile("..\..\", ParentFolderName, strcat(datestr(now, "yyyy-mm-dd"), "_", folderName));

%% generate single Reg

if BG_Start_Dur == 0
    BG_Start_RegWave.Wave = [];
    BG_Start_RegWave.Duration = 0;
else
    BG_Start_RegWave = RegClickGen(BG_ICI, BG_Start_Dur, Amp);
end
if BG_End_Dur == 0
    BG_End_RegWave.Wave = [];
    BG_End_RegWave.Duration = 0;
else
    BG_End_RegWave = RegClickGen(BG_ICI, BG_End_Dur, Amp);
end


BG_Epoc_RegWave = RegClickGen(repmat(BG_ICI, 1, stdNum), BG_Epoc_Dur, Amp);
S1_Std_RegWave = RegClickGen(repmat(S1_ICI, 1, stdNum), stdDur, Amp);
S2_Std_RegWave = RegClickGen(repmat(S2_ICI, 1, stdNum), stdDur, Amp);
S1_Dev_RegWave = RegClickGen(S1_ICI, devDur, Amp);
S2_Dev_RegWave = RegClickGen(S2_ICI, devDur, Amp);

%merge
RegMMNSequence(1) = merge_MSTI_ContinuousSequence("ContinuousNum", ContinuousNum, "Seq_Tag", "S1_S2", "BG_Start", BG_Start_RegWave, "BG_End", BG_End_RegWave, "BG_Epoc", BG_Epoc_RegWave, "Std_Wave", S1_Std_RegWave, "Dev_Wave", S2_Dev_RegWave);
RegMMNSequence(2) = merge_MSTI_ContinuousSequence("ContinuousNum", ContinuousNum, "Seq_Tag", "S2_S1", "BG_Start", BG_Start_RegWave, "BG_End", BG_End_RegWave, "BG_Epoc", BG_Epoc_RegWave, "Std_Wave", S2_Std_RegWave, "Dev_Wave", S1_Dev_RegWave);


%% export
mkdir(rootPath);
for sIndex = 1 : length(RegMMNSequence)
    audiowrite(strcat(rootPath, "\Reg_", RegMMNSequence(sIndex).Name), RegMMNSequence(sIndex).Wave, RegMMNSequence(sIndex).fs);
end
save(fullfile(rootPath, "MMNSequence.mat"), "RegMMNSequence");
end
