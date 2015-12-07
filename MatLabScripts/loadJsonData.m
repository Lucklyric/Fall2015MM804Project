%% Script for loading the JSON file and save to the .mat
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
clear;tic;
%% PreSetting
snapJsonFileName = 'grab2SnapA';
motionJsonFileName = 'grab2DataA';
%% Start Loding
fprintf('Start loading json file...\n');
startT = toc;
handSnap = loadjson(strcat('../MotionData/JSON/',snapJsonFileName,'.json'));
handMotion = loadjson(strcat('../MotionData/JSON/',motionJsonFileName,'.json'));
finishT = toc;
fprintf('Load finished costs %f seconds\n',(finishT-startT));
%% Save to .mat file
save(strcat('../MotionData/MAT/',snapJsonFileName,'.mat'),'handSnap');
save(strcat('../MotionData/MAT/',motionJsonFileName,'.mat'),'handMotion');
fprintf('Output the .mat file to /Motion/MAT/..');
