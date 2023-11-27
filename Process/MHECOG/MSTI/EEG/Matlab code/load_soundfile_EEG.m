%%
% keyboard;
% loadPath = validateInput('Please input sounddir path:',@(x) validateattributes(x, {'string'}, {'char'}));
if str2double(DATESTRs{dIndex}) < 20230518
    loadPath = "G:\DATA_202305_HumenEEG_MSTI\HumenEEGSounds\MSTI\20230508";
elseif str2double(DATESTRs{dIndex}) >= 20230518 & str2double(DATESTRs{dIndex}) < 20231115
    loadPath = "G:\DATA_202305_HumenEEG_MSTI\HumenEEGSounds\MSTI\20230518"; 
elseif str2double(DATESTRs{dIndex}) >= 20231115
    loadPath = "G:\DATA_202305_HumenEEG_MSTI\HumenEEGSounds\MSTI\20231115"; 
end
tCutoff = 20;
files = dir(loadPath);
files(matches({files.name}, ".") | matches({files.name}, "..") | ~contains({files.name}, ".wav")) = [];
[y1, soundfs] = cellfun(@(x) audioread(fullfile(loadPath, x)), {files.name}', "UniformOutput", false);
[yLength, sLength, cutLength, interval, changeHighIdx, toHighIdx, T, onIdx] = ...
    cellfun(@(x, y) parseClickTrain(x, y, tCutoff), y1, soundfs, "UniformOutput", false);

%% 
if str2double(DATESTRs{dIndex}) < 20230518
    code = {[91], [92], [93], [94]}';
elseif str2double(DATESTRs{dIndex}) >= 20230518 & str2double(DATESTRs{dIndex}) < 20231115
    code = {[4], [5], [6], [7]}'; 
elseif str2double(DATESTRs{dIndex}) >= 20231115
    code = {[4], [5], [8], [9]}';
end
Fields = {'name', 'code', 'sLength', 'cutLength', 'interval', 'y1', 'fs', ...
    'changeHighIdx', 'toHighIdx', 'T', 'onIdx'}';
Values = [{files.name}', code, sLength, cutLength, interval, y1, soundfs, ...
    changeHighIdx, toHighIdx, T, onIdx, num2cell(ones(length(T), 1) * tCutoff)];
Sound = easyStruct(Fields, Values);

