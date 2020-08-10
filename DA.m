function DA(srcDir, output_xlsx_path)
%DA 此处显示有关此函数的摘要
% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保持所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取相关特征保存在

srcDir = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)';
output_xlsx_path = 'D:\斑马鱼血管标注\各类血管代码注释(一部分)\DA.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
format long g;%只输出实数
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得png文件的个数
image_name=cell(len,1);
N= 'DA文件名';
W='平均直径';  
Y= {N,W};
%disp(Y);%输出指标横目
for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); %读取文件
    image_name{ii,1}=name;
    X = DA_one_image(I);
    %disp(X);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:B%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:B1');
end


function feature = DA_one_image(I)

J=rgb2gray(I); %灰度转化
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
%imshow(J);
J=im2double(J); %二值转化
J=J-0;
S=regionprops(J, 'Area'); 
S=cat(1,S. Area); %面积
[r c]=find(J==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %最小外接矩形宽
chang= max(ds(1:2)); %最小外接矩形长
w=S/chang; %平均直径
feature = {num2str(w)}; 

end




