clear;clc;
rmpath(genpath("I:\Programe\Tool_box"));

AREAS = ["AC", "PFC"];
NAMES = ["chouchou", "xiaoxiao"];
AREASindex = 1;
NAMESindex = 1;

FFTMethod = 3; %1: power(dB); 2: magnitude; 3:amplitude !!!!choose one method in "Y_Figure_Example_MSTI_Basic.m"
popChoice = "off";

areaSel = AREAS(AREASindex);
monkeyName = NAMES(NAMESindex);
run("Y_MSTI_Batch.m");