
[tartrial_head{dIndex}, ~] = cellfun(@(x) findWithinWindow(x, ff_head, [0.9, 1.1] * cursor1(dIndex)), trialsFFT_head{dIndex}, "UniformOutput", false);
[tartrial_headminus{dIndex}, idx_headminus] = cellfun(@(x) findWithinWindow(x, ff_head, [0.7, 0.9] * cursor1(dIndex)), trialsFFT_head{dIndex}, "UniformOutput", false);
[tartrial_headplus{dIndex}, idx_headplus] = cellfun(@(x) findWithinWindow(x, ff_head, [1.1, 1.3] * cursor1(dIndex)), trialsFFT_head{dIndex}, "UniformOutput", false);

[tartrial_tail{dIndex}, ~] = cellfun(@(x) findWithinWindow(x, ff_tail, [0.9, 1.1] * cursor2(dIndex)), trialsFFT_tail{dIndex}, "UniformOutput", false);
[tartrial_tailminus{dIndex}, idx_tailminus] = cellfun(@(x) findWithinWindow(x, ff_tail, [0.7, 0.9] * cursor2(dIndex)), trialsFFT_tail{dIndex}, "UniformOutput", false);
[tartrial_tailplus{dIndex}, idx_tailplus] = cellfun(@(x) findWithinWindow(x, ff_tail, [1.1, 1.3] * cursor2(dIndex)), trialsFFT_tail{dIndex}, "UniformOutput", false);

eachTrial_head{dIndex} = cellfun(@(x) mean(x,2), tartrial_head{dIndex}, "UniformOutput", false);
eachTrial_headminus{dIndex} = cellfun(@(x) mean(x,2), tartrial_headminus{dIndex}, "UniformOutput", false);
eachTrial_headplus{dIndex} = cellfun(@(x) mean(x,2), tartrial_headplus{dIndex}, "UniformOutput", false);  
eachTrial_headBase{dIndex} = cellfun(@(x,y) mean([x, y], 2), eachTrial_headminus{dIndex}, eachTrial_headplus{dIndex}, "UniformOutput", false);

eachTrial_tail{dIndex} = cellfun(@(x) mean(x,2), tartrial_tail{dIndex}, "UniformOutput", false);
eachTrial_tailminus{dIndex} = cellfun(@(x) mean(x,2), tartrial_tailminus{dIndex}, "UniformOutput", false);
eachTrial_tailplus{dIndex} = cellfun(@(x) mean(x,2), tartrial_tailplus{dIndex}, "UniformOutput", false);  
eachTrial_tailBase{dIndex} = cellfun(@(x,y) mean([x, y], 2), eachTrial_tailminus{dIndex}, eachTrial_tailplus{dIndex}, "UniformOutput", false);
