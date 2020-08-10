function CV_end(srcDir, output_xlsx_path)

%CV_end 此处显示有关此函数的摘要
% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取相关特征保存在Excel文件

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
format long g;  
cd(srcDir);
allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得文件的个数
N= '72hpf  末端CV文件名';
Vs= '血管面积';
Es= '椭圆度';
Ps= '周长';
Kuan='外接矩形宽度';
Chang='外接矩形长度';
Ck='外接矩形长/宽 ';
Sp='SIV总面积/外接矩形面积*100 ';
Mk='外接椭圆短轴';
Mc='外接椭圆长轴';
Y= {N,Vs, Es, Ps,Kuan,Chang,Ck,Sp,Mk,Mc};
%disp(Y); %输出指标横目
image_name=cell(len,1);
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); %读取文件
    image_name{ii,1}=name;
    X = CV_end_one_image(I);
    %disp(X);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:J1');
end

function feature = CV_end_one_image(I)

J=rgb2gray(I); %转化为灰度图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
J=im2double(J); %二值转化
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0); %腐蚀
J=imdilate(J,sehj00); %膨胀
J=bwareaopen(J,200,8); %过滤小面积
J=imfill(J,'hole'); %孔洞填充
u=J;
%参数输出
S=regionprops(u, 'Area'); 
S=cat(1,S. Area); %面积

E=regionprops(u, 'Eccentricity');
E=cat(1,E. Eccentricity); %偏心率

P=regionprops(u, 'Perimeter');
P=cat(1, P.Perimeter); %周长
[r c]=find(u==1);

[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %最小外接矩形宽
chang= max(ds(1:2)); %最小外接矩形长
ck=chang/kuan; %外观比
Mc= regionprops(u, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %最小椭圆短轴
Mk= regionprops(u, 'MinorAxisLength'); %最小椭圆长轴
mk=cat(1,Mk. MinorAxisLength);
Sq=kuan*chang;
Spercent= S/ Sq*100; %矩形度
feature = {num2str(S),num2str(E),num2str(P),num2str(kuan),num2str(chang),num2str(ck),num2str(Spercent),num2str(mk),num2str(mc)}; 

%subplot(2,3,1),imshow(I);
%subplot(2,3,3),imshow(u);
end






