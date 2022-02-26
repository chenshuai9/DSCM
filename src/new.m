clc;clear;
[config, success] = requestConfiguration();
config.('gridpoints') = calculateGridpoints(config);            %�����������
[centerRow, centerCol] = getCenterGridpoint(config.gridpoints); %��ȡ���ĵ�
config.imReference.('interpolation') = interpolate(config.imReference.file); %��ֵ
config.imTarget.('interpolation') = interpolate(config.imTarget.file);       %��ֵ

ref = double(imread(config.imReference.file));
tar = double(imread(config.imTarget.file));
%tartemp = imcrop(tar,[gridpoints_y gridpoints_x 20 20]);
%r=normxcorr2(tartemp,ref);

%[u,v] = maxzncc(i,j,config,ref,tar);


%initialGuess = requestInitialGuess(config, 14, 14);
%initialGuess=struct('u',0,'v',0,'u_x',0,'u_y',0,'v_x',0,'v_y',0);
%[initialGuess, c] = optimizeInitialGuess(14, 14, config, initialGuess);�������� initialGuess�ĳ�ʼֵ����ʽΪinitialGuess=struct('u',0.05,'v',0,'u_x',0,'u_y',0,'v_x',0,'v_y',0);
%tic;
%start_initial = toc;
%[result, p, c, iterations, convHist, time_icgn, time_cc] = optimizeICGN(initialGuess, 14, 14, config);
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
        [u,v] = maxzncc(i,j,config,ref,tar);
        initialGuess=struct('u',u,'v',v,'u_x',0,'u_y',0,'v_x',0,'v_y',0);
        [result, p, c, iterations, convHist, time_icgn, time_cc] = optimizeICGN(initialGuess, config.gridpoints.rows(i),config.gridpoints.rows(j), config);
        ans.p.p_u(i,j)=p.u;ans.p.p_v(i,j)=p.v;
        ans.c(i,j)=c;
        ans.iterations(i,j)=iterations;
    end
end
endtime = toc;
finaltime = endtime - starttime;