function SIV_hole_correction(srcDir, output_xlsx_path)
%SIV_holecorrection 此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保持所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取相关特征保存在
srcDir = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)';
output_xlsx_path = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)\SIV_hole_correction.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
format long g;%只输出实数
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %处理图片格式
[k,len]=size(allnames); %获得文件的个数
image_name=cell(len,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N= '72hpf SIV文件名';
Hn='孔洞数';
Vs= '血管面积';
Hs= '孔洞面积';
Es= '椭圆度';
Cs= '真圆度';
Ps= '周长';
Kuan='外接矩形宽度';
Chang='外接矩形长度';
Ck='外接矩形长/宽 ';
Sp='SIV总面积/外接矩形面积*100 ';
Mk='外接椭圆短轴';
Mc='外接椭圆长轴';
Ssiv='SIV总面积';
Y= {N, Hn, Vs, Hs,Es, Cs,Ps,Kuan, Chang, Ck,Sp ,Mk,Mc,Ssiv};
%disp(Y);
%%%%%%%%%%%%%%%%%%%%%%%%%以上为输出条目
a0 = Y;
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); %读取文件，获得原始图片图1
    image_name{ii,1}=name;
    X = SIV_holecorrection_one_image(I);
 
    %disp(X);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:N%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目

xlswrite(output_xlsx_path,Y,'A1:N1');

%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(J);
%subplot(2,3,3);imshow(v);
%subplot(2,3,4);imshow(Hz);
%subplot(2,3,5);imshow(vw);
end


function feature = SIV_holecorrection_one_image(I) 
% 以后可能会增加的参数：
% mask：利用图像分割技术获得的粗略的组织区域
% mask_vessel: 利用图像分割技术获得的精细化的血管区域

J=rgb2gray(I); %转化为灰度图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[width,height,bmsize]=size(J);
for i=1:width
    for j=1:height
        if J(i,j)>0
            J(i,j)=255;
        else
            J(i,j)=0;
        end
    end
end
J=im2double(J);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0);
J=imdilate(J,sehj00);
J=bwareaopen(J,200,8);
J=imfill(J,'hole');%以上分割灰度值大于0并转化为二值图片，为SIV区域，获得图2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f=im2double(I);%
T=0.4*(min(f(:))+max(f(:)));
done=false;
while ~done
    g=f>=T;
    Tn=0.4*(mean(f(g))+mean(f(~g)));
    done=abs(T-Tn)<0.1;
    T=Tn;
end
vv=im2bw(f,T);%%%%%%%%%%%%%%%%%%%%%以上为迭代阈值分割
%同一个迭代分割的结果分别用两种处理分别获得图5和图3
vw=bwareaopen(vv,40,8); %①迭代分割后的图形直接过滤面积小于40的区域 获得图5
v=bwareaopen(vv,500,8);
seh0=strel('disk',1);
seh00=strel('disk',2);
v=imerode(v,seh0);
v=imdilate(v,seh00);
vfh=imfill(v,'hole');
hz=vfh-v;
h=bwareaopen(hz,500,8);
v=vfh-h;%②经上面过滤，溶胀，再过滤，填充再过滤过大填充面积之后获得图3，为SIV血管
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hz=J-vw;%孔洞初步区域获得（图2-图5）
seh2=strel('disk',1);
Hz=imerode(Hz,seh2);
%Hz =imdilate(Hz,seh2);
Hz=bwareaopen(Hz,100,8);
seh1=strel('disk',2);
Hz=imerode(Hz,seh1);
Hz=bwareaopen(Hz,50,8);%经连续溶胀两次处理后的到图4，用作孔洞数目计数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=J-0;
v=v-0;
num=max(max(bwlabel(Hz))); %孔洞数目计数
Sj=regionprops(J, 'Area');
Sj=cat(1,Sj. Area); %获取图2（SIV区域）区域面积
Sv=regionprops(v, 'Area');
Sv=cat(1,Sv. Area); %获取血管面积
Sh=Sj-Sv;
if  0> Sh
    Sh=0;
end
%%%%%%以下为SIV区域（图2）E椭圆度、P周长、C真圆度、kuan宽、chang长、c/k宽/长…参数输出
E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity);
P=regionprops(J, 'Perimeter');
P=cat(1, P.Perimeter);
C= (4 * pi *Sj ) / P ^2;
[r c]=find(J==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2));
chang= max(ds(1:2));
ck=chang/kuan;
Mc= regionprops(J, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength);
Mk= regionprops(J, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength);
Sq=kuan*chang;
Spercent= Sj/ Sq*100;
feature = {num2str(num),num2str(Sv),num2str(Sh),num2str(E),num2str(C),num2str(P),num2str(kuan),num2str(chang),num2str(ck),num2str(Spercent),num2str(mk),num2str(mc),num2str(Sj)};
end
