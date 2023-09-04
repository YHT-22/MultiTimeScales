function MSTIParams = Y_ParseMSTIParams(protStr)

Y_MSTI_Update_Config;

% load excel
configPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIConfig.xlsx';
configTable = table2struct(readtable(configPath));
mProtocol = configTable(matches({configTable.paradigm}', protStr));

% parse CTLProt
MSTIParams.Window = str2double(string(strsplit(mProtocol.Window, ",")));
MSTIParams.DevPlotWin = str2double(string(strsplit(mProtocol.DevPlotWin, ",")));
MSTIParams.FFTWin_local = str2double(string(strsplit(mProtocol.FFTWin_local, ",")));
MSTIParams.FFTWin_change = str2double(string(strsplit(mProtocol.FFTWin_change, ",")));
MSTIParams.RMSWin = str2double(string(strsplit(mProtocol.RMSWin, ",")));
MSTIParams.stimStrs = string(strsplit(mProtocol.trialTypes, ","));
MSTIParams.protStr = string(mProtocol.paradigm);
MSTIParams.orderIndex = cell2mat(cellfun(@(x) str2double(string(strsplit(x, "-"))), strsplit(convertCharsToStrings(mProtocol.orderIndex), ",")', "uni", false));
MSTIParams.Std_Dev_Onset = cell2mat(cellfun(@(x) str2double(strsplit(x, ",")), string(strsplit(mProtocol.Std_Dev_Onset, ";")), "uni", false)');
MSTIParams.DevOnset = MSTIParams.Std_Dev_Onset(:, end);
MSTIParams.S1_S2 = table2array(cell2table(cellfun(@(x) string(strsplit(x, ",")), string(strsplit(mProtocol.S1_S2, ";")), "uni", false)'));
MSTIParams.colors = string(strsplit(mProtocol.colors, ","));
MSTIParams.duration = str2double(string(mProtocol.duration));
MSTIParams.fhp = str2double(string(mProtocol.fhp));
MSTIParams.flp = str2double(string(mProtocol.flp));
MSTIParams.fhp2 = str2double(string(mProtocol.fhp2));
MSTIParams.flp2 = str2double(string(mProtocol.flp2));
MSTIParams.fs = str2double(string(mProtocol.fs));
end

