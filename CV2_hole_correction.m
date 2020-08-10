function CV2_hole_correction(srcDir, output_xlsx_path)
%CV2_HOLECORRECTION 此处显示有关此函数的摘要
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
[k,len]=size(allnames); %获得bmp文件的个数
image_name=cell(len,1);

%  输出参数横目
N= 'CV文件名';
Hn='血管网格数';
Vs= '血管面积';
Hs= '血管网格面积';
Es= '椭圆度';
Ps= '周长';
Ck='外接矩形长/宽 ';
Sp='CV总面积/外接矩形面积*100 ';
Mck='外接椭圆长轴/短轴';
Scv2='CV总面积';
Y= {N,Hn,Vs,Hs,Es,Ps,Ck,Sp,Mck,Scv2};
%disp(Y);
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); 
    image_name{ii,1}=name;
    X = CV2_hole_correction_one_image(I);
    %disp(X);
    
    %将提取的特征写入Excel文件
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    %在Excel文件中写入文件名
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));

end

 %在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:J1');


end

function feature = CV2_hole_correction_one_image(I)

%灰度转换
B=rgb2gray(I);
%迭代法阈值分割
T=0.3*(double(min(B(:)))+double(max(B(:))));
d=false;
while~d
     g=B>=T;
     Tn=0.3*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.3;
     T=Tn;
end
level=Tn/255;
%二值转换
BW=im2bw(B,level);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
BW=imerode(BW,sehj0);
BW=imdilate(BW,sehj00);

BW=bwareaopen(BW,500,8);
BWH=imfill( BW , 'holes');

%参数获取
H= BWH -BW;
H2 = bwareaopen(H,20,8);
num=max(max(bwlabel(H2))); %孔洞数目
H2=H2-0;
BW2=BWH-H2;
BW2= BW2-0;
BWH=BWH-0;
S=regionprops(BW2, 'Area'); 
S=cat(1,S. Area); %血管面积
SH=regionprops(H2, 'Area'); 
SH=cat(1,SH. Area); %孔洞面积
E=regionprops(BWH, 'Eccentricity');
E=cat(1,E. Eccentricity); %偏心率
P=regionprops(BWH, 'Perimeter');
P=cat(1, P. Perimeter); %周长
[r c]=find(BWH ==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %外接矩形宽
chang= max(ds(1:2)); %外接矩形长
ck=chang/kuan;
St=regionprops(BWH, 'Area'); 
St=cat(1,St. Area); %CV总面积
Sq=kuan*chang; %外接矩形面积
Spercent= St/ Sq*100; %矩形率
Mc= regionprops(BWH, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %外接椭圆长轴
Mk= regionprops(BWH, 'MinorAxisLength'); 
mk=cat(1,Mk. MinorAxisLength); %外接椭圆短轴
mck= mc/mk;
feature ={num2str(num),num2str(S),num2str(SH),num2str(E), num2str(P),num2str(ck),num2str(Spercent),num2str(mck),num2str(St)};
%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(BWH);
%subplot(2,3,3);imshow(BW2);
%subplot(2,3,4);imshow(H2);
end

