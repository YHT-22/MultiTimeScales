function [normAmp, normAmp_rand, amp, rmsSpon] = Y_waveAmp_Norm(wave, window, testWin, method, sponWin)
% method: 1, rms; 2, area; 3, peak or trough; 4, mean
narginchk(3, 6);
if nargin < 4
    method = 1; % rms
    rmsSpon = 1;
    sponWin = [];
end

if nargin < 5 || isempty(sponWin)
    rmsSpon = 1;
    sponWin = [];
end
t = linspace(window(1), window(2), size(wave, 2));

if ~isempty(sponWin)
    tIndex = t > sponWin(1) & t < sponWin(2);
    temp = wave(:, tIndex);
    rmsSpon = rms(temp, 2);
    areaSpon = sum(abs(temp), 2);
end

tIndex = t > testWin(1) & t < testWin(2);
temp = wave(:, tIndex);
amp = rms(temp, 2);
area = sum(abs(temp), 2);

%random
rand_number = 1000;
amp_random_temp = zeros(size(temp, 1), rand_number);
area_random_temp = zeros(size(temp, 1), rand_number);
randIdx = zeros(size(temp, 2), rand_number);
temp_mean = mean(temp, 2);
for rand_time = 1 : rand_number 
    randIdx(:, rand_time) = randperm(size(temp, 2))';
    temp_random = temp(:, randIdx(rand_time));
    amp_random_temp(:, rand_time) = rms(temp_random, 2);
    area_random_temp(:, rand_time) = sum(abs(temp_random), 2);
end
amp_randomlevel = mean(amp_random_temp, 2);
area_randomlevel = mean(area_random_temp, 2);

switch method
    case 1 % Resp_devided_by_Spon
        normAmp = amp./rmsSpon;
        normAmp_rand = amp_randomlevel./rmsSpon;
    case 2 % R_minus_S_devide_R_plus_S
        normAmp = (amp - rmsSpon) ./ rmsSpon;
        normAmp_rand = (amp_randomlevel - rmsSpon) ./ rmsSpon;        
    case 3
        normAmp = (area - areaSpon) ./ areaSpon;
        normAmp_rand = (area_randomlevel - areaSpon) ./ areaSpon;
end

