function [MSTIParams, Sound] = Y_ParseMSTIomiParams(protStr)

% load excel
configPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIomiConfig.xlsx';
configTable = table2struct(readtable(configPath));
mProtocol = configTable(matches({configTable.paradigm}', protStr));
% load sound
loadPath = mProtocol.soundPath;
run("load_soundfile_ECOG.m");
for targetsound_idx = 1:numel(Sound)
    run("get_std_dev_soundonset.m");
    Sound(targetsound_idx).Std_Dev_onset = changeinfo(:, 5);
    Sound(targetsound_idx).dida_Duration = [changeinfo(1,3) / soundfs, changeinfo(2,3) / soundfs];
end

% parse CTLProt
MSTIParams.Window = str2double(string(strsplit(mProtocol.Window, ",")));
MSTIParams.DevPlotWin = str2double(string(strsplit(mProtocol.DevPlotWin, ",")));
MSTIParams.FFTWin_local = str2double(string(strsplit(mProtocol.FFTWin_local, ",")));
MSTIParams.FFTWin_change = str2double(string(strsplit(mProtocol.FFTWin_change, ",")));
MSTIParams.stimStrs = string(strsplit(mProtocol.trialTypes, ","));
MSTIParams.protStr = string(mProtocol.paradigm);
MSTIParams.colors = string(strsplit(mProtocol.colors, ","));
MSTIParams.controlFlag = str2double(string(mProtocol.controlFlag));
MSTIParams.duration = str2double(string(mProtocol.duration));
MSTIParams.fhp = str2double(string(mProtocol.fhp));
MSTIParams.flp = str2double(string(mProtocol.flp));
MSTIParams.fhp2 = str2double(string(mProtocol.fhp2));
MSTIParams.flp2 = str2double(string(mProtocol.flp2));
MSTIParams.fs = str2double(string(mProtocol.fs));
end

