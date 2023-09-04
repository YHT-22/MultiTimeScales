t_interval = Sound(targetsound_idx).interval;
soundfs = Sound(targetsound_idx).fs;
changeinfo = [];
changenum = 1;
for num = 1:numel(t_interval)-1
    if t_interval(num) ~= t_interval(num+1)
        changeinfo(changenum, 1) = num;
        changeinfo(changenum, 2) = t_interval(num);
        if changenum == 1
            changeinfo(changenum, 3) = num * t_interval(num);
        else
            changeinfo(changenum, 3) = (num - changeinfo(changenum-1, 1)) * t_interval(num);
        end
        changenum = changenum + 1;
    end
end
changeinfo(:, 4) = cumsum(changeinfo(:, 3), 1);
changeinfo(:, 5) = changeinfo(:, 4)/soundfs; 
