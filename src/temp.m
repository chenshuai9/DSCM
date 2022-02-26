clc;clear;
[config, success] = requestConfiguration();
config.('gridpoints') = calculateGridpoints(config);            %相邻子区间距
[centerRow, centerCol] = getCenterGridpoint(config.gridpoints); %获取中心点
config.imReference.('interpolation') = interpolate(config.imReference.file); %插值
config.imTarget.('interpolation') = interpolate(config.imTarget.file);       %插值


pu=ones(45,45);pv=ones(45,45);c=ones(45,45);it=ones(45,45);
pans=struct('p_u',pu,...
            'p_v',pv);
ans=struct('p',pans,...
            'c',c,...
            'iterations',it);
        
tic;
starttime = toc;
for i=16:1:length(config.gridpoints.rows)-14
    for j=16:1:length(config.gridpoints.cols)-14
        u=0;v=0;
        initialGuess=struct('u',u,'v',v,'u_x',0,'u_y',0,'v_x',0,'v_y',0);
        [result, p, c, iterations, convHist, time_icgn, time_cc] = optimizeICGN(initialGuess, config.gridpoints.rows(i),config.gridpoints.rows(j), config);
        ans.p.p_u(i,j)=p.u;ans.p.p_v(i,j)=p.v;
        ans.c(i,j)=c;
        ans.iterations(i,j)=iterations;
    end
end
endtime = toc;
finaltime = endtime - starttime;