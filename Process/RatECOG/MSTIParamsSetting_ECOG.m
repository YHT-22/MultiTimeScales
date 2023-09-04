
ConfigExcelPATH = "K:\Program\RatECOG_MultiTimeScales\MSTIparams.xlsx";
SoundRootPATH = "K:\Program\RatECOG_MultiTimeScales\RatECOGSounds\";
MSTIparamsAll = table2struct(readtable(ConfigExcelPATH));
idx = find(strcmp(ProtocolStr, {MSTIparamsAll.ProtocolType}));

%% update
temp = regexpi(string(ProtocolStr), "_", "split");
DurationInfo = cell2mat(cellfun(@(x) double(string(x)), regexpi(temp(1), "\d*\.?\d*", "match"), 'UniformOutput', false));
BaseICI = cell2mat(cellfun(@(x) double(string(x)), regexpi(temp(2), "\d*\.?\d*", "match"), 'UniformOutput', false));
Devratio = cell2mat(cellfun(@(x) double(string(x)), regexpi(temp(3), "\d*\.?\d*", "match"), 'UniformOutput', false));
ICI2 = roundn(BaseICI * Devratio, -1);

if contains(ProtocolStr, "Change")
    TrialTypeStrs = rowFcn(@(x, y) strcat(x,"-", y, "ms"), string(BaseICI)', string(ICI2)', "UniformOutput", false);
    MSTIparamsAll(idx).TrialTypes = join(cellfun(@(x) strrep(x, ".", "o"), TrialTypeStrs), ",");
    MSTIparamsAll(idx).ClickTrainDur1 = string(DurationInfo(1) * 1000);%ms
    MSTIparamsAll(idx).cursor1 = join(string(1000 ./ BaseICI), ",");
    MSTIparamsAll(idx).cursor2 = join(string((1000 ./ BaseICI) ./ Devratio), ",");

elseif contains(ProtocolStr, "Insert")
    InsertNum = cell2mat(cellfun(@(x) double(string(x)), regexpi(temp(4), "\d*\.?\d*", "match"), 'UniformOutput', false));
    TrialTypeStrs = rowFcn(@(x) strcat(string(BaseICI), "ms_N", x), string(InsertNum)', "UniformOutput", false);
    MSTIparamsAll(idx).TrialTypes = join(cellfun(@(x) strrep(x, ".", "o"), TrialTypeStrs), ",");
    MSTIparamsAll(idx).ClickTrainDur1 = string(DurationInfo(1) * 1000);%ms
    MSTIparamsAll(idx).cursor1 = join(string(repmat(1000 ./ BaseICI, numel(TrialTypeStrs), 1)), ",");
    MSTIparamsAll(idx).cursor2 = join(string(repmat((1000 ./ BaseICI) ./ Devratio, numel(TrialTypeStrs), 1)), ",");

elseif contains(ProtocolStr, "Oscillation")
    TrialTypeStrs = rowFcn(@(x, y) strcat(x,"-", y, "ms"), string(BaseICI)', string(ICI2)', "UniformOutput", false);
    MSTIparamsAll(idx).TrialTypes = join(cellfun(@(x) strrep(x, ".", "o"), TrialTypeStrs), ",");
    MSTIparamsAll(idx).Duration = string(DurationInfo(1) * 1000);
    MSTIparamsAll(idx).SoundLength = string(DurationInfo(2) * 1000);
    MSTIparamsAll(idx).cursor1 = join(string(1000 ./ BaseICI), ",");
    MSTIparamsAll(idx).cursor2 = join(string((1000 ./ BaseICI) ./ Devratio), ",");
    MSTIparamsAll(idx).cursor3 = string(1 / DurationInfo(1));

elseif contains(ProtocolStr, "MSTI")
    Groups = [BaseICI(1), BaseICI(2), BaseICI(3); BaseICI(1), BaseICI(3), BaseICI(2)];
    TrialTypeStrs = rowFcn(@(x) strcat("BG", x(1), "ms-Std", x(2), "ms-Dev", x(3), "ms"), string(Groups));
    for comparenum = 1:numel(TrialTypeStrs)
        MMNcompare(comparenum).sound = regexpi(TrialTypeStrs(comparenum), "Std(.*?)ms", "match");
        MMNcompare(comparenum).StdOrder_Lagidx = find(contains(TrialTypeStrs, MMNcompare(comparenum).sound) == 1);
        MMNcompare(comparenum).DevOrder = find(contains(TrialTypeStrs, strrep(MMNcompare(comparenum).sound, "Std", "Dev")) == 1);
    end
    MSTIparamsAll(idx).TrialTypes = join(cellfun(@(x) strrep(x, ".", "o"), TrialTypeStrs), ",");
    MSTIparamsAll(idx).Duration = string(DurationInfo(1) * 1000);
    MSTIparamsAll(idx).cursor1 = join(string(1000 ./ BaseICI(2:3)), ",");%Std-Si,Std-Sii
    MSTIparamsAll(idx).cursor2 = join(string(1000 ./ [BaseICI(1), BaseICI(1)]), ",");
    MSTIparamsAll(idx).cursor3 = string(1 / DurationInfo(1));

end

writetable(struct2table(MSTIparamsAll), ConfigExcelPATH);

%% get params
MSTIparams.Protocol = string(MSTIparamsAll(idx).ProtocolType);
MSTIparams.TrialTypes = cellfun(@(x) strrep(x, ".", "o"), TrialTypeStrs);
MSTIparams.Colors = regexpi(string(MSTIparamsAll(idx).colors), ",", "split");
MSTIparams.GroupTypes = cellfun(@double, ...
                                rowFcn(@(x) regexpi(x, ",", "split"), ...
                                regexpi(string(MSTIparamsAll(idx).GroupTypes), ";", "split")', "UniformOutput", false),...
                                'UniformOutput', false);
MSTIparams.SoundMatIdx = double(regexpi(string(MSTIparamsAll(idx).SoundMatIdx), ",", "split"));
MSTIparams.SoundMatPath = string(MSTIparamsAll(idx).SoundMatPath);
MSTIparams.trialonset_Win = double(regexpi(string(MSTIparamsAll(idx).trialonset_Window), ",", "split"));
MSTIparams.devonset_Win = double(regexpi(string(MSTIparamsAll(idx).devonset_Window), ",", "split"));
MSTIparams.ICAWindow = double(regexpi(string(MSTIparamsAll(idx).ICAWindow), ",", "split"));
MSTIparams.plotWin = double(regexpi(string(MSTIparamsAll(idx).plotWindow), ",", "split"));
MSTIparams.plotChangeWin = double(regexpi(string(MSTIparamsAll(idx).plotChangeWindow), ",", "split"));
MSTIparams.FFTWin = double(regexpi(string(MSTIparamsAll(idx).FFTWindow), ",", "split"));

MSTIparams.ClickTrainDur1 = double(MSTIparamsAll(idx).ClickTrainDur1);
MSTIparams.Duration = double(MSTIparamsAll(idx).Duration);
MSTIparams.cursor1 = double(regexpi(string(MSTIparamsAll(idx).cursor1), ",", "split"));
MSTIparams.cursor2 = double(regexpi(string(MSTIparamsAll(idx).cursor2), ",", "split"));
MSTIparams.cursor3 = double(regexpi(string(MSTIparamsAll(idx).cursor3), ",", "split"));

if contains(ProtocolStrs, "MSTI")
    load(strcat(SoundRootPATH, MSTIparams.SoundMatPath));
    MSTIparams.MSTIsoundinfo = RegMMNSequence(1, 1:2);
    MSTIparams.MMNcompare = MMNcompare;
elseif contains(ProtocolStrs, "Oscillation")
    MSTIparams.SoundLength = double(MSTIparamsAll(idx).SoundLength);
end

%     switch ProtocolStr
% 
%         case "Change_2s-1s_ICI10.1_15.2_22.8_Control"
%             %sound params
%             MSTIparams.TrialType = ["10o1msControl", "10o1-13o13ms", "15o2msControl", "15o2-19o76ms", "22o8msControl", "22o8-29o64ms"];
%             MSTIparams.colors = {[0 0 0]/255, [255 0 0]/255, [0 0 0]/255, [255 0 0]/255, [0 0 0]/255, [255 0 0]/255, [0 0 0]/255, [255 0 0]/255};
%             MSTIparams.ClickTrainDur1 = 2000;% ms !!!!!!!!!!!!!!!!!
%             MSTIparams.cursor1 = 1000./[10.1, 10.1, 15.2, 15.2, 22.8, 22.8];
%             MSTIparams.cursor2 = [MSTIparams.cursor1(1), MSTIparams.cursor1(2) / 1.3,...
%                                   MSTIparams.cursor1(3), MSTIparams.cursor1(4) / 1.3,...
%                                   MSTIparams.cursor1(5), MSTIparams.cursor1(6) / 1.3];
%             %Window, 0 for change time
%             MSTIparams.devonset_Window = [-MSTIparams.ClickTrainDur1, 1000];
%             MSTIparams.ICAWindow = [-MSTIparams.ClickTrainDur1, 1000];
%             MSTIparams.plotWholeWindow = [-2000, 1000];
%             MSTIparams.plotChangeWindow = [-100, 300];
%             MSTIparams.FFTWindow = [-1000, 1000];            
%             %group
%             MSTIparams.GroupTypes = {[1, 2];[3, 4];[5, 6]};
%            
% 
%     end
