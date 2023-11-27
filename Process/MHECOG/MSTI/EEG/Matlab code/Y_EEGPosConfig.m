function EEGPosDefault = Y_EEGPosConfig(varargin)
narginchk(0, 2)
if nargin == 0
    TriggerType = "LTP";
elseif nargin == 2
    TriggerType = varargin{2};
else
    error("invalid input!");
end

if strcmpi(TriggerType, "LTP")
    EEGPosDefault(1:3) = 4:6;
    EEGPosDefault(4:5) = [13, 15];
    EEGPosDefault(6 : 14) = 19:27;
    EEGPosDefault(15 : 23) = 28:36;
    EEGPosDefault(24 : 32) = 37:45;
    EEGPosDefault(33) = 82;
    EEGPosDefault(34 : 42) = 46:54;
    EEGPosDefault(43) = 90;
    EEGPosDefault(44 : 52) = 55:63;
    EEGPosDefault(53 : 59) = 65:71;
    EEGPosDefault(60) = 85;
    EEGPosDefault(61 : 63) = 76:78;
    EEGPosDefault(64) = 87;
elseif strcmpi(TriggerType, "neuracle")
    EEGPosDefault(1:3) = [5, 3, 7];
    EEGPosDefault(4:7) = [12, 16, 11, 17];
    EEGPosDefault(8:16) = [23, 22, 24, 21, 25, 20, 26, 19, 27];
    EEGPosDefault(17:25) = [32, 31, 33, 30, 34, 29, 35, 28, 36];
    EEGPosDefault(26:34) = [41, 40, 42, 39, 43, 38, 44, 37, 45];
    EEGPosDefault(35:42) = [49, 51, 48, 52, 47, 53, 46, 54];
    EEGPosDefault(43:49) = [59, 57, 61, 56, 62, 55, 63, ];
    EEGPosDefault(50:56) = [68, 66, 70, 65, 71, 64, 72];
    EEGPosDefault(57:59) = [77, 75, 79];
    EEGPosDefault(60:64) = [86, 84, 88, 82, 90];
end


