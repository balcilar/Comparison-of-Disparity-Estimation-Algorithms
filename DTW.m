function c=DTW(blockR,blockL,maxd,cost)


b=size(blockR,1);

hb=fix(b/2);
M=[];


for j=1:size(blockR,2)-b+1-maxd
    for i=j:min(size(blockR,2)-b+1,j+maxd)
        tmp=blockR(:,j:j+b-1)-blockL(:,i:i+b-1);
        M(j,i)=sum(abs(tmp(:)));
    end
end

M(M==0)=inf;

for i=2:size(M,1)
    for j=i:min(size(blockR,2),i+maxd)
        M(i,j)=M(i,j)+min(M(i-1,:)+cost*abs([1:size(M,2)]-j+1));
    end
end

c=zeros(1,size(blockR,2));
for i=size(M,1):-1:1
    [t b]=min(M(i,:));
    c(i)=b-i;
end



    

        



