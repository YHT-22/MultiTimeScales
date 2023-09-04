function Y_batchExport(ROOTPATH, protocolsToExport, DATESTRs, SUBJECTs)
% Export baseline-correted EEG wave and trials
narginchk(1, 4);

addpath(genpath(fileparts(mfilename("fullpath"))), "-begin");
BDFROOTPATH = [ROOTPATH, 'OffsetMSTI\'];
% currentPath = getRootDirPath(BDFROOTPATH, 1);
opts.fhp = 2;
opts.flp = 100;

if nargin < 2 || isempty(protocolsToExport)
    opts.protocols = {['passive1'], ['passive2'], ['passive3']};
else
    opts.protocols = protocolsToExport;
end
SAVEROOTPATH = [ROOTPATH, 'MAT DATA\'];
mkdir(SAVEROOTPATH);

% window setting, ms
windowBase = [-300, 0];
windows = struct("window",   {[-500, 2000]; ... % passive1
                              [-500, 2000]; ... % passive2
                              [-500, 9000]}, ... % passive3
                 "protocol", {"passive1"; ...
                              "passive2"; ...
                              "passive3"});
save([SAVEROOTPATH, 'windows.mat'], "windows", "windowBase");

% exclude trials
tTh = 0.2;
chTh = 20;

%% Load and save
if nargin < 3
    DATESTRs = dir(BDFROOTPATH);
    DATESTRs = DATESTRs([DATESTRs.isdir]);
    DATESTRs = {DATESTRs(3:end).name}';
end

DAYPATHs = cellfun(@(x) fullfile(BDFROOTPATH, x), DATESTRs, "UniformOutput", false);

% For each day
for dIndex = 1:length(DAYPATHs)
    SUBJECTsTemp = dir(DAYPATHs{dIndex});
    SUBJECTsTemp = SUBJECTsTemp([SUBJECTsTemp.isdir]);    
    if length(SUBJECTsTemp) < 3
        warning(['No DATA found in ', num2str(DATESTRs{dIndex})]);
        continue;
    else
        SUBJECTsTemp = {SUBJECTsTemp(3:end).name}';
    end

    if nargin >= 4
        SUBJECTsTemp = SUBJECTsTemp(contains(SUBJECTsTemp, SUBJECTs));

        if ~all(contains(SUBJECTsTemp, SUBJECTs))
            continue;
        end

    end
    
    % For every subject in a single day
    for sIndex = 1:length(SUBJECTsTemp)
        disp(['Current: Day ', char(DATESTRs{dIndex}), ' ', char(SUBJECTsTemp{sIndex})]);
        DATAPATH = fullfile(BDFROOTPATH, DATESTRs{dIndex}, SUBJECTsTemp{sIndex});
        SAVEPATH = fullfile(SAVEROOTPATH, DATESTRs{dIndex}, SUBJECTsTemp{sIndex});

        opts.DATEStr = DATESTRs{dIndex};
        [EEGDatasets, trialDatasets] = Y_EEGPreprocess(DATAPATH, opts);
        fs = EEGDatasets(1).fs;
        protocols = {trialDatasets.protocol}';

        mkdir(SAVEPATH);

        % Protocols
        protocols = protocols(contains(protocols, opts.protocols));

        % For each protocol
        for pIndex = 1:length(protocols)
            MATNAME = fullfile(SAVEPATH, strcat(protocols(pIndex), ".mat"));
            window = windows([windows.protocol] == protocols(pIndex)).window;
            trialAll = trialDatasets(ismember({trialDatasets.protocol}, protocols(pIndex))).trialAll';
            trialsEEG = selectEEG(EEGDatasets(ismember({EEGDatasets.protocol}, protocols(pIndex))), ...
                                              trialAll, ...
                                              window);

            % Baseline correction
            trialsEEG = baselineCorrection(trialsEEG, fs, window, windowBase);

            tIdx = excludeTrials(trialsEEG, tTh, chTh, "userDefineOpt", "off");
            trialsEEG(tIdx) = [];
            trialAll(tIdx) = [];
            save(MATNAME, "windowBase", "window", "trialsEEG", "trialAll", "fs", "opts");
        end

    end

end