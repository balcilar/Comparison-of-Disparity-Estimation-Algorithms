clear all
clc


% read reference image as left adn right image
leftI = imread('scene1.row3.col3.ppm');
rightI = imread('scene1.row3.col4.ppm');
levels=5;
iter=10;

% define parameter and call belief Propogation based Stereo
for iter=1:10
    maxd=15;
    
    disp3=beliefPropStereo(leftI,rightI,maxd,levels,iter);
    figure;imagesc(disp3);
    title(['belief Propogation based Stereo Result for iter=', num2str(iter)] );
    pause(0.5)
end

% read ground truth disparity image
dispG=imread('truedisp.row3.col3.pgm');
figure;imagesc(dispG);
title('Ground Truth Image');



% error calculation
[a b]=size(dispG);
d1=disp1(20:a-20,20-15:b-20-15);
d2=disp2(20:a-20,20-15:b-20-15);
d3=disp3(20:a-20,20:b-20);
dG=double(dispG(20:a-20,20:b-20));

c1=corr(dG(:),d1(:));
c2=corr(dG(:),d2(:));
c3=corr(dG(:),d3(:));

fprintf('Correlation coef for Simple block matching:%f\n',c1);
fprintf('Correlation coef for Dynamic Prog. block matching:%f\n',c2);
fprintf('Correlation coef for belief prop.:%f\n',c3);




