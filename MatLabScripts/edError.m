function [ error,fingersError ] = edError( snapHand,givenHand )
%EDERROR Eculidean Distancs fro a given hand by comparing with the ground
%truth
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
snapHandOrientation =  snapHand.orientation;
sensorHandOrientation =  givenHand.orientation;
snapHandPos = snapHand.position;
givenHandPos = givenHand.position;
sum = 0;
fingersError = zeros(1,5);
for i=1:5
    snap = (inv(snapHandOrientation)) * (snapHand.fingers{i}.position-snapHandPos)'; % Project to hand coordinates
    sensor = (inv(sensorHandOrientation)) * (givenHand.fingers{i}.position-givenHandPos)'; % Project to hand coordinates
    dist = pdist([snap';sensor'],'euclidean');
    sum = sum + dist;
    fingersError(i) = fingersError(i) + dist;
end
error = sum/5;
end

