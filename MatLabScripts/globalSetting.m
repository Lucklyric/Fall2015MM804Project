%% Global Setting
% Configure some key variables
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
snapMatFileNames = {'open2SnapA','pinch2SnapA','grab2SnapA'}; % Training File name list for ground Truth
motionMatFileNames = {'open2DataA','pinch2DataA','grab2DataA'}; % Training File name list for motion data
testSnapMatFileNames = {'pinchSnapA','openSnapA','grabSnapA'}; % Evaluation File name list for ground Truth
testMotionMatFileNames = {'pinchDataA','openDataA','grabDataA'}; % Evaluation File name list for ground Truth
%testSnapMatFileNames = {'open2SnapA','pinch2SnapA','grab2SnapA'};
%testMotionMatFileNames =  {'open2DataA','pinch2DataA','grab2DataA'};
featureVectorPolicy = 'default'; %'default','trend' % default is original version and trend is SSF version
sideLength = 5; %Set the sided length
fusionPolicy = 'default'; %'default','mean','weight' % not implement 

%% Model Part
ifTrainedNewModel = 0; %If trained new model
preTrainedModelName = 'model'; %The name of the preTrained Model
saveFileModelName = 'model'; %The name of the model want to save