 clear;
%input for image size(NX,NY) <散斑图大小（像素）>
prompt={'Enter hprozontal(x) resolution for simulated image[pixels]:',...
    'Enter vertical(y) resolution for simulated image{pixels}:'};
dlg_title='Input for image size';
num_lines=1;
def={'128','128'};
answer=inputdlg(prompt,dlg_title,num_lines,def);%创建并打开输入对话框
NX=str2double(cell2mat(answer(1,1)));%输入的水平分辨率的值
NY=str2double(cell2mat(answer(2,1)));%输入的竖直分辨率的值
%input for numble of speckles(S)<散斑数量>
prompt={'enter total number of speckles'};
dlg_title='input number of speckles';
num_lines=1;
def={'6500'};
answer=inputdlg(prompt,dlg_title,num_lines,def);%%创建并打开输入对话框
S=str2double(cell2mat(answer(1,1)));%输入的散斑数量
%input for speckle size(a)<散斑大小>
prompt={'enter speckle size'};
dlg_title='input for speckle size';
num_lines=1;
def={'4'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
a=str2double(cell2mat(answer(1,1)));%输入的散斑大小
%input for peak intensity of each speckle(I0)<散斑峰值强度>
prompt={'enter peak intensity of each speckle'};
dlg_title='input for peak intensity of each speckle';
num_lines=1;
def={'60'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
I0=str2double(cell2mat(answer(1,1)));
%input for displacement(UX,UY)<散斑图位移>
prompt={'enter horizontal(x)displacement for simulate image[pixels]:',...
    'enter vertical(y)displacement for simulated image[pixels]:'};
dlg_title='input for sub-pixel diaplacement';
num_lines=1;
def={'0.1','0'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
UX=str2double(cell2mat(answer(1,1)));
UY=str2double(cell2mat(answer(2,1)));
%input for deformation gradient(ux,uy,vx,vy)<位移梯度分量>
prompt={'enter deformation gradient(ux) for simulated image[pixels]:',...
    'enter deformation gradient(uy) for simulated image[pixels]:',...
    'enter deformation gradient(vx) for simulated image[pixels]:',...
    'enter deformation gradient(vy) for simulated image[pixels]:'};
dlg_title='input for sub-pixel displacement';
num_lines=1;
def={'0','0','0','0'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
ux=str2double(cell2mat(answer(1,1)));
uy=str2double(cell2mat(answer(2,1)));
vx=str2double(cell2mat(answer(3,1)));
vy=str2double(cell2mat(answer(4,1)));
%main program主程序
I=zeros(NX,NX);%创建一个512*512的全0矩阵
%rand('state');
X=NY*rand(S,1);%产生S*1阶0~1均匀分布的随机数矩阵
Y=NY*rand(S,1);
%generation of undeformed speckle image初始散斑图的生成
for i=1:NX
    for j=1:NY
        I(i,j)=I0.*pi./4.*a.^2.*sum((erf((i-X(1:end))./a)-erf((i+1-X(1:end))./a)).*(erf((j-Y(1:end))./a)-erf((j+1-Y(1:end))./a)));
    end
end
A=double(I);%double(I)是将读入的图像I的uint8数据转换为double类型的数据
G=mat2gray(A);%mat2gray是一个计算机函数，功能是实现图像矩阵的归一化操作。所谓”归一化”就是使矩阵的每个元素的值都在0和1之间。
imwrite(G,'0.jpg')%生成数据为G名称为PIP的tif格式图像
M=[1-ux -uy;-vx 1-vy];
J=det(M);
%generation of speckles image after deformation
for k=1:1:100
    for i=1:NX
        for j=1:NY
        I(i,j)=I0.*pi./4.*a.^2.*sum((erf((i-i*ux-j*uy-UX*k-X(1:end))./a)-erf((i+1-(i+1)*ux-(j+1)*uy-UX*k-X(1:end))./a)).*(erf((j-j*vy-i*vx-UY-Y(1:end))./a)-erf((j+1-(j+1)*vy-(i+1)*vx-UY-Y(1:end))./a)));
        end
    end
    A=double(I);
    G=mat2gray(A);
    filename=[num2str(k),'.jpg'];
    imwrite(G,filename,'jpg')
end
