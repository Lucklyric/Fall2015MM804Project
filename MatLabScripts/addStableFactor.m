function [ frames ] = addStableFactor( oldFrames,sideLength,frequency )
%ADDSTABLEFACTOR Summary of this function goes here
%   Detailed explanation goes here
count = length(oldFrames);
validCount = 0;
for i=1:count
    hands = oldFrames{i}.hands;
    if ~isempty(hands)
       validCount = validCount + 1;
       validFrames{validCount} = oldFrames{i};
       validFrames{validCount}.oldIndx = i;
      
    end
end

for i=2:validCount-1;
    vectorA = validFrames{i}.hands{1}.position - validFrames{i-1}.hands{1}.position;
    preTime = (validFrames{i}.oldIndx - validFrames{i-1}.oldIndx)*1/frequency;
    vectorB = validFrames{i+1}.hands{1}.position - validFrames{i}.hands{1}.position;
    nextTime = (validFrames{i+1}.oldIndx - validFrames{i}.oldIndx)*1/frequency;
    stableFactors = zeros(1,3);
    for j = 1 : 3
       stableFactors(1,j) = dot(([preTime,vectorA(1,j)])/norm([preTime,vectorA(1,j)]),[nextTime,vectorB(1,j)]/norm([nextTime,vectorB(1,j)])); 
    end
    oldFrames{validFrames{i}.oldIndx}.hands{1}.stableFactors = stableFactors;
    validFrames{i}.stableFactors = stableFactors;
end

if sideLength~= 0
    validFrames = validFrames(2:validCount-1);
    validCount = length(validFrames);
    for i=(1+sideLength):(validCount-sideLength)
        sumVectors = zeros(1,3);
        for j=(i-sideLength):(i-1)
            sumVectors = sumVectors+validFrames{j}.stableFactors;
        end
        for j=(i+1):(i+sideLength);
            sumVectors = sumVectors+validFrames{j}.stableFactors;
        end
        sideStableFactors = validFrames{i}.stableFactors-(sumVectors./(2*sideLength));
        oldFrames{validFrames{i}.oldIndx}.hands{1}.sideStableFactors = sideStableFactors;
    end
end

frames = oldFrames(2+sideLength:end-1-sideLength);
end
