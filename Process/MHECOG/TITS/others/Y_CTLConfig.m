CTLparams = [];
switch Protocol
        case "TITS_in_Osc"
        %% 1：1-2-3-4-5
        CTLparams.titleStr = "TimeIntinSynchron";
        CTLparams.plotWhole = false;
        CTLparams.controlflag = false;
        CTLparams.flp = 10;
        CTLparams.fhp = 1;
        CTLparams.flp_export = 500;
        CTLparams.fhp_export = 0.1;
        CTLparams.fs = 1200;
        CTLparams.cursor1 = 1000./[3, 14.4, 18.6, 22.8, 34.2];
%         CTLparams.cursor1 = 1000./[15.2, 15.2, 15.2];
        CTLparams.cursor2 = CTLparams.cursor1/1.2;
%         CTLparams.stimStrs = ["3-3o06ms", "15o2-15o504ms", "18o6_18o972ms", "22o8-23o256ms", "34o2-34o884ms"];
        CTLparams.stimStrs = ["3-3o6ms", "14o4-17o28ms", "18o6_22o32ms", "22o8-27o36ms", "34o2-41o04ms"];        
%         CTLparams.stimStrs = ["15o2-15o504ms_dur500", "15o2-15o504ms_dur625", "15o2-15o504ms_dur1000"];
%         CTLparams.stimStrs = ["14o4-14o688ms_dur500", "14o4-14o688ms_dur625", "14o4-14o688ms_dur1000"];        
        CTLparams.S1Duration = zeros(1, 12);

%         CTLparams.correspFreq = 1000./[500, 625, 1000];
        CTLparams.correspFreq = 1000./repmat(200, numel(CTLparams.stimStrs), 1);
        CTLparams.winStart = -2000;
        CTLparams.Window = [CTLparams.winStart 18000];
%         CTLparams.SoundDuration = [300, 300];
%         CTLparams.cursor_sound = {[-unique(CTLparams.S1Duration):CTLparams.SoundDuration(1):CTLparams.Window(2)], ...
%             [-unique(CTLparams.S1Duration):CTLparams.SoundDuration(2):CTLparams.Window(2)]};
        CTLparams.ICAWin = [-1000 18000];
        CTLparams.FFTWin_whole = [500 17500];
        CTLparams.plotWin = {[9000, 11000],[0, 18000]};%raw wave
        CTLparams.plotWin_filter = {[9000, 11000]};
        CTLparams.yScale = [40, 40];
        CTLparams.tTh = 0.1;
        CTLparams.chTh = 0.1;

    case "TITS_in_BasClick"
        CTLparams.plotWhole = false;
        CTLparams.controlflag = true;
        CTLparams.flp = 10;
        CTLparams.fhp = 1;
        CTLparams.flp_export = 550;
        CTLparams.fhp_export = 0.1;
        CTLparams.colors = ["#FF0000", '#D95319', "#FFA500", "#0000FF", '#77AC30', '#A2142F', "#000000", "#000000", "#000000", "#000000", "#000000", "#000000"];
%         CTLparams.stimStrs = ["2_2o4ms", "3_3o6ms", "4o5_5o4ms", "6o8_8o16ms", "10o1_12o12ms", "12o4_14o88ms", "15o2_18o24ms", "18o6_22o32ms", "22o8_27o36ms", "34o2_41o04ms"];
        CTLparams.stimStrs = ["15o2_15o504ms", "15o2_15o2_N1ms", "15o2_15o2_N2ms", "15o2_15o2_N4ms", "15o2_15o2_N8ms"];
%         CTLparams.stimStrs = ["14o4_14o688ms", "14o4_14o4_N1ms", "14o4_14o4_N2ms", "14o4_14o4_N4ms", "14o4_14o4_N8ms"];       
%         CTLparams.stimStrs = ["2_2o04ms", "3_3o06ms", "4o5_4o59ms", "6o8_6o936ms", "10o1_10o302ms", "12o4_12o648ms", "15o2_15o504ms", "18o6_18o972ms", "22o8_23o256ms", "34o2_34o884ms"];
        CTLparams.S1Duration = repmat(4000, length(CTLparams.stimStrs),1);
        CTLparams.cdrPlotIdx = [1, 2, 3, 4, 5];
        CTLparams.cursor1 = 1000./[15.2, 15.2, 15.2, 15.2, 15.2];
%         CTLparams.cursor1 = 1000./[14.4, 14.4, 14.4, 14.4, 14.4];        
%         CTLparams.cursor1 = 1000./[2, 3, 4.5, 6.8, 10.1, 12.4, 15.2, 18.6, 22.8, 34.2];
        CTLparams.cursor2 = [CTLparams.cursor1(1)/1.02 CTLparams.cursor1(2:5)];
        CTLparams.CR_Ref = 2;% Reg8-8.12
        CTLparams.fs = 1000;
        CTLparams.yScale = [25, 35];
        CTLparams.CRIScale = {[0.8, 2; -0.1 0.7], [0.8, 2; -0.1 0.3]};
        %数据截取窗口
        CTLparams.winStart = -6000;
        CTLparams.Window = [CTLparams.winStart 6000];
        %ICA处理窗口
        CTLparams.ICAWin = [-4000 4000];
        %FFT计算窗口
        CTLparams.FFTWin_whole = [-4000 4000];
        %CTLparams.FFTWin_addchoose = [0 1000];
        CTLparams.FFTWin_baseline = [-unique(CTLparams.S1Duration)-1000 -unique(CTLparams.S1Duration)];
        CTLparams.FFTWin_head = [-unique(CTLparams.S1Duration) * 0.75 0];
        CTLparams.FFTWin_tail = [unique(CTLparams.S1Duration) - diff(CTLparams.FFTWin_head) unique(CTLparams.S1Duration)];
        %Raw wave画图窗口
        CTLparams.plotWin = {[0, 1000]};%raw wave      
        CTLparams.plotWin_filter = {[-4500, 4500]};%raw wave
        %CRI(Change response index)计算窗口
        CTLparams.quantWin = [0 300];%反应窗口
        CTLparams.sponWin = [-300 0];%基线窗口

        CTLparams.tTh = 0.1;
        CTLparams.chTh = 0.1;


end
