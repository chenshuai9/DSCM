 clear;
%input for image size(NX,NY) <ɢ��ͼ��С�����أ�>
prompt={'Enter hprozontal(x) resolution for simulated image[pixels]:',...
    'Enter vertical(y) resolution for simulated image{pixels}:'};
dlg_title='Input for image size';
num_lines=1;
def={'128','128'};
answer=inputdlg(prompt,dlg_title,num_lines,def);%������������Ի���
NX=str2double(cell2mat(answer(1,1)));%�����ˮƽ�ֱ��ʵ�ֵ
NY=str2double(cell2mat(answer(2,1)));%�������ֱ�ֱ��ʵ�ֵ
%input for numble of speckles(S)<ɢ������>
prompt={'enter total number of speckles'};
dlg_title='input number of speckles';
num_lines=1;
def={'6500'};
answer=inputdlg(prompt,dlg_title,num_lines,def);%%������������Ի���
S=str2double(cell2mat(answer(1,1)));%�����ɢ������
%input for speckle size(a)<ɢ�ߴ�С>
prompt={'enter speckle size'};
dlg_title='input for speckle size';
num_lines=1;
def={'4'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
a=str2double(cell2mat(answer(1,1)));%�����ɢ�ߴ�С
%input for peak intensity of each speckle(I0)<ɢ�߷�ֵǿ��>
prompt={'enter peak intensity of each speckle'};
dlg_title='input for peak intensity of each speckle';
num_lines=1;
def={'60'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
I0=str2double(cell2mat(answer(1,1)));
%input for displacement(UX,UY)<ɢ��ͼλ��>
prompt={'enter horizontal(x)displacement for simulate image[pixels]:',...
    'enter vertical(y)displacement for simulated image[pixels]:'};
dlg_title='input for sub-pixel diaplacement';
num_lines=1;
def={'0.1','0'};
answer=inputdlg(prompt,dlg_title,num_lines,def);
UX=str2double(cell2mat(answer(1,1)));
UY=str2double(cell2mat(answer(2,1)));
%input for deformation gradient(ux,uy,vx,vy)<λ���ݶȷ���>
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
%main program������
I=zeros(NX,NX);%����һ��512*512��ȫ0����
%rand('state');
X=NY*rand(S,1);%����S*1��0~1���ȷֲ������������
Y=NY*rand(S,1);
%generation of undeformed speckle image��ʼɢ��ͼ������
for i=1:NX
    for j=1:NY
        I(i,j)=I0.*pi./4.*a.^2.*sum((erf((i-X(1:end))./a)-erf((i+1-X(1:end))./a)).*(erf((j-Y(1:end))./a)-erf((j+1-Y(1:end))./a)));
    end
end
A=double(I);%double(I)�ǽ������ͼ��I��uint8����ת��Ϊdouble���͵�����
G=mat2gray(A);%mat2gray��һ�������������������ʵ��ͼ�����Ĺ�һ����������ν����һ��������ʹ�����ÿ��Ԫ�ص�ֵ����0��1֮�䡣
imwrite(G,'0.jpg')%��������ΪG����ΪPIP��tif��ʽͼ��
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
