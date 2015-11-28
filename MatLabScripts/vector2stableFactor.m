function [ stableFactor ] = vector2stableFactor( inputArray,frequency)
%VECTOR2STABLEFACTOR Summary of this function goes here
%   Detailed explanation goes here
    vectorAB = [1/frequency,inputArray(2)-inputArray(1)];
    vectorBC = [1/frequency,inputArray(3)-inputArray(2)];
    stableFactor = dot(vectorAB,vectorBC);
end

