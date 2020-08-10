function ISV(srcDir, output_xlsx_path)
%ISV 此处显示有关此函数的摘要
% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保持所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取相关特征保存在
srcDir = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)';
output_xlsx_path = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)\ISV.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
format long g;%只输出实数
cd(srcDir);

allnames=struct2cell(dir('*.BMP')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name=cell(len,1);

N= 'ISV文件名';
Hn='血管网格数';
Vs= '血管面积';
Hs= '血管网格面积';
Es= '椭圆度';
Ps= '周长';
Ck='外接矩形长/宽 ';
Sp='ISV总面积/外接矩形面积*100 ';
Mck='外接椭圆长轴/短轴';
Sisv='ISV总面积';
Y= {N,Hn, Vs,Hs,Es,Ps,Ck,Sp,Mck, Sisv};
%disp(Y); %输出参数横目
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name);
    image_name{ii,1}=name;
    X = ISV_one_image(I);
    %disp(X);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:J1');
end

function feature = ISV_one_image(I)

 
J=rgb2gray(I); %灰度转换
[width,height,bmsize]=size(J); %阈值分割
for i=1:width
    for j=1:height
        if J(i,j)>0
            J(i,j)=255;
        else
            J(i,j)=0;
        end
    end
end  
J=im2double(J); %而二值转换
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0); %腐蚀
J=imdilate(J,sehj00); %膨胀
J=bwareaopen(J,200,8); %过滤小面积区域
J=imfill(J,'hole');%孔洞填充

B=rgb2gray(I); 
%迭代法阈值分割
T=0.3*(double(min(B(:)))+double(max(B(:))));
d=false;
while~d
     g=B>=T;
     Tn=0.3*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.1;
     T=Tn;
end
level=Tn/255;
%二值转换
BW=im2bw(B,level);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
BW=imerode(BW,sehj0); %腐蚀
BW=imdilate(BW,sehj00); %膨胀
BW=bwareaopen(BW,500,8); %过滤小面积区域
BW=BW-0;
J=J-0;
%参数获取
H=J -BW;
H2 = bwareaopen(H,20,8);
H2=bwareaopen(H2,800,8);
H2=H2-0;
sehj1=strel('disk',1);
sehj11=strel('disk',3);
H3=imerode(H2,sehj1);
H3=imdilate(H3,sehj11);
H3=bwareaopen(H3,800,8);
sehj2=strel('disk',2);
sehj22=strel('disk',3);
H3=imerode(H3,sehj2);
H3=imdilate(H3,sehj22); %孔洞区域
num=max(max(bwlabel(H3))); %孔洞数
S=regionprops(BW, 'Area'); 
S=cat(1,S. Area); %血管面积
SH=regionprops(H2, 'Area'); 
SH=cat(1,SH. Area); %孔洞面积

E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity); %偏心率
P=regionprops(J, 'Perimeter');
P=cat(1, P. Perimeter); %周长
[r c]=find(J ==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %最小外接矩形宽
chang= max(ds(1:2)); %最小外接矩形长
ck=chang/kuan; %外观比
St=regionprops(J, 'Area'); 
St=cat(1,St. Area); %ISV区域面积
Sq=kuan*chang;
Spercent= St/ Sq*100; %矩形度
Mc= regionprops(J, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength);
Mk= regionprops(J, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength);
mck= mc/mk;
feature = {num2str(num), num2str(S),num2str(SH),num2str(E),num2str(P),num2str(ck),num2str(Spercent) ,num2str(mck) ,num2str(St)};


%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(J);
%subplot(2,3,3);imshow(BW);
%subplot(2,3,4);imshow(H3);
end


