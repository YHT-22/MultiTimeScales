function MSTI_batchSingle(protocolsToProcess, dataOnlyOpt, DATESTRs, SUBJECTs, MATROOTPATH, FIGROOTPATH)
% Process each protocol for each subject
narginchk(0, 6);

addpath(genpath(fileparts(mfilename("fullpath"))), "-begin");

% currentPath = getRootDirPath(fileparts(mfilename("fullpath")), 1);
% MATROOTPATH = fullfile(currentPath, 'MAT DATA');
FIGROOTPATH = fullfile(FIGROOTPATH, 'Figures');

if nargin < 1 || isempty(protocolsToProcess)
    protocolsToProcess = ["passive1", "passive2", "passive3", "passive4"];
end

if nargin < 2
    params.dataOnlyOpt = false; % true - save temporal data only without plotting
else
    params.dataOnlyOpt = dataOnlyOpt;
end

%% Load and save
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

    % For every subject in a single day
    for sIndex = 1:length(SUBJECTsTemp)
        MATDirPATH = fullfile(MATROOTPATH, DATESTRs{dIndex}, SUBJECTsTemp{sIndex});
        FIGPATH = fullfile(FIGROOTPATH, DATESTRs{dIndex}, SUBJECTsTemp{sIndex});

        disp(['Current: Day ', char(DATESTRs{dIndex}), ' ', char(SUBJECTsTemp{sIndex})]);
        matfiles = what(MATDirPATH).mat;
        protocols = cellfun(@(x) obtainArgoutN(@fileparts, 2, x), matfiles, "UniformOutput", false);
        idx = contains(protocols, protocolsToProcess);
        protocols = protocols(idx);
        matfiles = matfiles(idx);

        % For each protocol
        for pIndex = 1:length(protocols)
            run("chsAvg_Custom.m");
            protocolProcessFcn = @MSTIpassiveProcessFcn;
            MATPATH = fullfile(MATDirPATH, matfiles{pIndex});
            load(MATPATH, "windowBase", "window", "trialsEEG", "trialAll", "fs");

            params.FIGPATH = fullfile(FIGPATH, protocols{pIndex});
            params.SAVEPATH = MATDirPATH;
            params.windowBase = windowBase;
            run("load_Allsoundfile_EEG.m");
            params.Sound = Sound;
            protocolProcessFcn(trialAll, trialsEEG, window, fs, params);
        end

    end

end