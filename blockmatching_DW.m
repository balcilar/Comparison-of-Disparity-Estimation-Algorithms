function dmap=blockmatching_DW(leftG,rightG,blockSize,maxd,cost)
%% Written by Muhammet Balcilar, France,
%% all rights reserved

if length(size(leftG))==3
    % convert it grayscale
    leftG = mean(leftG, 3);
    rightG = mean(rightG, 3);
end

hb=fix(blockSize/2);

dmap=zeros(size(rightG));
for i=hb+1:size(leftG,1)-hb
    i    
    blockR=rightG(i-hb:i+hb,:);
    blockL=leftG(i-hb:i+hb,:);
    dmap(i,:)=DTW(blockR,blockL,maxd,cost);
end













