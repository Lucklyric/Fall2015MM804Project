function [ data ] = scaleNormalize( d )
%SCALENORMALIZE normalize the fature if needed
% Author Xinyao(Alvin) Sun
% Version 1.0.1  
data = (d -repmat(min(d,[],1),size(d,1),1))*spdiags(1./(max(d,[],1)-min(d,[],1))',0,size(d,2),size(d,2));

end

