clear all
clc


% read reference image as left adn right image
leftI = imread('Inputs/scene1.row3.col3.ppm');
rightI = imread('Inputs/scene1.row3.col4.ppm');

leftI = imnoise(leftI,'gaussian',0,0.02);
rightI = imnoise(rightI,'gaussian',0,0.02);

% define parameter for block matching and call block matching algorithm
blockSize=11;
maxd=15;
disp1=blockmatching(leftI,rightI,blockSize,maxd);
figure;imagesc(disp1);
title('blockmatching result');

% define parameters and call block matchning with dynamic prog optm.
maxd=15;
blockSize=11;
cost=100;
disp2=blockmatching_DW(leftI,rightI,blockSize,maxd,cost);
figure;imagesc(disp2);
title('blockmatching with Dynamic Prog. Opt. result');

% define parameter and call belief Propogation based Stereo
levels=10;
maxd=15;
iter=10;
disp3=beliefPropStereo(leftI,rightI,maxd,levels,iter);
figure;imagesc(disp3);
title('belief Propogation based Stereo Result');

% read ground truth disparity image
dispG=imread('Inputs/truedisp.row3.col3.pgm');
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




