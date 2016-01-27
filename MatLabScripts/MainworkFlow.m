%% The Main work flow script
% Author Xinyao(Alvin) Sun
% Version 1.0.1
%clear all;
%% PreLoad the globalSetting
%globalSetting;
%% End preLoad
featureSize = 0;
switch featureVectorPolicy
    case 'default'
        featureSize = 11;
        sideLength = 0;
    case 'trend'
        featureSize = 18;
        ...
    otherwise
end
%% Check if need train new model
if ifTrainedNewModel
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
                    trainingMatrix(end+1,:) = [-1,featureMatrix(k,:)];
                end
            end
        end
    end
    
    labelVector = trainingMatrix(:,1);
    instMatrix = trainingMatrix(:,2:end);
    %instMatrix = scaleNormalize(instMatrix);
    
    %% Train the Model
    model = libsvmtrain(labelVector, instMatrix, '-s 0 -c 1000 -t 2  -b 1 ');
    if strcmp(featureVectorPolicy,'trend')
        save(strcat('../TrainedModel/',saveFileModelName,'_',featureVectorPolicy,'_',int2str(sideLength),'.mat'),'model');
    else
        save(strcat('../TrainedModel/',saveFileModelName,'_',featureVectorPolicy,'.mat'),'model');
    end
else
    %% Load pretrained model
    if strcmp(featureVectorPolicy,'trend')
         load(strcat('../TrainedModel/',preTrainedModelName,'_',featureVectorPolicy,'_',int2str(sideLength),'.mat'));
    else
        load(strcat('../TrainedModel/',preTrainedModelName,'_',featureVectorPolicy,'.mat'));
    end
end
clear snapFiles motionFiles;
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
    
    sensor1Frames = addStableFactor(sensor1Frames,sideLength,30);
    sensor2Frames = addStableFactor(sensor2Frames,sideLength,30);
    
    count = length(sensor1Frames);
    for i=1:count
        %% Calculate each sensors prob
        proArray = zeros(1,2);
        featureMatrix = zeros(2,featureSize);
        frameArray = [sensor1Frames{i},sensor2Frames{i}];
        %% Worst Case and Best Case calculate
        errorArray = zeros(1,2);
        if ~isempty(sensor1Frames{i}.hands)
            [errorArray(1,1),~]= edError(snapHand,sensor1Frames{i}.hands{1});
        else
            errorArray(1,1) = realmax;
        end
        if ~isempty(sensor2Frames{i}.hands)
            [errorArray(1,2),~]= edError(snapHand,sensor2Frames{i}.hands{1});
        else
            errorArray(1,2) = realmax;
        end
        
        [~,minIndex] = min(errorArray);
        if minIndex == 1
            bestCaseMotion.frames{i}.hands = sensor1Frames{i}.hands;
            
            worstCaseMotion.frames{i}.hands = sensor2Frames{i}.hands;
            
        else
            bestCaseMotion.frames{i}.hands = sensor2Frames{i}.hands;
            
            worstCaseMotion.frames{i}.hands = sensor1Frames{i}.hands;
            
        end
        
        
        
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
       
        [~,minIndex] = max(proArray);
        disp(proArray);
        fusionMotion.frames{i}.hands = frameArray(minIndex).hands;
    end
    % Calculate the Error
    SnapHand = handSnap.clients{3}.frames{1}.hands{1};
    [sensor1(j,1),sensor1Fingers(j,:)] = calculateED(SnapHand,handMotion.clients{2}.frames(1:end-24));
    [sensor2(j,1),sensor2Fingers(j,:)] = calculateED(SnapHand,handMotion.clients{3}.frames(1:end-24));
    [fuse(j,1),fuseFingers(j,:)] = calculateED(SnapHand,fusionMotion.frames);
    [bestCase(j,1),bestFingers(j,:)] = calculateED(SnapHand,bestCaseMotion.frames);
    [worstCase(j,1),worstFingers(j,:)] = calculateED(SnapHand,worstCaseMotion.frames);
    clear fusionMotion worstCaseMotion bestCaseMotion;
end
%% Present the results
sensor1mean = mean(sensor1);
sensor2mean = mean(sensor2);
fusemean = mean(fuse);
worstCasemean = mean(worstCase);
bestCasemean = mean(bestCase);
sensor1Fingersmean = mean(sensor1Fingers)';
sensor2Fingersmean = mean(sensor2Fingers)';
fuseFingersmean = mean(fuseFingers)';
worstFingersmean = mean(worstFingers)';
bestFingersmean = mean(bestFingers)';
%clearvars -except sensor1 sensor2  fuse  sensor1Fingers sensor2Fingers  fuseFingers sensor1mean sensor2mean fusemean sensor1Fingersmean sensor2Fingersmean fuseFingersmean;
% clearvars -except  featureVectorPolicy sensor1mean sensor2mean fusemean sensor1Fingersmean...
%     sensor2Fingersmean fuseFingersmean worstCasemean bestCasemean worstFingersmean bestFingersmean;
% showResult = [bestCasemean,fusemean,sensor1mean,sensor2mean,worstCasemean];
% str = {'Bestcase'; strcat('Fuse-',featureVectorPolicy); 'Sensor1';'Sensor2';'Worstcase'};
% graph = (1-(showResult-bestCasemean)/(worstCasemean-bestCasemean));
% figure(),
% bar(graph),set(gca,'XTickLabel',str);
% title('Overall Performacne')
% for i1=1:numel(graph)
%     text(i1,graph(i1),num2str(100*graph(i1),'%0.2f%%'),...
%                'HorizontalAlignment','center',...
%                'VerticalAlignment','bottom')
% end