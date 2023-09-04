
[tartrial_TB{dIndex}, ~] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.96, 1.04] * correspFreq(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_TBminus{dIndex}, idx_TBminus] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.88, 0.96] * correspFreq(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_TBplus{dIndex}, idx_TBplus] = cellfun(@(x) findWithinWindow(x, ff_whole, [1.04, 1.12] * correspFreq(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);

[tartrial_ICI1{dIndex}, ~] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.9, 1.1] * cursor1(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_ICI1minus{dIndex}, idx_ICI1minus] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.7, 0.9] * cursor1(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_ICI1plus{dIndex}, idx_ICI1plus] = cellfun(@(x) findWithinWindow(x, ff_whole, [1.1, 1.3] * cursor1(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);

[tartrial_ICI2{dIndex}, ~] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.9, 1.1] * cursor2(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_ICI2minus{dIndex}, idx_ICI2minus] = cellfun(@(x) findWithinWindow(x, ff_whole, [0.7, 0.9] * cursor2(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);
[tartrial_ICI2plus{dIndex}, idx_ICI2plus] = cellfun(@(x) findWithinWindow(x, ff_whole, [1.1, 1.3] * cursor2(dIndex)), trialsFFT_whole{dIndex}, "UniformOutput", false);


eachTrial_TB{dIndex} = cellfun(@(x) mean(x,2), tartrial_TB{dIndex}, "UniformOutput", false);
eachTrial_TBminus{dIndex} = cellfun(@(x) mean(x,2), tartrial_TBminus{dIndex}, "UniformOutput", false);
eachTrial_TBplus{dIndex} = cellfun(@(x) mean(x,2), tartrial_TBplus{dIndex}, "UniformOutput", false);  
eachTrial_TBBase{dIndex} = cellfun(@(x,y) mean([x, y], 2), eachTrial_TBminus{dIndex}, eachTrial_TBplus{dIndex}, "UniformOutput", false);

eachTrial_ICI1{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI1{dIndex}, "UniformOutput", false);
eachTrial_ICI1minus{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI1minus{dIndex}, "UniformOutput", false);
eachTrial_ICI1plus{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI1plus{dIndex}, "UniformOutput", false);  
eachTrial_ICI1Base{dIndex} = cellfun(@(x,y) mean([x, y], 2), eachTrial_ICI1minus{dIndex}, eachTrial_ICI1plus{dIndex}, "UniformOutput", false);

eachTrial_ICI2{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI2{dIndex}, "UniformOutput", false);
eachTrial_ICI2minus{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI2minus{dIndex}, "UniformOutput", false);
eachTrial_ICI2plus{dIndex} = cellfun(@(x) mean(x,2), tartrial_ICI2plus{dIndex}, "UniformOutput", false);  
eachTrial_ICI2Base{dIndex} = cellfun(@(x,y) mean([x, y], 2), eachTrial_ICI2minus{dIndex}, eachTrial_ICI2plus{dIndex}, "UniformOutput", false);
