function CCV(srcDir, output_xlsx_path)
%CCV 此处显示有关此函数的摘要
% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取相关特征保存在Excel文件

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
% allnames=struct2cell(dir('*.PNG')); %处理图片格式
[k,len]=size(allnames);             %获得bmp文件的个数

N= 'CCV文件名';
Vs= '血管面积';
Es= '椭圆度';
Cs= '真圆度';
Ps= '周长';
Kuan='外接矩形宽度';
Chang='外接矩形长度';
Mk='外接椭圆短轴';
Mc='外接椭圆长轴';
Y= {N,Vs,Es,Cs,Ps,Kuan,Chang,Mk,Mc};
%disp(Y); %输出指标条目
image_name=cell(len,1);

for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); %读取文件
    image_name{ii,1}=name;
    X = CCV_one_image(I);
    %disp(X);  
    
    %将提取的特征写入Excel文件
    range=sprintf('B%d:I%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:I1');
   
end

function feature = CCV_one_image(I)

J=rgb2gray(I); %灰度值转化
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
seh0=strel('disk',1);
seh00=strel('disk',1);
J=imerode(J,seh0); %区域腐蚀
J=imdilate(J,seh00); %区域膨胀

J=bwareaopen(J,1000,8); %小面积过滤
J=imfill(J, 'hole'); %孔洞填充
J=im2double(J); %二值转化
u=J;
u=u-0;
S=regionprops(u, 'Area'); 
S=cat(1,S. Area); %输出血管面积
E=regionprops(u, 'Eccentricity');
E=cat(1,E. Eccentricity); %输出偏心率
P=regionprops(u, 'Perimeter');
P=cat(1, P.Perimeter); %输出周长
C= (4 * pi *S ) / P ^2; %输出真圆率
[r c]=find(u==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %输出外接矩形宽
chang= max(ds(1:2)); %输出外接矩形长
ck=chang/kuan; %输出外接矩形长/宽比例
Mc= regionprops(u, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %输出外接椭圆长轴
Mk= regionprops(u, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength); %输出外接椭圆短轴
feature = {num2str(S),num2str(E),num2str(C),num2str(P),num2str(kuan),num2str(chang),num2str(mk),num2str(mc)};
end


