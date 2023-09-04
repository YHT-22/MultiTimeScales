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

    if monkeyStr == 'XX'
        loadPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-04-14_LocalChange_4s-4s_BaseICI14.4_devratio_1.02';
    elseif monkeyStr == 'CC'
        loadPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIMonkeySound\2023-04-14_LocalChange_4s-4s_BaseICI15.2_devratio_1.02';
    end
    run("load_soundfile_ECOG.m");
    Sounds = Sound(1:5);
    ChangePoint = cellfun(@(x) find(diff(x, 1, 1) ~= 0), {Sounds.interval}', "UniformOutput", false);
    CTLparams.changepoint = cellfun(@(x,y,z) sum(y(1:x))/z * 1000, ChangePoint, {Sounds.interval}', {Sounds.fs}', "UniformOutput", false);

    if ~exist(strcat(FIGPATH, AREANAME, "SingleData_changeduiqi.mat"), "file")
        if strcmp(AREANAME, "AC")
            [trialAll, trialsECOG_Merge, trialsECOG_S1_Merge, badCHs] = mergeCTLTrialsECOG_BaseICI([MATPATHs{mIndex}, DATEStrs{mIndex}, '_AC.mat'], AREANAME, CTLparams);
        else strcmp(AREANAME, "PFC")
            [trialAll, trialsECOG_Merge, trialsECOG_S1_Merge, badCHs] = mergeCTLTrialsECOG_BaseICI([MATPATHs{mIndex}, DATEStrs{mIndex}, '_PFC.mat'], AREANAME, CTLparams);
        end
        mSave(strcat(FIGPATH, AREANAME, "SingleData_changeduiqi.mat"), "trialsECOG_S1_Merge", "trialsECOG_Merge", "trialAll", "badCHs");
    else
        load(strcat(FIGPATH, AREANAME, "SingleData_changeduiqi.mat"));
    end
    
    if exist(strcat(FIGPATH, "cdrPlot_AC.mat"), "file")
        load(strcat(FIGPATH, "cdrPlot_AC.mat"));
    end

    badCHs = [];
    toc
    
