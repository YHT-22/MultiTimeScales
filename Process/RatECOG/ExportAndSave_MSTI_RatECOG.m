clear all;clc;
%% load data
disp("Exporting MSTI passive MatData...");
[~, ~, RawMessage] = xlsread('K:\DATA_202307_RatECOG_MSTI\RatECOG_MSTI_DataRecording.xlsx', 'Sheet1', 'A14:E14');
DataROOTPATH = 'K:\DATA_202307_RatECOG_MSTI\Data\Tank\';
SubjName = RawMessage(:,1);
Date = RawMessage(:,2);
Block = RawMessage(:,3);
Export_fs = RawMessage(:,4);
BLOCKPATH = cellfun(@(x,y,z) [DataROOTPATH, x, '\', y, '\', z], SubjName, Date, Block, "UniformOutput", false);
SaveROOTPATH = 'K:\DATA_202307_RatECOG_MSTI\Data\Mat\';
ProtocolStrs = RawMessage(:,5);
SAVEPATH = cellfun(@(x,y,z) [SaveROOTPATH, x, '\', y, '\'], SubjName, ProtocolStrs, "UniformOutput", false);

params.choiceWin = [100,600];
params.processFcn = @PassiveProcess_clickTrainContinuous;

exportDataFcn(BLOCKPATH, SAVEPATH, params, Export_fs, 1);

%%
function exportDataFcn(BLOCKPATH, SAVEPATH, params, fd, startIdx, endIdx)
    narginchk(5, 6);

    if nargin < 5
        startIdx = 1;
    end

    if nargin < 6
        endIdx = length(BLOCKPATH);
    end



    for index = startIdx:endIdx
        AREANAME = ["NaN", "NaN", "AC"];
        temp = string(split(BLOCKPATH{index}, '\'));
        DateStr = temp(end - 1);
        mkdir(fullfile(SAVEPATH{index}));
        fd_temp = fd{index};
        % AC
        disp("Loading AC Data...");
        params.posIndex = 3;%%%%RatECOG电路里面存的名称是Llfp，没有区分不同区域
        tic
        if isfield(params, "patch")
            [trialAll, ECOGDataset] = ECOGPreprocess(BLOCKPATH{index}, params, "patch", params.patch);
        else
            [trialAll, ECOGDataset] = ECOGPreprocess(BLOCKPATH{index}, params);
        end
        ECOGDataset = ECOGResample(ECOGDataset, fd_temp);
        disp("Saving...");
        save(strcat(SAVEPATH{index}, "\", DateStr, "_", AREANAME(params.posIndex), ".mat"), "ECOGDataset", "trialAll", "-mat", "-v7.3");
        toc
        
    end

end