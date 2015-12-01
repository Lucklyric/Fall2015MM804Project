function [ featureVector ] = returnFeatureVector( givenHand,type )
%RETURNFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here
if isempty(type)
    type = 'default';
end

if strcmp(type,'default')
    featureVector = zeros(1,11);
    featureVector(1:3) = givenHand.position./100;
    basis = inv(givenHand.orientation);
    featureVector(4:6) = -basis(2,:);
    featureVector(7:9) = -basis(3,:);
    featureVector(10) = dot(-basis(2,:),[0,1,0]);
    featureVector(11) = givenHand.confid;
elseif strcmp(type,'trend')
    %% Trend policy
    featureVector = zeros(1,11);
    featureVector(1:3) = givenHand.position./100;
    basis = inv(givenHand.orientation);
    featureVector(4:6) = -basis(2,:);
    featureVector(7:9) = -basis(3,:);
    featureVector(10) = dot(-basis(2,:),[0,1,0]);
    featureVector(11) = givenHand.confid;
    featureVector(12:18) = givenHand.sideStableFactors;
end

end

