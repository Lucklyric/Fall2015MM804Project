function [ frames ] = addStableFactor( oldFrames,sideLength,frequency )
%ADDSTABLEFACTOR According to the sidelenght and framerate 
% Return the new frames with Sided Stabe Fact array
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
count = length(oldFrames);
validCount = 0;

%% Only works on valid frams means the hands list in the frame should not be empty
for i=1:count
    hands = oldFrames{i}.hands;
    if ~isempty(hands)
       validCount = validCount + 1;
       validFrames{validCount} = oldFrames{i};
       validFrames{validCount}.oldIndx = i;
      
    end
end

%% Calculate the 7 SSF 
for i=2:validCount-1;
    basisN = inv(validFrames{i+1}.hands{1}.orientation);
    basisP = inv(validFrames{i-1}.hands{1}.orientation);
    basisC = inv(validFrames{i-1}.hands{1}.orientation);
    directionP = -basisP(3,:);
    directionN = -basisN(3,:);
    directionC = -basisC(3,:);
    vectorA = directionC - directionP;
    preTime = (validFrames{i}.oldIndx - validFrames{i-1}.oldIndx)*1/frequency;
    vectorB = directionN - directionC;
    nextTime = (validFrames{i+1}.oldIndx - validFrames{i}.oldIndx)*1/frequency;
    stableFactors = zeros(1,7);
    for j = 1 : 3
       stableFactors(1,j) = dot(([preTime,vectorA(1,j)])/norm([preTime,vectorA(1,j)]),[nextTime,vectorB(1,j)]/norm([nextTime,vectorB(1,j)])); 
    end
    
    directionP = validFrames{i-1}.hands{1}.position;
    directionN = validFrames{i+1}.hands{1}.position;
    directionC = validFrames{i}.hands{1}.position;
    vectorA = directionC - directionP;
    preTime = (validFrames{i}.oldIndx - validFrames{i-1}.oldIndx)*1/frequency;
    vectorB = directionN - directionC;
    nextTime = (validFrames{i+1}.oldIndx - validFrames{i}.oldIndx)*1/frequency;
    
    for j = 1 : 3
       stableFactors(1,3+j) = dot(([preTime,vectorA(1,j)])/norm([preTime,vectorA(1,j)]),[nextTime,vectorB(1,j)]/norm([nextTime,vectorB(1,j)])); 
    end
    
    vectorA = dot(-basisC(2,:),[0,1,0]) - dot(-basisP(2,:),[0,1,0]);
    preTime = (validFrames{i}.oldIndx - validFrames{i-1}.oldIndx)*1/frequency;
    vectorB = dot(-basisN(2,:),[0,1,0]) - dot(-basisC(2,:),[0,1,0]);
    nextTime = (validFrames{i+1}.oldIndx - validFrames{i}.oldIndx)*1/frequency;
    
    stableFactors(7) = dot(([preTime,vectorA])/norm([preTime,vectorA]),[nextTime,vectorB]/norm([nextTime,vectorB])); 
    oldFrames{validFrames{i}.oldIndx}.hands{1}.stableFactors = stableFactors;
    validFrames{i}.stableFactors = stableFactors;
end

%% According to the index from old frames list save sideStableFactors to original frames list
if sideLength~= 0
    validFrames = validFrames(2:validCount-1);
    validCount = length(validFrames);
    for i=(1+sideLength):(validCount-sideLength)
        sumVectors = zeros(1,7);
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
