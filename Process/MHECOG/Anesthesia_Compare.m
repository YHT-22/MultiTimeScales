clear;clc;

%% load data
MatPath = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Single_Figure3_DiffICI\R_minus_S_devide_R_plus_S\CC\';
Savepath = 'I:\ANALYSIS_202303_MonkeyECOG_ClickTrain_TimeIntinSynchron\Anesthesia\';
Date_Before = 'cc20230505_2';
Date_After = 'cc20230627';

load([MatPath, Date_Before, '/ACSingleData'], "-mat");
Before_trialsAll = trialAll;
Before_trialsECOG = trialsECOG_Merge;
Before_trialsECOGfilte = ECOGFilter(Before_trialsECOG, 1, 40, 1000);
trialAll = [];trialsECOG_Merge = [];

load([MatPath, Date_After, '/ACSingleData'], "-mat");
After_trialsAll = trialAll;
After_trialsECOG = trialsECOG_Merge;
After_trialsECOGfilte = ECOGFilter(After_trialsECOG, 1, 40, 1000);
trialAll = [];trialsECOG_Merge = [];

%% compare onset & change
window = [-6000 6000];
onset_window = [-4000 -3400];
change_window = [0 600];
fs = 1000;
t = linspace(window(1), window(2), diff(window) / 1000 * fs + 1);
StimStrs = ["Control", "N1", "N2", "N4", "N8"];% order(control) = 1

for dIndex = 1 : 5
    Before_trialsECOG_Temp = [];After_trialsECOG_Temp = [];Compare = [];

    Before_order_Tempidx = find(cell2mat({Before_trialsAll.ordrSeq}') == dIndex);
    After_order_Tempidx = find(cell2mat({After_trialsAll.ordrSeq}')== dIndex);

    %raw wave
    Before_trialsECOG_Temp = Before_trialsECOG(Before_order_Tempidx);
    Before_trialsECOG_mean = cellfun(@mean, changeCellRowNum(Before_trialsECOG_Temp), "UniformOutput", false);
    After_trialsECOG_Temp = Before_trialsECOG(After_order_Tempidx);
    After_trialsECOG_mean = cellfun(@mean, changeCellRowNum(After_trialsECOG_Temp), "UniformOutput", false);
    %filte
    Before_trialsECOGfilte_Temp = Before_trialsECOGfilte(Before_order_Tempidx);
    Before_trialsECOGfilte_mean = cellfun(@mean, changeCellRowNum(Before_trialsECOGfilte_Temp), "UniformOutput", false);
    After_trialsECOGfilte_Temp = Before_trialsECOGfilte(After_order_Tempidx);
    After_trialsECOGfilte_mean = cellfun(@mean, changeCellRowNum(After_trialsECOGfilte_Temp), "UniformOutput", false);
    %raw wave
    Compare(1).chMean = cell2mat(Before_trialsECOG_mean); Compare(1).color = 'k';
    Compare(2).chMean = cell2mat(After_trialsECOG_mean); Compare(2).color = 'r';
    %filte
    Compare(3).chMean = cell2mat(Before_trialsECOGfilte_mean); Compare(3).color = 'k';
    Compare(4).chMean = cell2mat(After_trialsECOGfilte_mean); Compare(4).color = 'r'; 
    CompareTemp{dIndex} = Compare;
    %plot
%     Fig_Onset(dIndex) = plotRawWaveMulti_SPR(Compare(1:2), window, 'Onset', [8, 8]);
%     scaleAxes(Fig_Onset(dIndex), "x", onset_window);
% 
%     Fig_Change(dIndex) = plotRawWaveMulti_SPR(Compare(1:2), window, 'Change', [8, 8]);
%     scaleAxes(Fig_Change(dIndex), "x", change_window);
%     scaleAxes(Fig_Change(dIndex), "y", [-10 10]);
    Fig_Changefilte(dIndex) = plotRawWaveMulti_SPR(Compare(3:4), window, 'Change', [8, 8]);
    scaleAxes(Fig_Changefilte(dIndex), "x", change_window);
    scaleAxes(Fig_Changefilte(dIndex), "y", [-10 10]);

    %save
%     print(Fig_Onset(dIndex), strcat(Savepath, 'Onset_', StimStrs(dIndex)), "-djpeg", "-r200");
%     print(Fig_Change(dIndex), strcat(Savepath, 'Change_', StimStrs(dIndex)), "-djpeg", "-r200");
    print(Fig_Changefilte(dIndex), strcat(Savepath, 'Change(filte)_', StimStrs(dIndex)), "-djpeg", "-r200");    
    close all;
end

