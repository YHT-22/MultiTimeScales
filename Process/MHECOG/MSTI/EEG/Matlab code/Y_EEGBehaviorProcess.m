function trialAll = Y_EEGBehaviorProcess(trialsData, EEGDataset, rules)
    narginchk(2, 3);

    if nargin < 3
        rules = rulesConfig();
    end

    evtAll = EEGDataset.event;
    fs = EEGDataset.fs; % Hz
    protocol = EEGDataset.protocol;
    if istable(rules)
        rules = table2struct(rules);
    end
    rules = rules(string({rules.protocol})' == EEGDataset.protocol);
    rulefields = fieldnames(rules);

    evtAll = evtAll(ismember(string({evtAll.type})', string([rules.code]')));
    evtTrial = evtAll(ismember(string({evtAll.type})', string([rules.code]')));

    % Code correction
%     [idxEEG, idxMATLAB] = trialCorrection([evtAll.type]', num2str([trialsData.code]'));
%     trialsData = trialsData(idxMATLAB);
%     evtTrial = evtTrial(idxEEG);

    codeMATLAB = [trialsData.code]';
    trialOnsetEEG = [evtTrial.latency]';
    trialOnsetMATLAB = fix(([trialsData.onset] - trialsData(1).onset) * fs)' + trialOnsetEEG(1);
    
    for tIndex = 1:length(trialOnsetEEG)
        rIdx = find([rules.code] == codeMATLAB(tIndex));

        trialAll(tIndex, 1).trialNum = tIndex;
        trialAll(tIndex, 1).code = codeMATLAB(tIndex);
        trialAll(tIndex, 1).onset = trialOnsetEEG(tIndex);
        trialAll(tIndex, 1).onsetMAT = trialOnsetMATLAB(tIndex);
        for fieldsIdx = 1 : numel(rulefields)
            trialAll(tIndex, 1).(string(rulefields{fieldsIdx})) = rules(rIdx).(string(rulefields{fieldsIdx}));
        end

    end

%     if contains(protocol, "active") % Active
%         pushTimeAll = [trialAll.onset]' + fix(([trialsData.push] - [trialsData.onset]) * fs)';
%         keys = [trialsData.key]';
%     
%         for tIndex = 1:length(trialAll)
%             
%             if tIndex < length(trialAll)
%                 idx = find(pushTimeAll > trialAll(tIndex).onset & pushTimeAll < trialAll(tIndex + 1).onset, 1);
%             else
%                 idx = find(pushTimeAll > trialAll(tIndex).onset, 1);
%             end
% 
%             key = keys(idx);
%             key(key == 0) = [];
% 
%             if ~isempty(key)
%                 trialAll(tIndex).push = pushTimeAll(idx);
%                 trialAll(tIndex).miss = false;
% 
%                 if key == 37 % diff
%                     trialAll(tIndex).isDiff = true;
%                 elseif key == 39 % same
%                     trialAll(tIndex).isDiff = false;
%                 end
% 
%                 if (key == 37 && ~trialAll(tIndex).isControl) || (key == 39 && trialAll(tIndex).isControl)
%                     trialAll(tIndex).correct = true;
%                 else
%                     trialAll(tIndex).correct = false;
%                 end
% 
%             else
%                 trialAll(tIndex).miss = true;
%                 trialAll(tIndex).correct = false;
%             end
% 
%         end
% 
%     end

    return;
end