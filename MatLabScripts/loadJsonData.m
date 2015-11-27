tic;
fprintf('Start loading json file...\n');
startT = toc;
realPinchSnap= loadjson('../MotionData/RealHand/pinchSnap.json');
finishT = toc;
fprintf('Load finished costs %f seconds\n',(finishT-startT));