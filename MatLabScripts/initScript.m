clear;
% Load .mat data
load('../MotionData/RealHand/pinchSnap.mat');
load('../MotionData/RealHand/pinchData.mat');
% Get Hand orientation of Snap
SnapHand = realPinchSnap.clients{3}.frames{1}.hands{1};
% Calculate the Error
SensorHand = realPinchMotion.clients{2}.frames{1}.hands{1};

error = edError(SnapHand,SensorHand);