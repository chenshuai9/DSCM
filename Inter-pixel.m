clc;clear;
[config, success] = requestConfiguration();
config.('gridpoints') = calculateGridpoints(config);            %相邻子区间距
[centerRow, centerCol] = getCenterGridpoint(config.gridpoints); %获取中心点

ref = double(imread(config.imReference.file));
tar = double(imread(config.imTarget.file));

gridpoints_x = config.gridpoints.rows(44);   %gridpoints_x = config.gridpoints.rows(i)
gridpoints_y = config.gridpoints.cols(44);   %gridpoints_x = config.gridpoints.rows(j)
tartemp = imcrop(tar,[gridpoints_y-32/2 gridpoints_x-32/2 32 32]);

global r;
r=normxcorr2(tartemp,ref);

[x,y]=find(r==max(max(r)));