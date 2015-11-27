clear;
tic;
fprintf('Start loading json file...\n');
startT = toc;
rawMotion = loadjson('../MotionData/RealHand/pinchData.json');
finishT = toc;
fprintf('Load finished costs %f seconds\n',(finishT-startT));