%clear;
%load('../MotionData/ArtHand/pinchSnap.mat');
%load('../MotionData/ArtHand/pinchData.mat');
%snapHand = handSnap.clients{3}.frames{1}.hands{1};
sensor1Frames = handMotion.clients{2}.frames;
sensor2Frames = handMotion.clients{3}.frames;
sensor3Frames = handMotion.clients{4}.frames;
count = length(sensor1Frames);
trainingMatrix = zeros(0,12);

for i=1:count
    %% Calculate each sensors ED error
    errorArray = zeros(1,3);
    featureMatrix = zeros(3,11);
    if ~isempty(sensor1Frames{i}.hands)
        [errorArray(1,1),~]= edError(snapHand,sensor1Frames{i}.hands{1});
        featureMatrix(1,:) = returnFeatureVector(sensor1Frames{i}.hands{1});
    else
        errorArray(1,1) = realmax;
    end
    if ~isempty(sensor2Frames{i}.hands)
        [errorArray(1,2),~]= edError(snapHand,sensor2Frames{i}.hands{1});
        featureMatrix(2,:) = returnFeatureVector(sensor2Frames{i}.hands{1});
    else
        errorArray(1,2) = realmax;
    end
    if ~isempty(sensor3Frames{i}.hands)
        [errorArray(1,3),~]= edError(snapHand,sensor3Frames{i}.hands{1});
        featureMatrix(3,:) =  returnFeatureVector(sensor3Frames{i}.hands{1});
    else
        errorArray(1,3) = realmax;
    end
    [~,minIndex] = min(errorArray);
    for j=1:3
        if j == minIndex
            trainingMatrix(end+1,:) = [1,featureMatrix(j,:)];
        elseif j ~= realmax;
            trainingMatrix(end+1,:) = [-1,featureMatrix(j,:)];
        end
    end
end
labelVector = trainingMatrix(:,1);
instMatrix = trainingMatrix(:,2:end);
model = libsvmtrain(labelVector, instMatrix, '-c 1 -g 0.07 -b 1');
