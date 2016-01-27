allFuseFingers = zeros(5,19);
for allFlowindex=1:19
    clearvars -except allFlowindex allFuseFingers;
    globalSetting;
    sideLength = allFlowindex;
    fprintf('Start:%d',allFlowindex);
    MainworkFlow;
    fprintf('Finish:%d',allFlowindex);
    allFuseFingers(:,allFlowindex) = fuseFingersmean;
end
clearvars -except allFlowindex allFuseFingers;