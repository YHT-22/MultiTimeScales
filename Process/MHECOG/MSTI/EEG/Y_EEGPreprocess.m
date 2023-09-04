function [EEGDatasets, trialDatasets] = Y_EEGPreprocess(ROOTPATH, opts)
%     ft_setPath2Top;

    narginchk(1, 2);

    if nargin < 2
        opts = [];
    end
    preprocessConfig()
    opts = getOrFull(opts, paramsDefault);

    %% Load from *.mat
    try
        disp("Try loading data from MAT.");
        load(fullfile(ROOTPATH, 'data.mat'), "-mat", "EEGDatasets", "trialDatasets");

        if exist("EEGDatasets", "var") && exist("trialDatasets", "var")
            disp("Data loading success.");
            return;
        else
            ME = MException("EEGPreprocess:dataLoading", "File not found.");
            throw(ME);
        end
        
    catch ME
        disp(ME.message);
        disp("Try loading data from BDF.");
    end

    %% Load from *.bdf
    matFileNames = what(ROOTPATH).mat;
    matFileNames = matFileNames(cellfun(@(x) ismember(str2double(obtainArgoutN(@fileparts, 2, x)), 1:9), matFileNames));
    folders = dir(ROOTPATH);
    folders = folders([folders.isdir]);
    folders = folders(3:end);

    for idx = 1:length(matFileNames)
        load(fullfile(ROOTPATH, matFileNames{idx}), "-mat", "trialsData", "protocol");
%         BDFPATH = fullfile(ROOTPATH, folders(strcmpi({folders.name}, protocol)).name);
        BDFPATH = fullfile(ROOTPATH, folders(contains({folders.name}, protocol)).name);
        EEG = readbdfdata({'data.bdf', 'evt.bdf'}, [BDFPATH, '\']);
        EEGDatasets(idx).protocol = protocol;
        EEGDatasets(idx).data = EEG.data;
        EEGDatasets(idx).fs = EEG.srate;
        EEGDatasets(idx).chanlocs = EEG.chanlocs;
        EEGDatasets(idx).channels = (1:size(EEGDatasets(idx).data, 1))';
        EEGDatasets(idx).event = EEG.event;
        EEGDatasets(idx) = EEGFilter(EEGDatasets(idx), opts.fhp, opts.flp);

        trialDatasets(idx).protocol = protocol;
        trialDatasets(idx).trialAll = EEGBehaviorProcess(trialsData, EEGDatasets(idx));
    end

    disp("Data loading success.");

    if opts.save
        disp("Saving...");
        uisave(["EEGDatasets", "trialDatasets"], fullfile(ROOTPATH, "data.mat"));
    end

    return;
end