function outimg=beliefPropStereo(img1,img2,maxdisp,levels,iter)

%% Written by Muhammet Balcilar, France,
%% all rights reserved

if length(size(img1))==3
    % convert it grayscale
    img1 = mean(img1, 3);
    img2 = mean(img2, 3);
end

data{1}=comp_data(img1, img2, maxdisp,15,0.07);

for i=2:levels
    tdat=data{i-1};
    ntdat=zeros(ceil(size(tdat,1)/2),ceil(size(tdat,2)/2),maxdisp);
    [a b c]=size(ntdat);
    if size(tdat,1)<2*a | size(tdat,2) < 2*b
        tdat(2*a,2*b,maxdisp)=0;
    end
    for j=1:maxdisp
        tmp=tdat(:,:,j);
        ntdat(:,:,j)=tmp(1:2:2*a,1:2:2*b)+tmp(2:2:2*a,1:2:2*b)+tmp(1:2:2*a,2:2:2*b)+tmp(2:2:2*a,2:2:2*b);
    end
    data{i}=ntdat;
end

u=zeros(size(data{levels}));
d=zeros(size(data{levels}));
l=zeros(size(data{levels}));
r=zeros(size(data{levels}));
[u,d,l,r]=beliefpropagatio(u, d, l, r, data{levels}, iter);

for i=levels-1:-1:1
    i
    tu=twotimeres(u);
    td=twotimeres(d);
    tl=twotimeres(l);
    tr=twotimeres(r);   
    
    [a b c]=size(data{i});
    u=tu(1:a,1:b,:);
    d=td(1:a,1:b,:);
    l=tl(1:a,1:b,:);
    r=tr(1:a,1:b,:);    
    
    [u,d,l,r]=beliefpropagatio(u, d, l, r, data{i}, iter);
end


[height width c]=size(u);
dat=data{1};
for y=2:height-1
    for x=2:width-1
        val=u(y+1,x,:)+d(y-1,x,:)+l(y,x+1,:)+r(y,x-1)+dat(y,x,:);
        [a b]=min(val);
        outimg(y,x)=b;
    end
end

    
    
    
    
    
    
    
