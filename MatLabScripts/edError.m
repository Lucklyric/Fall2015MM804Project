function [ error ] = edError( snapHand,givenHand )
%EDERROR Summary of this function goes here
%   Detailed explanation goes here
snapHandOrientation =  snapHand.orientation;
sensorHandOrientation =  givenHand.orientation;

sum = 0;
for i=1:5
    snap = (inv(snapHandOrientation)) * (snapHand.fingers{i}.position)';
    sensor = (inv(sensorHandOrientation)) * (givenHand.fingers{i}.position)';
    sum = sum + pdist([snap';sensor'],'euclidean');
    
end
error = sum/5;
end

