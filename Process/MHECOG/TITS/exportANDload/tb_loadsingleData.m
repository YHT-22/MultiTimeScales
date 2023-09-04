    %% load data
    disp("loading data...");
    tic
    if exist(strcat(FIGPATH, AREANAME, "Process_params.mat"), "file")
        load(strcat(FIGPATH, AREANAME, "Process_params.mat"));
        parseStruct(CTLparams);
    else
        save(strcat(FIGPATH, AREANAME, "Process_params.mat"), "CTLparams");
        parseStruct(CTLparams);
    end
    fs = CTLparams.fs;

    if ~exist(strcat(FIGPATH, AREANAME, "SingleData.mat"), "file")
        if strcmp(AREANAME, "AC")
            [trialAll, trialsECOG_Merge, trialsECOG_S1_Merge, badCHs] = mergeCTLTrialsECOG([MATPATHs{mIndex}, DATEStrs{mIndex}, '_AC.mat'], AREANAME, CTLparams);
        else strcmp(AREANAME, "PFC")
            [trialAll, trialsECOG_Merge, trialsECOG_S1_Merge, badCHs] = mergeCTLTrialsECOG([MATPATHs{mIndex}, DATEStrs{mIndex}, '_PFC.mat'], AREANAME, CTLparams);
        end
        mSave(strcat(FIGPATH, AREANAME, "SingleData.mat"), "trialsECOG_S1_Merge", "trialsECOG_Merge", "trialAll", "badCHs");
    else
        load(strcat(FIGPATH, AREANAME, "SingleData.mat"));
    end
    
    if exist(strcat(FIGPATH, "cdrPlot_AC.mat"), "file")
        load(strcat(FIGPATH, "cdrPlot_AC.mat"));
    end

    badCHs = [];
    toc
