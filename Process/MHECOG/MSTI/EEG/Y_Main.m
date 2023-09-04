%% Export data
clc;clear;close all force;
Y_batchExport('I:\DATA_202305_HumenEEG_MSTI\',{['passive3']},{['20230629']},{['Subj15']});

%% Process individual data
clc;clear;close all force;
rmpath(genpath("I:\Programe\Tool_box"));
MATROOTPATH = 'I:\DATA_202305_HumenEEG_MSTI\MAT DATA';
FIGROOTPATH = 'I:\ANALYSIS_202305_HumenEEG_MSTI\';
Y_batchSingle({['passive3']}, false, {['20230628']}, [], MATROOTPATH, FIGROOTPATH);

%300ms
%['20230518'],['20230519'],['20230523'],['20230524'],['20230526'],['20230608'],['20230626'],['20230628_Subj13']