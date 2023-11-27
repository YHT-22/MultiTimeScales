%% Export data
clc;clear;close all force;
MSTI_batchExport('G:\DATA_202305_HumenEEG_MSTI\', [], {['20231115'], ['20231117']});

%% Process individual data
clc;clear;close all force;
rmpath(genpath("G:\Programe\Tool_box"));
MATROOTPATH = 'G:\DATA_202305_HumenEEG_MSTI\ProcessData\singleDay';
FIGROOTPATH = 'G:\ANALYSIS_202305_HumenEEG_MSTI\singleDay';
MSTI_batchSingle({}, false, [], {'Subj37', 'Subj38'}, MATROOTPATH, FIGROOTPATH);

%更改 20230810 Subj18, 原序号为Subj21

%% Process population data
clc;clear;close all force;
rmpath(genpath("G:\Programe\Tool_box"));
MATROOTPATH = 'G:\DATA_202305_HumenEEG_MSTI\ProcessData\singleDay';
FIGROOTPATH = 'G:\ANALYSIS_202305_HumenEEG_MSTI\';
MSTI_batchPop({}, false, [], [], MATROOTPATH, FIGROOTPATH, true);