

count1=0;count2=0;count3=0;startall = 0;n1all = 0;n2all = 0;n3all = 0;maxyy1 = 0;maxyy2 = 0;maxyy3 = 0;
for k=1:1:100
%% III. ������ʼ��

cmax = 0;
c1 = 1.49445;
c2 = 1.49445;
 
maxgen = 500;   % ��������  
sizepop = 10000;   %��Ⱥ��ģ

WS=0.9;
WE=0.4;

Vmax = 1;
Vmin = -1;
popmax = 512;
popmin = 1;
%% IV. ������ʼ���Ӻ��ٶ�
for i = 1:sizepop
   % �������һ����Ⱥ
    pop(i,:) = 511*((rands(1,2)+1)/2)+1;    %��ʼ��Ⱥ
    V(i,:) = rands(1,2);  %��ʼ���ٶ�
    % ������Ӧ��
    fitness(i) = maxcorr(pop(i,:));   %Ⱦɫ�����Ӧ��
    if fitness(i)>=0.65
       break
    end
end

%% V. ���弫ֵ��Ⱥ�弫ֵ
%[bestfitness bestindex] = max(fitness);
bestfitness = fitness(i);
bestindex = i;
zbest = pop(bestindex,:);   %ȫ�����
gbest = pop;    %�������
fitnessgbest = fitness;   %���������Ӧ��ֵ
fitnesszbest = bestfitness;   %ȫ�������Ӧ��ֵ

start = i;
sizepop=i;
startall = startall + start;
V1 = V;pop1 = pop;fitness1 = fitness;fitnesszbest1 = fitnesszbest;fitnessgbest1 = fitnessgbest;
V2 = V;pop2 = pop;fitness2 = fitness;fitnesszbest2 = fitnesszbest;fitnessgbest2 = fitnessgbest;
V3 = V;pop3 = pop;fitness3 = fitness;fitnesszbest3 = fitnesszbest;fitnessgbest3 = fitnessgbest;
%% VI. ����Ѱ��

for i = 1:maxgen 
  
     for j = 1:sizepop
        W1(i) = WS-i/(2*maxgen);
        W2(i) = WS - (WS-WE)*(i/maxgen)^2;
        W3(i) = WE*(WS-WE)^(1/(1+10*i/maxgen));
        % �ٶȸ���
        V1(j,:) = W1(i)*V1(j,:) + c1*rand*(gbest(j,:) - pop1(j,:)) + c2*rand*(zbest - pop1(j,:));
        V1(j,find(V1(j,:)>Vmax)) = Vmax;
        V1(j,find(V1(j,:)<Vmin)) = Vmin;
        
        V2(j,:) = W2(i)*V2(j,:) + c1*rand*(gbest(j,:) - pop2(j,:)) + c2*rand*(zbest - pop2(j,:));
        V2(j,find(V2(j,:)>Vmax)) = Vmax;
        V2(j,find(V2(j,:)<Vmin)) = Vmin;
        
        V3(j,:) = W3(i)*V3(j,:) + c1*rand*(gbest(j,:) - pop3(j,:)) + c2*rand*(zbest - pop3(j,:));
        V3(j,find(V3(j,:)>Vmax)) = Vmax;
        V3(j,find(V3(j,:)<Vmin)) = Vmin;
        % ��Ⱥ����
        pop1(j,:) = pop1(j,:) + V1(j,:);
        pop1(j,find(pop1(j,:)>popmax)) = popmax;
        pop1(j,find(pop1(j,:)<popmin)) = popmin;
        
        pop2(j,:) = pop2(j,:) + V2(j,:);
        pop2(j,find(pop2(j,:)>popmax)) = popmax;
        pop2(j,find(pop2(j,:)<popmin)) = popmin;
        
        pop3(j,:) = pop3(j,:) + V3(j,:);
        pop3(j,find(pop3(j,:)>popmax)) = popmax;
        pop3(j,find(pop3(j,:)<popmin)) = popmin;
        
        % ��Ӧ��ֵ����
        fitness1(j) = maxcorr(pop1(j,:)); 
        fitness2(j) = maxcorr(pop2(j,:)); 
        fitness3(j) = maxcorr(pop3(j,:)); 
    end
     
    for j = 1:sizepop  
        % �������Ÿ���
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
        
        % Ⱥ�����Ÿ���
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

%count�Ǽ������
n1 = min(find(yy1==max(max(yy1))));
count1 = count1 + n1*start ;
n2 = min(find(yy2==max(max(yy2))));
count2 = count2 + n2*start ;
n3 = min(find(yy3==max(max(yy3))));
count3 = count3 + n3*start ;
maxyy1 = maxyy1+max(yy1);maxyy2 = maxyy2+max(yy2);maxyy3 = maxyy3+max(yy3);
n1all = n1+n1all;n2all = n2+n2all;n3all = n3+n3all;%��������
end


%% VII.������
[fitnesszbest1, zbest]
[fitnesszbest2, zbest]
[fitnesszbest3, zbest]
plot3(zbest(1), zbest(2), fitnesszbest1,'bo','linewidth',1.5)

figure
plot(yy)
title('���Ÿ�����Ӧ��','fontsize',12);
xlabel('��������','fontsize',12);ylabel('��Ӧ��','fontsize',12);