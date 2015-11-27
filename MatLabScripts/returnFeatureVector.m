function [ featureVector ] = returnFeatureVector( givenHand )
%RETURNFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here
featureVector = zeros(1,11);
featureVector(1:3) = givenHand.position;
basis = inv(givenHand.orientation);
featureVector(4:6) = -basis(2,:);
featureVector(7:9) = -basis(3,:);
featureVector(10) = dot(-basis(2,:),[0,1,0]);
featureVector(11) = givenHand.confid;
end
