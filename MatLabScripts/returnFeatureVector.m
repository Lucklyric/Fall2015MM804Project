function [ featureVector ] = returnFeatureVector( givenHand,type )
%RETURNFEATUREVECTOR Return the feature vector for the given hand with
%diffent type of strategy
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
if isempty(type)
    type = 'default';
end

if strcmp(type,'default')
    featureVector = zeros(1,11);
    featureVector(1:3) = givenHand.position;
    basis = inv(givenHand.orientation);
    featureVector(4:6) = -basis(2,:);
    featureVector(7:9) = -basis(3,:);
    featureVector(10) = dot(-basis(2,:),[0,1,0]);
    featureVector(11) = givenHand.confid;
elseif strcmp(type,'trend')
    %% Trend policy
    featureVector = zeros(1,11);
    featureVector(1:3) = givenHand.position;
    basis = inv(givenHand.orientation);
    featureVector(4:6) = -basis(2,:);
    featureVector(7:9) = -basis(3,:);
    featureVector(10) = dot(-basis(2,:),[0,1,0]);
    featureVector(11) = givenHand.confid;
    featureVector(12:18) = givenHand.sideStableFactors;
end

end

