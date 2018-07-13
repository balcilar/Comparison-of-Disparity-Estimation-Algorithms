function dispImg=blockmatching(leftG,rightG,blockSize,maxd)
%% Written by Muhammet Balcilar, France,
%% all rights reserved

if length(size(leftG))==3
    % convert it grayscale
    leftG = mean(leftG, 3);
    rightG = mean(rightG, 3);
end

hb=fix(blockSize/2);

dispImg=zeros(size(rightG));
for i=hb+1:size(leftG,1)-hb
    i
    for j=hb+1:size(leftG,2)-hb
        
        blockR=rightG(i-hb:i+hb,j-hb:j+hb);
        
        bdiff=[];
        
        for k=0:min(maxd,size(leftG,2)-hb-j)
            blockL=leftG(i-hb:i+hb,j-hb+k:j+hb+k);
            % calculate sum of absolute differences (SAD)
            bdiff(k+1, 1) = sum(abs(blockL(:) - blockR(:)));           
        end
        
        [a1 b1]=min(bdiff);
        
        if size(bdiff,1)>3 & b1>1 & b1<length(bdiff)
            % use minimum disparities left and right block score and find
            % subpixel disparity 
           dispImg(i, j) =  (b1-1) - (0.5 * (bdiff(b1+1,1) - bdiff(b1-1,1)) / (bdiff(b1-1,1) - (2*bdiff(b1,1)) + bdiff(b1+1,1)));          
        else
            % use minimum disparit match directly
           dispImg(i, j) = (b1-1);
        end
    end
end
