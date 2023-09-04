clear;close;clc;
fid = fopen('I:\Programe\EEGOffset\plot\Neuroscan_chan64_New.loc');
n = 1;
while ~feof(fid)
    tline = fgetl(fid);
    info{n} = regexp(tline, '\s+', 'split');
    n = n + 1;
end
channelName = cellfun(@(x) x(1, 4), info, "UniformOutput", false)';
r = cell2mat(cellfun(@(x) str2double(x(1, 3)), info, "UniformOutput", false)');
deg_temp = cell2mat(cellfun(@(x) str2double(x(1, 2)), info, "UniformOutput", false)');
deg = deg_temp;
for i = 1:numel(deg_temp)
    if deg(i) < 0
        deg(i) = abs(deg_temp(i)) + 90;
    elseif deg(i) >= 0 & deg_temp(i) <= 90
        deg(i) = 90 - deg_temp(i);
    elseif deg(i) > 90
        deg(i) = 360 - (deg_temp(i) - 90);
    end
end
figure;maximizeFig;
polarscatter(deg2rad(deg), r, 180, [0.3010 0.7450 0.9330], 'filled');
set(gca, 'RGrid', 'off', 'ThetaGrid', 'off', 'Visible', 'off');
print(gcf, 'I:\DATA_202305_HumenEEG_MSTI\EEG_topo.jpg', "-djpeg", "-r200");
close;