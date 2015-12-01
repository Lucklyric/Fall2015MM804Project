%% Global Setting 
numOfDataSets = 1;
snapMatFileNames = {'open2SnapA','pinch2SnapA','grab4SnapA'};
motionMatFileNames = {'open2DataA','pinch2DataA','grab4DataA'};
%testSnapMatFileNames = {'openSnapA','grab3SnapA'};
%testMotionMatFileNames = {'openDataA','grab3DataA'};
testSnapMatFileNames = {'open2SnapA','grab4SnapA'};
testMotionMatFileNames =  {'open2DataA','grab4DataA'};
featureVectorPolicy = 'default'; %'default','trend'
sideLength = 15;
fusionPolicy = 'default'; %'default','mean','weight'