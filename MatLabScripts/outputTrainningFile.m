clear;
snapMatFileNames = {'open2SnapA','pinch2SnapA','grab2SnapA'}; % Training File name list for ground Truth
motionMatFileNames = {'open2DataA','pinch2DataA','grab2DataA'}; % Training File name list for motion data
featureVectorPolicy = 'default'; %'default','trend' % default is original version and trend is SSF version
featureSize = 11;
sideLength = 0;
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
    
    sensor1Frames = addStableFactor(sensor1Frames,sideLength,30);
    sensor2Frames = addStableFactor(sensor2Frames,sideLength,30);
    
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
        
        [~,minIndex] = min(errorArray);
        for k=1:2
            if k == minIndex
                trainingMatrix(end+1,:) = [1,featureMatrix(k,:)];
            elseif k ~= realmax;
                trainingMatrix(end+1,:) = [0,featureMatrix(k,:)];
            end
        end
    end
end
dlmwrite('twosensors.csv',[trainingMatrix(:,2:end),trainingMatrix(:,1)])