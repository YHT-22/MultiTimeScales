
clc;
rootPathMat = strcat("I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\", monkeyName, "\MSTI\");
rootPathFig = "I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTI\";

%% set protocols
temp = dir(rootPathMat);
temp(ismember(string({temp.name}'), [".", ".."])) = [];
protocols = string({temp.name}');

%% select data
% areaSel = "AC";
dateSel = ["20230625"];
protSel = ["MSTImulti_BG3o6_18o2_ISI_600_Dur_300_STDN_9"];
% validate areaSel
if ~matches(areaSel, ["AC", "PFC"]) || length(areaSel) > 1
    error("Var 'areaSel' must be one of 'AC' and 'PFC' !");
end


for rIndex = 1 : length(protocols)
    trialsECOG_pop = []; trialsECOG_pop_Filtered = []; trialsECOG_pop_Lag = []; trialAll_pop = [];
    protPathMat = strcat(rootPathMat, protocols(rIndex), "\");
    protocolStr = protocols(rIndex);

    temp = dir(protPathMat);
    temp(ismember(string({temp.name}'), [".", ".."])) = [];

    MATPATHS = cellfun(@(x) string([char(protPathMat), x, '\']), {temp.name}', "UniformOutput", false);
    MATPATHS = MATPATHS(contains(string(MATPATHS), dateSel) & contains(string(MATPATHS), protSel) );

    temp = cellfun(@(x) strsplit(x, "\"), MATPATHS, "UniformOutput", false);
    MATPATHS = cellfun(@(x, y) strcat(x, y(end-1), "_", areaSel, ".mat"), MATPATHS, temp, "uni", false);


    for mIndex = 1 : length(MATPATHS)
        clearvars -except monkeyName areaSel rootPathMat rootPathFig protocols protocolStr rIndex dateSel protSel MATPATHS mIndex AREAS NAMES aIndex monIndex trialsECOG_pop trialsECOG_pop_Filtered trialsECOG_pop_Lag trialAll_pop popChoice;
        if matches(protocolStr, ["MSTI_BG-15o2_S1-22o8_S2-18o6_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-18o6_S1-15o2_S2-22o8_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-22o8_S1-15o2_S2-18o6_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-15o2_S1-22o8_S2-18o6_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-18o6_S1-15o2_S2-22o8_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-22o8_S1-15o2_S2-18o6_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-3o6_S1-3_S2-4o3_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-17o3_S1-14o4_S2-20o7_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-18o2_S1-15o2_S2-21o9_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-41_S1-34o2_S2-49o2_ISI_400_Dur_200_STDN_9",...
                "MSTI_BG-3o6_S1-3_S2-4o3_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-17o3_S1-14o4_S2-20o7_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-18o2_S1-15o2_S2-21o9_ISI_600_Dur_300_STDN_9",...
                "MSTI_BG-41_S1-34o2_S2-49o2_ISI_600_Dur_300_STDN_9"]);
            run("Y_Figure_Example_MSTI_Basic.m");
            if popChoice == "on" 
            % for population
                trialsECOG_Merge_temp = trialsECOG_Merge;
                trialsECOG_Merge_Filtered_temp = trialsECOG_Merge_Filtered;
                trialsECOG_Merge_Lag_temp = trialsECOG_Merge_Lag;
                trialAll_temp = trialAll;
    
                trialsECOG_pop = [trialsECOG_pop; trialsECOG_Merge_temp];
                trialsECOG_pop_Filtered = [trialsECOG_pop_Filtered; trialsECOG_Merge_Filtered_temp];
                trialsECOG_pop_Lag = [trialsECOG_pop_Lag; trialsECOG_Merge_Lag_temp];
                trialAll_pop = [trialAll_pop; trialAll_temp];
            end
%         elseif matches(protocolStr, ["MSTIomi_G1_3-3o6_G2_14o4-17o3_ISI_400_Dur_200_STDN_11",...
%                 "MSTIomi_S1-3_S2-3o6_ISI_400_Dur_200_STDN_12",...
%                 "MSTIomi_S1-14o4_S2-17o3_ISI_400_Dur_200_STDN_12"])
%             run("Y_Figure_Example_MSTIomi_Basic.m");
        elseif matches(protocolStr, ["MSTImulti_BG3o6_17o3_ISI_600_Dur_300_STDN_9",...
                "MSTImulti_BG3o6_18o2_ISI_600_Dur_300_STDN_9"])
            run("Y_Figure_Example_MSTIImultiBG_Basic.m");
        end

    end

    if popChoice == "on" & length(MATPATHS) > 0 & matches(protocolStr, ...
        ["MSTI_BG-15o2_S1-22o8_S2-18o6_ISI_400_Dur_200_STDN_9","MSTI_BG-18o6_S1-15o2_S2-22o8_ISI_400_Dur_200_STDN_9",...
        "MSTI_BG-22o8_S1-15o2_S2-18o6_ISI_400_Dur_200_STDN_9","MSTI_BG-15o2_S1-22o8_S2-18o6_ISI_600_Dur_300_STDN_9",...
        "MSTI_BG-18o6_S1-15o2_S2-22o8_ISI_600_Dur_300_STDN_9","MSTI_BG-22o8_S1-15o2_S2-18o6_ISI_600_Dur_300_STDN_9",...
        "MSTI_BG-3o6_S1-3_S2-4o3_ISI_400_Dur_200_STDN_9","MSTI_BG-17o3_S1-14o4_S2-20o7_ISI_400_Dur_200_STDN_9",...
        "MSTI_BG-18o2_S1-15o2_S2-21o9_ISI_400_Dur_200_STDN_9","MSTI_BG-41_S1-34o2_S2-49o2_ISI_400_Dur_200_STDN_9",...
        "MSTI_BG-3o6_S1-3_S2-4o3_ISI_600_Dur_300_STDN_9","MSTI_BG-17o3_S1-14o4_S2-20o7_ISI_600_Dur_300_STDN_9",...
        "MSTI_BG-18o2_S1-15o2_S2-21o9_ISI_600_Dur_300_STDN_9","MSTI_BG-41_S1-34o2_S2-49o2_ISI_600_Dur_300_STDN_9"]);
        FIGPATH_pop = strcat(rootPathFig, "Figure_", protStr,"\", monkeyName, "_pop\");
        run("MSTI_Basic_pop.m");
    end
end
