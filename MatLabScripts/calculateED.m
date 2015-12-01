function [ meanError,meanFingersError ] = calculateED( snapHand,sensorFrames )
%CALCULATEED Calculate the ED error here 
%   Detailed explanation goes here
count = length(sensorFrames);
error = 0;
valid = 0;
fingersError = zeros(1,5);
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

