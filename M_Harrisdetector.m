function M_Harrisdetector(srcDir,output_xlsx_path)
%M_Harrisdetector 此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，用多尺度Harris角点提取算法计算图片角点
% 并将角点数保存在Excel表格中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Harris角点提取算法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

srcDir = 'D:\斑马鱼血管标注\图像特征提取补充';
output_xlsx_path = 'D:\斑马鱼血管标注\图像特征提取补充\M_Harrisdetector.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);
N = '文件名';
cnt = '角点数';
Y = {N,cnt};
allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name = cell(len,1);
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    image_name{ii,1} = name;
    X = M_Harrisdetector_one_image(name);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:B%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:B1');
end


function  cnt = M_Harrisdetector_one_image(name)
I=imread(name); %读取文件
Info=imfinfo(name);
if Info.BitDepth>8
    f=rgb2gray(I);
end
%
% fx = [5 0 -5;8 0 -8;5 0 -5];          % 高斯函数一阶微分，x方向(用于改进的Harris角点提取算法)
ori_im=double(f)/255;                   %unit8转化为64为双精度double64
fx = [-2 -1 0 1 2];                     % x方向梯度算子(用于Harris角点提取算法)
Ix = filter2(fx,ori_im);                % x方向滤波
% fy = [5 8 5;0 0 0;-5 -8 -5];          % 高斯函数一阶微分，y方向(用于改进的Harris角点提取算法)
fy = [-2;-1;0;1;2];                     % y方向梯度算子(用于Harris角点提取算法)
Iy = filter2(fy,ori_im);                % y方向滤波
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;
clear Ix;
clear Iy;

h= fspecial('gaussian',[7 7],2);        % 产生7*7的高斯窗函数，sigma=2

Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

height = size(ori_im,1);
width = size(ori_im,2);
result = zeros(height,width);           % 纪录角点位置，角点处值为1

R = zeros(height,width);

Rmax = 0;                              % 图像中最大的R值
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];             % auto correlation matrix
        R(i,j) = det(M)-0.06*(trace(M))^2;                     % 计算R
        if R(i,j) > Rmax
            Rmax = R(i,j);
        end
    end
end

cnt = 0;
for i = 2:height-1
    for j = 2:width-1
        % 进行非极大抑制，窗口大小3*3
        if R(i,j) > 0.01*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
            result(i,j) = 1;
            cnt = cnt+1;
        end
    end
end

[posc, posr] = find(result == 1);
%disp(name)
%disp(cnt)   
% 角点个数
figure;
imshow(ori_im)
hold on;
plot(posr,posc,'r+');
end


