% clear;
% load('../MotionData/ArtHand/pinchSnap.mat');
% load('../MotionData/ArtHand/pinchData.mat');
%% Load Model
% load('pinchArtHandModel.mat');
snapHand = handSnap.clients{3}.frames{1}.hands{1};
sensor1Frames = handMotion.clients{2}.frames;
sensor2Frames = handMotion.clients{3}.frames;
sensor3Frames = handMotion.clients{4}.frames;
count = length(sensor1Frames);

for i=1:count
    %% Calculate each sensors ED error
    proArray = zeros(1,3);
    featureMatrix = zeros(3,11);
    frameArray = [sensor1Frames{i},sensor2Frames{i},sensor3Frames{i}];
    if ~isempty(sensor1Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor1Frames{i}.hands{1}),model,'-b 1');
        proArray(1,1) = pro(1,1);
    else
        proArray(1,1) = realmin;
    end
    if ~isempty(sensor2Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor2Frames{i}.hands{1}),model,'-b 1');
        proArray(1,2) = pro(1,1);
    else
        proArray(1,2) = realmin;
    end
    if ~isempty(sensor3Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor3Frames{i}.hands{1}),model,'-b 1');
        proArray(1,3) = pro(1,1);
    else
        proArray(1,3) = realmin;
    end
    [~,minIndex] = max(proArray);
    fusionMotion.frames{i}.hands = frameArray(minIndex).hands;
end

% Calculate the Error
SnapHand = handSnap.clients{3}.frames{1}.hands{1};
[sensor1,sensor1Fingers] = calculateED(SnapHand,handMotion.clients{2}.frames);
[sensor2,sensor2Fingers] = calculateED(SnapHand,handMotion.clients{3}.frames);
[sensor3,sensor3Fingers] = calculateED(SnapHand,handMotion.clients{4}.frames);
[fuse,fuseFingers] = calculateED(SnapHand,fusionMotion.frames);
