function tu=twotimeres(u)
[a b c]=size(u);
tu=zeros(2*a,2*b,c);
tu(1:2:2*a,1:2:2*b,:)=u;
tu(1:2:2*a,2:2:2*b,:)=u;
tu(2:2:2*a,1:2:2*b,:)=u;
tu(2:2:2*a,2:2:2*b,:)=u;