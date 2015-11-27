clear;
load('../MotionData/ArtHand/pinchSnap.mat');
load('../MotionData/ArtHand/pinchData.mat');
sensor1Frames = handMotion.clients{2}.frames;
sensor2Frames = handMotion.clients{3}.frames;
sensor3Frames = handMotion.clients{4}.frames;
count = length(sensor1Frames);
for i=1:count
    %% Calculate each sensors ED error
    errorArray = zeros(1,3);
    if ~isempty(sensor1Frames{i}.hands)
        [handsError,~]= edError(snapHand,sensor1Frames{i}.hands{1});
        featureV1 = returnFeatureVector(sensor1Frames{i}.hands{1});
    else
        errorArray(1,1) = realmax;
    end
    if ~isempty(sensor2Frames{i}.hands)
        [handsError,~]= edError(snapHand,sensor2Frames{i}.hands{1});
        featureV2 = returnFeatureVector(sensor2Frames{i}.hands{1});
    else
        errorArray(1,2) = realmax;
    end
    if ~isempty(sensor3Frames{i}.hands)
        [handsError,~]= edError(snapHand,sensor3Frames{i}.hands{1});
        featureV3 = returnFeatureVector(sensor3Frames{i}.hands{1});
    else
        errorArray(1,3) = realmax;
    end
    [~,minIndex] = min(errorArray);
   
    
    
end