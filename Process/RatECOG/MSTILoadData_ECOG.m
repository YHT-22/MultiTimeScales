    %% load data
    disp("loading data...");
    tic
%     if exist(strcat(FIGPATH, "MSTIparams.mat"), "file")
%         load(strcat(FIGPATH, "MSTIparams.mat"));
%         parseStruct(MSTIparams);
%     else
        save(strcat(FIGPATH, "\MSTIparams.mat"), "MSTIparams", "-mat");
        parseStruct(MSTIparams);
%     end

    if ~exist(strcat(FIGPATH, "ECOGData.mat"), "file")
        if contains(ProtocolStrs, "MSTI")
            [trialAll, trialsECOG, trialsECOG_Lag, badCHs, fs] = MSTITrialsECOG(MATPATHs{mIndex}, params, MSTIparams);
            mSave(strcat(FIGPATH, "\ECOGData.mat"), "trialsECOG", "trialsECOG_Lag", "trialAll", "badCHs", "fs");
        else
            [trialAll, trialsECOG, ~, badCHs, fs] = MSTITrialsECOG(MATPATHs{mIndex}, params, MSTIparams);
            mSave(strcat(FIGPATH, "\ECOGData.mat"), "trialsECOG", "trialAll", "badCHs", "fs");
        end
    else
        load(strcat(FIGPATH, "\ECOGData.mat"));
    end

    badCHs = [];
    toc