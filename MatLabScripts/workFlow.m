clear;
%% PreLoad the globalSetting
globalSetting;
featureSize = 0;
switch featureVectorPolicy
   case 'default'
      featureSize = 11;
   case 'trend'
      featureSize = 14;
    ...
    otherwise
end
%% Load .mat data

snapFiles{1} = load(strcat('../MotionData/MAT/',snapMatFileName,'.mat'));
motionFiles{1} = load(strcat('../MotionData/MAT/',motionMatFileName,'.mat'));

%% Build Trainning Data
handSnap = snapFiles{1}.handSnap;
handMotion = motionFiles{1}.handMotion;
snapHand = handSnap.clients{3}.frames{1}.hands{1};
sensor1Frames = handMotion.clients{2}.frames;
sensor2Frames = handMotion.clients{3}.frames;
sensor3Frames = handMotion.clients{4}.frames;

sensor1Frames = addStableFactor(sensor1Frames,0,30);
sensor2Frames = addStableFactor(sensor2Frames,0,30);
sensor3Frames = addStableFactor(sensor3Frames,0,30);
trainingMatrix = zeros(0,featureSize+1);
count = length(sensor1Frames);

for i=1:count
    %% Calculate each sensors ED error
    errorArray = zeros(1,3);
    featureMatrix = zeros(3,featureSize);
    if ~isempty(sensor1Frames{i}.hands)
        [errorArray(1,1),~]= edError(snapHand,sensor1Frames{i}.hands{1});
        featureMatrix(1,:) = returnFeatureVector(sensor1Frames{i}.hands{1},featureVectorPolicy);
    else
        errorArray(1,1) = realmax;
    end
    if ~isempty(sensor2Frames{i}.hands)
        [errorArray(1,2),~]= edError(snapHand,sensor2Frames{i}.hands{1});
        featureMatrix(2,:) = returnFeatureVector(sensor2Frames{i}.hands{1},featureVectorPolicy);
    else
        errorArray(1,2) = realmax;
    end
    if ~isempty(sensor3Frames{i}.hands)
        [errorArray(1,3),~]= edError(snapHand,sensor3Frames{i}.hands{1});
        featureMatrix(3,:) =  returnFeatureVector(sensor3Frames{i}.hands{1},featureVectorPolicy);
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

%% Train the Model
model = libsvmtrain(labelVector, instMatrix, '-c 1 -g 0.07 -b 1');

%% Test Trainning Data
for i=1:count
    %% Calculate each sensors prob
    proArray = zeros(1,3);
    featureMatrix = zeros(3,featureSize);
    frameArray = [sensor1Frames{i},sensor2Frames{i},sensor3Frames{i}];
    if ~isempty(sensor1Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor1Frames{i}.hands{1},featureVectorPolicy),model,'-b 1');
        proArray(1,1) = pro(1,1);
    else
        proArray(1,1) = realmin;
    end
    if ~isempty(sensor2Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor2Frames{i}.hands{1},featureVectorPolicy),model,'-b 1');
        proArray(1,2) = pro(1,1);
    else
        proArray(1,2) = realmin;
    end
    if ~isempty(sensor3Frames{i}.hands)
        [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor3Frames{i}.hands{1},featureVectorPolicy),model,'-b 1');
        proArray(1,3) = pro(1,1);
    else
        proArray(1,3) = realmin;
    end
    [~,minIndex] = max(proArray);
    disp(proArray);
    fusionMotion.frames{i}.hands = frameArray(minIndex).hands;
end

% Calculate the Error
SnapHand = handSnap.clients{3}.frames{1}.hands{1};
[sensor1,sensor1Fingers] = calculateED(SnapHand,handMotion.clients{2}.frames);
[sensor2,sensor2Fingers] = calculateED(SnapHand,handMotion.clients{3}.frames);
[sensor3,sensor3Fingers] = calculateED(SnapHand,handMotion.clients{4}.frames);
[fuse,fuseFingers] = calculateED(SnapHand,fusionMotion.frames);
clearvars -except sensor1 sensor2 sensor3 fuse  sensor1Fingers sensor2Fingers sensor3Fingers fuseFingers;