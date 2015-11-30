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
numOftraningFiles = length(snapMatFileNames);
snapFiles = cell(numOftraningFiles);
motionFiles = cell(numOftraningFiles);
trainingMatrix = zeros(0,featureSize+1);
for i=1:numOftraningFiles
    snapFiles{i} = load(strcat('../MotionData/MAT/',snapMatFileNames{i},'.mat'));
    motionFiles{i} = load(strcat('../MotionData/MAT/',motionMatFileNames{i},'.mat'));
    
    %% Build Trainning Data
    handSnap = snapFiles{i}.handSnap;
    handMotion = motionFiles{i}.handMotion;
    snapHand = handSnap.clients{3}.frames{1}.hands{1};
    sensor1Frames = handMotion.clients{2}.frames;
    sensor2Frames = handMotion.clients{3}.frames;
    %sensor3Frames = handMotion.clients{4}.frames;
    
    sensor1Frames = addStableFactor(sensor1Frames,3,30);
    sensor2Frames = addStableFactor(sensor2Frames,3,30);
    %sensor3Frames = addStableFactor(sensor3Frames,3,30);
    
    count = length(sensor1Frames);
    
    for j=1:count
        %% Calculate each sensors ED error
        errorArray = zeros(1,2);
        featureMatrix = zeros(2,featureSize);
        if ~isempty(sensor1Frames{j}.hands)
            [errorArray(1,1),~]= edError(snapHand,sensor1Frames{j}.hands{1});
            featureMatrix(1,:) = returnFeatureVector(sensor1Frames{j}.hands{1},featureVectorPolicy);
        else
            errorArray(1,1) = realmax;
        end
        if ~isempty(sensor2Frames{j}.hands)
            [errorArray(1,2),~]= edError(snapHand,sensor2Frames{j}.hands{1});
            featureMatrix(2,:) = returnFeatureVector(sensor2Frames{j}.hands{1},featureVectorPolicy);
        else
            errorArray(1,2) = realmax;
        end
%         if ~isempty(sensor3Frames{j}.hands)
%             [errorArray(1,3),~]= edError(snapHand,sensor3Frames{j}.hands{1});
%             featureMatrix(3,:) =  returnFeatureVector(sensor3Frames{j}.hands{1},featureVectorPolicy);
%         else
%             errorArray(1,3) = realmax;
%         end
        [~,minIndex] = min(errorArray);
        for k=1:2
            if k == minIndex
                trainingMatrix(end+1,:) = [1,featureMatrix(k,:)];
            elseif k ~= realmax;
                trainingMatrix(end+1,:) = [-1,featureMatrix(k,:)];
            end
        end
    end
end

labelVector = trainingMatrix(:,1);
instMatrix = trainingMatrix(:,2:end);

%% Train the Model
model = libsvmtrain(labelVector, instMatrix, '-c 1 -t 2 -b 1 ');

%% Test Trainning Data With differnt fusion policy
for j=1:length(testMotionMatFileNames)
    snapFiles{j} = load(strcat('../MotionData/MAT/',testSnapMatFileNames{j},'.mat'));
    motionFiles{j} = load(strcat('../MotionData/MAT/',testMotionMatFileNames{j},'.mat'));
    
    %% Build Trainning Data
    handSnap = snapFiles{j}.handSnap;
    handMotion = motionFiles{j}.handMotion;
    snapHand = handSnap.clients{3}.frames{1}.hands{1};
    sensor1Frames = handMotion.clients{2}.frames;
    sensor2Frames = handMotion.clients{3}.frames;
    %sensor3Frames = handMotion.clients{4}.frames;
    
    sensor1Frames = addStableFactor(sensor1Frames,3,30);
    sensor2Frames = addStableFactor(sensor2Frames,3,30);
    %sensor3Frames = addStableFactor(sensor3Frames,3,30);
    
    count = length(sensor1Frames);
    for i=1:count
        %% Calculate each sensors prob
        proArray = zeros(1,2);
        featureMatrix = zeros(2,featureSize);
        frameArray = [sensor1Frames{i},sensor2Frames{i}];
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
%         if ~isempty(sensor3Frames{i}.hands)
%             [~,~,pro] = libsvmpredict(1,returnFeatureVector(sensor3Frames{i}.hands{1},featureVectorPolicy),model,'-b 1');
%             proArray(1,3) = pro(1,1);
%         else
%             proArray(1,3) = realmin;
%         end
        [~,minIndex] = max(proArray);
        disp(proArray);
        fusionMotion.frames{i}.hands = frameArray(minIndex).hands;
    end
    
    % Calculate the Error
    SnapHand = handSnap.clients{3}.frames{1}.hands{1};
    [sensor1(j,1),sensor1Fingers(j,:)] = calculateED(SnapHand,handMotion.clients{2}.frames);
    [sensor2(j,1),sensor2Fingers(j,:)] = calculateED(SnapHand,handMotion.clients{3}.frames);
    %[sensor3(j,1),sensor3Fingers(j,:)] = calculateED(SnapHand,handMotion.clients{4}.frames);
    [fuse(j,1),fuseFingers(j,:)] = calculateED(SnapHand,fusionMotion.frames);
end
%clearvars -except sensor1 sensor2 sensor3 fuse  sensor1Fingers sensor2Fingers sensor3Fingers fuseFingers;