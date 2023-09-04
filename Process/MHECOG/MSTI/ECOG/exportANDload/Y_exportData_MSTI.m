%%

%% CC
clear ; clc
params.processFcn = @PassiveProcess_clickTrainContinuous;
recordPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIRecording_CC.xlsx';
recordInfo = table2struct(readtable(recordPath));
exported = [recordInfo.Exported]';
iIndex = find(isnan(exported));  % export sorted and unprocessed spike data

% export sorted and unprocessed spike data 
for i = iIndex'
    fd = recordInfo(i).fs;
    disp(strcat("processing ", recordInfo(i).paradigm, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
    recordInfo = table2struct(readtable(recordPath));
    SAVEPATH = strcat("I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\chouchou\MSTI\", string(recordInfo(i).paradigm), "\");
    BLOCKPATH{1} = recordInfo(i).tankPath;
    params.patch = recordInfo(i).Patch;

    exportDataFcn(BLOCKPATH, SAVEPATH, params, fd, 1);
    recordInfo(i).Exported = 1;
    writetable(struct2table(recordInfo), recordPath);
end


%% XX
clear ; clc
params.processFcn = @PassiveProcess_clickTrainContinuous;
recordPath = 'I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\MSTIRecording_XX.xlsx';
recordInfo = table2struct(readtable(recordPath));
exported = [recordInfo.Exported]';
iIndex = find(isnan(exported));  % export sorted and unprocessed spike data

% export sorted and unprocessed spike data 
for i = iIndex'
    fd = recordInfo(i).fs;
    disp(strcat("processing ", recordInfo(i).paradigm, "... (", num2str(i), "/", num2str(max(iIndex)), ")"));
    recordInfo = table2struct(readtable(recordPath));
    SAVEPATH = strcat("I:\DATA_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Mat\xiaoxiao\MSTI\", string(recordInfo(i).paradigm), "\");
    BLOCKPATH{1} = recordInfo(i).tankPath;
    params.processFcn = @PassiveProcess_clickTrainContinuous;
    params.patch = recordInfo(i).Patch;
 
    exportDataFcn(BLOCKPATH, SAVEPATH, params, fd, 1);
    recordInfo(i).Exported = 1;
    writetable(struct2table(recordInfo), recordPath);
end
