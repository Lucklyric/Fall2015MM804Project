clear;tic;
%% PreSetting
snapJsonFileName = 'pinch2SnapA';
motionJsonFileName = 'pinch2DataA';
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
