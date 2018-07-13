function [u,d,l,r]=beliefpropagatio(u, d, l, r, data, iter)
%% Written by Muhammet Balcilar, France,
%% all rights reserved

[height width c]=size(data);
if height > 2 & width> 2
    for t=0:iter-1
        u(2:end-1,2:end-1,:)=msg2(u(3:end,2:end-1,:),l(2:end-1,3:end,:),r(2:end-1,1:end-2,:),data(2:end-1,2:end-1,:));
        d(2:end-1,2:end-1,:)=msg2(d(1:end-2,2:end-1,:),l(2:end-1,3:end,:),r(2:end-1,1:end-2,:),data(2:end-1,2:end-1,:));
        r(2:end-1,2:end-1,:)=msg2(u(3:end,2:end-1,:),d(1:end-2,2:end-1,:),r(2:end-1,1:end-2,:),data(2:end-1,2:end-1,:));
        l(2:end-1,2:end-1,:)=msg2(u(3:end,2:end-1,:),d(1:end-2,2:end-1,:),l(2:end-1,3:end,:),data(2:end-1,2:end-1,:));
        
    end
end
