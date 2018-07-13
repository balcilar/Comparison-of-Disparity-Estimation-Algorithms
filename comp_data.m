function data=comp_data(img1, img2, maxdisp,maxdif,lambda)
%% Written by Muhammet Balcilar, France,
%% all rights reserved

h = fspecial('gaussian',5,0.7);

img1=double(imfilter(img1,h));
img2=double(imfilter(img2,h));

data=zeros(size(img1,1),size(img1,2),maxdisp);

for i=1:maxdisp
    dI=abs(img1(:,maxdisp:end)-img2(:,maxdisp+1-i:end+1-i));
    dI(dI>maxdif)=maxdif;
    data(:,maxdisp:end,i)=lambda*dI;
end
    


