clear; clc;

DataRootPath = "G:\DATA_202305_HumenEEG_MSTI\MAT DATA\";
DateDirInfo = dir(DataRootPath);
DateDirInfo = DateDirInfo(~contains(string({DateDirInfo.name})', {'.', '..'}) & [DateDirInfo.isdir]');

n = 0;
for DateIdx = 1 : numel(DateDirInfo)
    DateStr = string(DateDirInfo(DateIdx).name);
    DatePath = strcat(DataRootPath, DateStr, "\");
    SubjDirInfo = dir(DatePath);
    SubjDirInfo = SubjDirInfo(~contains(string({SubjDirInfo.name})', {'.', '..'}) & [SubjDirInfo.isdir]');
    for SubjIdx = 1 : numel(SubjDirInfo)
        n = n + 1;
        SubjStr = string(SubjDirInfo(SubjIdx).name);
        SubjPath = strcat(DatePath, SubjStr, "\");
        Temp = load(strcat(SubjPath, "CDRchsAvg_MMN.mat"));
        AudiMMN = Temp.chsAvg_MMNcompare(matches([Temp.chsAvg_MMNcompare.area], "auditory", "IgnoreCase", true)).chsAvgRMS;
        popData_AudyMMN(n).Date = DateStr;
        popData_AudyMMN(n).Subject = SubjStr;
        popData_AudyMMN(n).CmpareRMS(:, 1) = AudiMMN';
        popData_AudyMMN(n).CmpareRMS{1, 2} = "Std4.3-Dev4.3";
        popData_AudyMMN(n).CmpareRMS{2, 2} = "Std3-Dev3";
        popData_AudyMMN(n).CmpareRMS{3, 2} = "Std21.9-Dev21.9";
        popData_AudyMMN(n).CmpareRMS{4, 2} = "Std15.2-Dev15.2";
    end
end

%%
Std4o3Dev4o3 = cell2mat(arrayfun(@(x) cellfun(@(y) y(1), x), {popData_AudyMMN.CmpareRMS}'));
Std3Dev3 = cell2mat(arrayfun(@(x) cellfun(@(y) y(2), x), {popData_AudyMMN.CmpareRMS}'));
Std21o9Dev21o9 = cell2mat(arrayfun(@(x) cellfun(@(y) y(3), x), {popData_AudyMMN.CmpareRMS}'));
Std15o2Dev15o2 = cell2mat(arrayfun(@(x) cellfun(@(y) y(4), x), {popData_AudyMMN.CmpareRMS}'));
%% sig test
ExcludeIdx = [8,10,12,25,26,28];
SelectIdx = arrayfun(@(x) ~ismember(x, ExcludeIdx), 1 : numel({popData_AudyMMN.CmpareRMS})')';
[h_ICI4o3, p_ICI4o3] = ttest(Std4o3Dev4o3(SelectIdx, 2)./Std4o3Dev4o3(SelectIdx, 1), 1, "Tail", "right");
[h_ICI3, p_ICI3] = ttest(Std3Dev3(SelectIdx, 2)./Std3Dev3(SelectIdx, 1), 1, "Tail", "right");
[h_ICI21o9, p_ICI21o9] = ttest(Std21o9Dev21o9(SelectIdx, 2)./Std21o9Dev21o9(SelectIdx, 1), 1, "Tail", "right");
[h_ICI15o2, p_ICI15o2] = ttest(Std15o2Dev15o2(SelectIdx, 2)./Std15o2Dev15o2(SelectIdx, 1), 1, "Tail", "right");



