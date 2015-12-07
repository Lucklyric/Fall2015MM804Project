function [ meanError,meanFingersError ] = calculateED( snapHand,sensorFrames )
%CALCULATEED Calculate the ED error with groundtruth and array of frames
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
count = length(sensorFrames);
error = 0;
valid = 0;
fingersError = zeros(1,5);
%% loop for five fingers
for i=1:count
    if ~isempty(sensorFrames{i}.hands)
        SensorHand = sensorFrames{i}.hands{1};
        [handsError,tmpFingersError]= edError(snapHand,SensorHand);
        fingersError = fingersError + tmpFingersError;
        error = error + handsError;
        valid = valid + 1;
    end
end
meanError = error/valid;
meanFingersError = fingersError./valid;
end

