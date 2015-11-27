% Load .mat data
load('../MotionData/ArtHand/pinchSnap.mat');
load('../MotionData/ArtHand/pinchData.mat');
% Test
snapOrientation = handSnap.clients{3}.frames{1}.hands{1}.orientation;
sensor1Orientation = handMotion.clients{2}.frames{1}.hands{1}.orientation;
sensor2Orientation = handMotion.clients{3}.frames{1}.hands{1}.orientation;
sensor3Orientation = handMotion.clients{4}.frames{1}.hands{1}.orientation;
snapPos = (inv(snapOrientation)) * ((handSnap.clients{3}.frames{1}.hands{1}.fingers{2}.position ...
    -(handSnap.clients{3}.frames{1}.hands{1}.position))');
sensor1Pos = (inv(sensor1Orientation)) * ((handMotion.clients{2}.frames{1}.hands{1}.fingers{2}.position...
    -(handMotion.clients{2}.frames{1}.hands{1}.position))');
sensor2Pos = (inv(sensor2Orientation)) * ((handMotion.clients{3}.frames{1}.hands{1}.fingers{2}.position...
    -(handMotion.clients{3}.frames{1}.hands{1}.position))');
sensor3Pos = (inv(sensor3Orientation)) * ((handMotion.clients{4}.frames{1}.hands{1}.fingers{2}.position...
    -(handMotion.clients{4}.frames{1}.hands{1}.position))');