function dst=msg2(S1,S2,S3,S4)

%% Written by Muhammet Balcilar, France,
%% all rights reserved


[a b c]=size(S1);

s1=reshape(S1,[a*b,c])';
s2=reshape(S2,[a*b,c])';
s3=reshape(S3,[a*b,c])';
s4=reshape(S4,[a*b,c])';

dst=s1+s2+s3+s4;
minimum=min(dst);

for i=1:size(dst,2)
    for q=2:size(s1,1)
        prev=dst(q-1,i)+1;
        if prev< dst(q,i)
            dst(q,i)=prev;
        end
    end
    
    for q=size(s1,1)-1:-1:1
        prev=dst(q+1,i)+1;
        if prev< dst(q,i)
            dst(q,i)=prev;
        end
    end
    tmp=dst(:,i);
    tmp(tmp<minimum(i))=minimum(i);
    dst(:,i)=tmp;
end


%val=dst-mean(dst);

if size(dst,2)==1
    val=dst-repmat(mean(dst),1,size(dst,2));
else
    val=dst-repmat(mean(dst),size(dst,1),1);

end
    

dst=reshape(val',[a b c]);

