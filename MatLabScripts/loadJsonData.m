clear;tic;
fprintf('Start loading json file...\n');
startT = toc;
%realPinchSnap= loadjson('../MotionData/RealHand/pinchSnap.json');
handSnap = loadjson('../MotionData/Arthand/pinchSnap.json');
handMotion = loadjson('../MotionData/Arthand/pinchData.json');
finishT = toc;
fprintf('Load finished costs %f seconds\n',(finishT-startT));