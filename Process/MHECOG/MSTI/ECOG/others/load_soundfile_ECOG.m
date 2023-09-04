%%
% loadPath = validateInput('Please input sounddir path:',@(x) validateattributes(x, {'string'}, {'char'}));
if matches(protStr,"MSTIomi_S1-3_S2-3o6_ISI_400_Dur_200_STDN_12")
    loadPath = "I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-05-19_MSTIomi_S1-3_S2-3o6_ISI_400_Dur_200_STDN_12";              
elseif matches(protStr, "MSTIomi_S1-14o4_S2-17o3_ISI_400_Dur_200_STDN_12")
    loadPath = "I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-05-19_MSTIomi_S1-14o4_S2-17o3_ISI_400_Dur_200_STDN_12";
elseif matches(protStr, "MSTImulti_BG3o6_17o3_ISI_600_Dur_300_STDN_9")
    loadPath = "I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-05-31_MSTImulti_BG3o6_17o3_ISI_600_Dur_300_STDN_9";
elseif matches(protStr, "MSTImulti_BG3o6_18o2_ISI_600_Dur_300_STDN_9")
    loadPath = "I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-06-25_MSTImulti_BG3o6_18o2_ISI_600_Dur_300_STDN_9";
end
tCutoff = 20;
files = dir(loadPath);
files(matches({files.name}, ".") | matches({files.name}, "..") | ~contains({files.name}, ".wav")) = [];
[y1, soundfs] = cellfun(@(x) audioread(fullfile(loadPath, x)), {files.name}', "UniformOutput", false);
[yLength, sLength, cutLength, interval, changeHighIdx, toHighIdx, T, onIdx] = ...
    cellfun(@(x, y) parseClickTrain(x, y, tCutoff), y1, soundfs, "UniformOutput", false);

%% 
Fields = {'name', 'sLength', 'cutLength', 'interval', 'y1', 'fs', ...
    'changeHighIdx', 'toHighIdx', 'T', 'onIdx'}';
Values = [{files.name}', sLength, cutLength, interval, y1, soundfs, ...
    changeHighIdx, toHighIdx, T, onIdx, num2cell(ones(length(T), 1) * tCutoff)];
Sound = easyStruct(Fields, Values);
