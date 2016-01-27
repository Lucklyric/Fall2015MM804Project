%% Global Setting
% Configure some key variables
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
snapMatFileNames = {'open2SnapA','pinch2SnapA','grab2SnapA'}; % Training File name list for ground Truth
motionMatFileNames = {'open2DataA','pinch2DataA','grab2DataA'}; % Training File name list for motion data
testSnapMatFileNames = {'pinchSnapA','grabSnapA','openSnapA'}; % Evaluation File name list for ground Truth
testMotionMatFileNames = {'pinchDataA','grabDataA','openDataA'}; % Evaluation File name list for ground Truth
%testSnapMatFileNames = {'open2SnapA','pinch2SnapA','grab2SnapA'};
%testMotionMatFileNames =  {'open2DataA','pinch2DataA','grab2DataA'};
featureVectorPolicy = 'trend'; %'default','trend' % default is original version and trend is SSF version
sideLength = 1; %Set the sided length
fusionPolicy = 'default'; %'default','mean','weight' % not implement 

%% Model Part
ifTrainedNewModel = 1; %If trained new model
preTrainedModelName = 'model'; %The name of the preTrained Model
saveFileModelName = 'model_demo'; %The name of the model want to save