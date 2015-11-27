function [ error,fingersError ] = edError( snapHand,givenHand )
%EDERROR Summary of this function goes here
%   Detailed explanation goes here
snapHandOrientation =  snapHand.orientation;
sensorHandOrientation =  givenHand.orientation;
snapHandPos = snapHand.position;
givenHandPos = givenHand.position;
sum = 0;
fingersError = zeros(1,5);
for i=1:5
    snap = (inv(snapHandOrientation)) * (snapHand.fingers{i}.position-snapHandPos)';
    sensor = (inv(sensorHandOrientation)) * (givenHand.fingers{i}.position-givenHandPos)';
    dist = pdist([snap';sensor'],'euclidean');
    sum = sum + dist;
    fingersError(i) = fingersError(i) + dist;
end
error = sum/5;
end

