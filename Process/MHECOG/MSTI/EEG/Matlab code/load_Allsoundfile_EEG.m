
loadPath = "G:\DATA_202305_HumenEEG_MSTI\HumenEEGSounds\MSTI\AllSounds";
tCutoff = 20;
files = dir(loadPath);
files(matches({files.name}, ".") | matches({files.name}, "..") | ~contains({files.name}, ".wav")) = [];
[y1, soundfs] = cellfun(@(x) audioread(fullfile(loadPath, x)), {files.name}', "UniformOutput", false);
[yLength, sLength, cutLength, interval, changeHighIdx, toHighIdx, T, onIdx] = ...
    cellfun(@(x, y) parseClickTrain(x, y, tCutoff), y1, soundfs, "UniformOutput", false);

%% 
code = {[4], [5], [6], [7], [8], [9]}'; 

Fields = {'name', 'code', 'sLength', 'cutLength', 'interval', 'y1', 'fs', ...
    'changeHighIdx', 'toHighIdx', 'T', 'onIdx'}';
Values = [{files.name}', code, sLength, cutLength, interval, y1, soundfs, ...
    changeHighIdx, toHighIdx, T, onIdx, num2cell(ones(length(T), 1) * tCutoff)];
Sound = easyStruct(Fields, Values);

