clear;
% Load .mat data
load('../MotionData/ArtHand/pinchSnap.mat');
load('../MotionData/ArtHand/pinchData.mat');
% Get Hand orientation of Snap
% Calculate the Error
SnapHand = handSnap.clients{3}.frames{1}.hands{1};
[sensor1,sensor1Fingers] = calculateED(SnapHand,handMotion.clients{2}.frames);
[sensor2,sensor2Fingers] = calculateED(SnapHand,handMotion.clients{3}.frames);
[sensor3,sensor3Fingers] = calculateED(SnapHand,handMotion.clients{4}.frames);
