% Load .mat data
clear;
load('../MotionData/ArtHand/pinchSnap.mat');
load('../MotionData/ArtHand/pinchData.mat');
% Test
% snapOrientation = handSnap.clients{3}.frames{1}.hands{1}.orientation;
% sensor1Orientation = handMotion.clients{2}.frames{1}.hands{1}.orientation;
% sensor2Orientation = handMotion.clients{3}.frames{1}.hands{1}.orientation;
% sensor3Orientation = handMotion.clients{4}.frames{1}.hands{1}.orientation;
% snapPos = (inv(snapOrientation)) * ((handSnap.clients{3}.frames{1}.hands{1}.fingers{2}.position ...
%     -(handSnap.clients{3}.frames{1}.hands{1}.position))');
% sensor1Pos = (inv(sensor1Orientation)) * ((handMotion.clients{2}.frames{1}.hands{1}.fingers{2}.position...
%     -(handMotion.clients{2}.frames{1}.hands{1}.position))');
% sensor2Pos = (inv(sensor2Orientation)) * ((handMotion.clients{3}.frames{1}.hands{1}.fingers{2}.position...
%     -(handMotion.clients{3}.frames{1}.hands{1}.position))');
% sensor3Pos = (inv(sensor3Orientation)) * ((handMotion.clients{4}.frames{1}.hands{1}.fingers{2}.position...
%     -(handMotion.clients{4}.frames{1}.hands{1}.position))');
count = length(handMotion.clients{2}.frames);
sensor1Matrix = zeros(0,11);
sensor1Frames = handMotion.clients{2}.frames;
for i = 1:count
    if ~isempty(sensor1Frames{i}.hands)
        sensor1Matrix(i,:) = returnFeatureVector(sensor1Frames{i}.hands{1},'default');
    end
end