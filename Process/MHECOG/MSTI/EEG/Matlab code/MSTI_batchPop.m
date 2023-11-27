function MSTI_batchPop(protocolsToProcess, dataOnlyOpt, DATESTRs, SUBJECTs, MATROOTPATH, FIGROOTPATH, ExcludeSubjOpt)
% Process each protocol for each subject
narginchk(0, 7);

addpath(genpath(fileparts(mfilename("fullpath"))), "-begin");

% currentPath = getRootDirPath(fileparts(mfilename("fullpath")), 1);
FIGROOTPATH = fullfile(FIGROOTPATH, 'Figures');

if nargin < 1 || isempty(protocolsToProcess)
    protocolsToProcess = ["passive1", "passive2", "passive3", "passive4"];
end

if nargin < 2
    params.dataOnlyOpt = false; % true - save temporal data only without plotting
else
    params.dataOnlyOpt = dataOnlyOpt;
end

if exist("ExcludeSubjOpt", "var") && ExcludeSubjOpt 
    ExcludeInfo = readtable(fullfile(fileparts(mfilename("fullpath")), "ExcludeSubj.xlsx"));

end
%% Load and save
trialAllpop = []; trialEEGpop = [];
if ~exist("DATESTRs") || isempty(DATESTRs)
    DATESTRs = dir(MATROOTPATH);
    DATESTRs = DATESTRs([DATESTRs.isdir]);
    DATESTRs = {DATESTRs(3:end).name}';
end

DAYPATHs = cellfun(@(x) fullfile(MATROOTPATH, x), DATESTRs, "UniformOutput", false);

% For each day
for dIndex = 1:length(DAYPATHs)
    SUBJECTsTemp = dir(DAYPATHs{dIndex});

    if length(SUBJECTsTemp) < 3
        warning(['No DATA found in ', num2str(DATESTRs{dIndex})]);
        continue;
    else
        SUBJECTsTemp = {SUBJECTsTemp(3:end).name}';
    end

    if ~isempty(SUBJECTs)
        SUBJECTsTemp = SUBJECTsTemp(contains(SUBJECTsTemp, SUBJECTs));
        if ~all(contains(SUBJECTsTemp, SUBJECTs))
            continue;
        end
    end

    if exist("ExcludeInfo", "var")
        if ismember(string(DATESTRs{dIndex}), [string(ExcludeInfo.Date)])
            SubjIdx = ~ismember([string(SUBJECTsTemp)], [string(ExcludeInfo.Subj)]);
            SUBJECTsTemp = SUBJECTsTemp(SubjIdx);
        end
    end

    % For every subject in a single day
    for sIndex = 1 : length(SUBJECTsTemp)

        MATDirPATH = fullfile(MATROOTPATH, DATESTRs{dIndex}, SUBJECTsTemp{sIndex});

        disp(['Current: Day ', char(DATESTRs{dIndex}), ' ', char(SUBJECTsTemp{sIndex})]);
        matfiles = what(MATDirPATH).mat;
        protocols = cellfun(@(x) obtainArgoutN(@fileparts, 2, x), matfiles, "UniformOutput", false);
        idx = contains(protocols, protocolsToProcess);
        protocols = protocols(idx);
        matfiles = matfiles(idx);

        % For each protocol
        for pIndex = 1:length(protocols)
            clear windowBase window trialsEEG trialAll fs chMeanData sound;
            run("chsAvg_Custom.m");
            protocolProcessFcn = @MSTIpassiveProcessFcn;
            MATPATH = fullfile(MATDirPATH, matfiles{pIndex});
            load(MATPATH, "windowBase", "window", "trialsEEG", "trialAll", "fs");
            load(fullfile(MATDirPATH, "chMean_P3.mat"));
        end
        %%%%%%%%%%%%%%%% unique trialAll %%%%%%%%%%%%%%%%%%
        oldfieldnames = fieldnames(trialAll);
        trialAll_temp = rmfield(trialAll, oldfieldnames(5:end));
        for soundIdx = 1 : numel(string({chMeanData.soundname})')
            sound(soundIdx).code = [chMeanData(soundIdx).soundcode]';
            sound(soundIdx).name = string({chMeanData(soundIdx).soundname})';
        end
        
        for soundIdx = 1 : numel(string({chMeanData.soundname})')
            [trialAll_temp([trialAll_temp.code] == sound(soundIdx).code).type] = deal(string(regexpi(sound(soundIdx).name, '(.*).wav', 'tokens')));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        trialAllpop = [trialAllpop, trialAll_temp];
        trialEEGpop = [trialEEGpop; trialsEEG];

    end
end
    params.FIGPATH = fullfile(FIGROOTPATH, "population");
    params.SAVEPATH = fullfile(strrep(MATROOTPATH, "singleDay", "population"));
    params.windowBase = windowBase;
    run("load_Allsoundfile_EEG.m");
    params.Sound = Sound;    
    protocolProcessFcn = @MSTIpassiveProcessFcn;

    protocolProcessFcn(trialAllpop, trialEEGpop, window, fs, params);


