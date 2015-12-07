function [ stableFactor ] = vector2stableFactor( inputArray,frequency)
%VECTOR2STABLEFACTOR This function return the single stable factor 
% inputArray is a variable list with length 3
% frequecy is the framerate
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
    vectorAB = [1/frequency,inputArray(2)-inputArray(1)];
    vectorBC = [1/frequency,inputArray(3)-inputArray(2)];
    stableFactor = dot(vectorAB,vectorBC);
end

