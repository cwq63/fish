function Color_entropy(srcDir, output_xlsx_path)
%COLOR_ENTROPY 此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取图片的颜色熵并保存在Excel文件

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);
N = '文件名';
H_x='颜色熵';
Y= {N,H_x};
allnames = struct2cell(dir('*.bmp'));%只处理8位的bmp文件
[k,len] = size(allnames); %获得bmp文件的个数
image_name = cell(len,1);
for ii = 1:len%逐次取出文件
    name = allnames{1,ii};
    I = imread(name); %读取文件
    image_name{ii,1} = name;
    X = Color_entropy_one_image(I);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:B%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:B1');
end



function feature = Color_entropy_one_image(I)

[C,L]=size(I); %求图像的规格
Img_size=C*L; %图像像素点的总个数
G=256; %图像的灰度级
H_x=0;
nk=zeros(G,1);%产生一个G行1列的全零矩阵
for i=1:C
    for j=1:L
        Img_level=I(i,j)+1; %获取图像的灰度级
        nk(Img_level)=nk(Img_level)+1; %统计每个灰度级像素的点数
    end
end
for k=1:G  %循环
    Ps(k)=nk(k)/Img_size; %计算每一个像素点的概率
    if Ps(k)~=0           %如果像素点的概率不为零
        H_x=-Ps(k)*log2(Ps(k))+H_x; %求熵值的公式
    end
end
feature = {H_x};
end


