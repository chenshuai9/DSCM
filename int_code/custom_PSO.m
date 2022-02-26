

count1=0;count2=0;count3=0;startall = 0;n1all = 0;n2all = 0;n3all = 0;maxyy1 = 0;maxyy2 = 0;maxyy3 = 0;
for k=1:1:100
%% III. 参数初始化

cmax = 0;
c1 = 1.49445;
c2 = 1.49445;
 
maxgen = 500;   % 进化次数  
sizepop = 10000;   %种群规模

WS=0.9;
WE=0.4;

Vmax = 1;
Vmin = -1;
popmax = 512;
popmin = 1;
%% IV. 产生初始粒子和速度
for i = 1:sizepop
   % 随机产生一个种群
    pop(i,:) = 511*((rands(1,2)+1)/2)+1;    %初始种群
    V(i,:) = rands(1,2);  %初始化速度
    % 计算适应度
    fitness(i) = maxcorr(pop(i,:));   %染色体的适应度
    if fitness(i)>=0.65
       break
    end
end

%% V. 个体极值和群体极值
%[bestfitness bestindex] = max(fitness);
bestfitness = fitness(i);
bestindex = i;
zbest = pop(bestindex,:);   %全局最佳
gbest = pop;    %个体最佳
fitnessgbest = fitness;   %个体最佳适应度值
fitnesszbest = bestfitness;   %全局最佳适应度值

start = i;
sizepop=i;
startall = startall + start;
V1 = V;pop1 = pop;fitness1 = fitness;fitnesszbest1 = fitnesszbest;fitnessgbest1 = fitnessgbest;
V2 = V;pop2 = pop;fitness2 = fitness;fitnesszbest2 = fitnesszbest;fitnessgbest2 = fitnessgbest;
V3 = V;pop3 = pop;fitness3 = fitness;fitnesszbest3 = fitnesszbest;fitnessgbest3 = fitnessgbest;
%% VI. 迭代寻优

for i = 1:maxgen 
  
     for j = 1:sizepop
        W1(i) = WS-i/(2*maxgen);
        W2(i) = WS - (WS-WE)*(i/maxgen)^2;
        W3(i) = WE*(WS-WE)^(1/(1+10*i/maxgen));
        % 速度更新
        V1(j,:) = W1(i)*V1(j,:) + c1*rand*(gbest(j,:) - pop1(j,:)) + c2*rand*(zbest - pop1(j,:));
        V1(j,find(V1(j,:)>Vmax)) = Vmax;
        V1(j,find(V1(j,:)<Vmin)) = Vmin;
        
        V2(j,:) = W2(i)*V2(j,:) + c1*rand*(gbest(j,:) - pop2(j,:)) + c2*rand*(zbest - pop2(j,:));
        V2(j,find(V2(j,:)>Vmax)) = Vmax;
        V2(j,find(V2(j,:)<Vmin)) = Vmin;
        
        V3(j,:) = W3(i)*V3(j,:) + c1*rand*(gbest(j,:) - pop3(j,:)) + c2*rand*(zbest - pop3(j,:));
        V3(j,find(V3(j,:)>Vmax)) = Vmax;
        V3(j,find(V3(j,:)<Vmin)) = Vmin;
        % 种群更新
        pop1(j,:) = pop1(j,:) + V1(j,:);
        pop1(j,find(pop1(j,:)>popmax)) = popmax;
        pop1(j,find(pop1(j,:)<popmin)) = popmin;
        
        pop2(j,:) = pop2(j,:) + V2(j,:);
        pop2(j,find(pop2(j,:)>popmax)) = popmax;
        pop2(j,find(pop2(j,:)<popmin)) = popmin;
        
        pop3(j,:) = pop3(j,:) + V3(j,:);
        pop3(j,find(pop3(j,:)>popmax)) = popmax;
        pop3(j,find(pop3(j,:)<popmin)) = popmin;
        
        % 适应度值更新
        fitness1(j) = maxcorr(pop1(j,:)); 
        fitness2(j) = maxcorr(pop2(j,:)); 
        fitness3(j) = maxcorr(pop3(j,:)); 
    end
     
    for j = 1:sizepop  
        % 个体最优更新
        if fitness1(j) > fitnessgbest1(j)
            gbest(j,:) = pop1(j,:);
            fitnessgbest1(j) = fitness1(j);
        end
        if fitness2(j) > fitnessgbest2(j)
            gbest(j,:) = pop2(j,:);
            fitnessgbest2(j) = fitness2(j);
        end
        if fitness3(j) > fitnessgbest3(j)
            gbest(j,:) = pop3(j,:);
            fitnessgbest3(j) = fitness3(j);
        end
        
        % 群体最优更新
        if fitness1(j) > fitnesszbest1
            zbest = pop1(j,:);
            fitnesszbest1 = fitness1(j);
        end
        if fitness2(j) > fitnesszbest2
            zbest = pop2(j,:);
            fitnesszbest2 = fitness2(j);
        end
        if fitness3(j) > fitnesszbest3
            zbest = pop3(j,:);
            fitnesszbest3 = fitness3(j);
        end
    end 
    yy1(i) = fitnesszbest1;
    yy2(i) = fitnesszbest2;
    yy3(i) = fitnesszbest3;
end

%count是计算次数
n1 = min(find(yy1==max(max(yy1))));
count1 = count1 + n1*start ;
n2 = min(find(yy2==max(max(yy2))));
count2 = count2 + n2*start ;
n3 = min(find(yy3==max(max(yy3))));
count3 = count3 + n3*start ;
maxyy1 = maxyy1+max(yy1);maxyy2 = maxyy2+max(yy2);maxyy3 = maxyy3+max(yy3);
n1all = n1+n1all;n2all = n2+n2all;n3all = n3+n3all;%迭代次数
end


%% VII.输出结果
[fitnesszbest1, zbest]
[fitnesszbest2, zbest]
[fitnesszbest3, zbest]
plot3(zbest(1), zbest(2), fitnesszbest1,'bo','linewidth',1.5)

figure
plot(yy)
title('最优个体适应度','fontsize',12);
xlabel('进化代数','fontsize',12);ylabel('适应度','fontsize',12);