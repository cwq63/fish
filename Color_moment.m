function Color_moment(srcDir, output_xlsx_path)
%此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取图片的一二三阶颜色矩并保存在Excel文件

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);
N= '文件名';
CM1 = '一二三阶颜色矩(R分量)';
CM2 = '一二三阶颜色矩(G分量）';
CM3 = '一二三阶颜色矩（B分量）';
Y= {N,CM1,CM2,CM3};
allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name=cell(len,1);

for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    image_name{ii,1}=name;
    I=imread(name); %读取文件
    X = Color_moment_one_image(I);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:D%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:D1');
end


function feature = Color_moment_one_image(I)
 %输入为RGB矩阵，输出为颜色矩
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
[m n] = size(R);
N = m*n;                        %像素总个数
Ur = sum(sum(R)) / N;           %R矩阵均值
R1 = R - Ur;                    %R中每个元素均减Ur
R2 = R1.*R1;                    %R1中每个元素取平方
Qr = (sum(sum(R2))/N)^(1/2);    %R矩阵方差
R3 = R1.*R2;                    %R3 = R1^3
Sr = (sum(sum(R3))/N)^(1/3);    %R矩阵斜度
Ug = sum(sum(G)) / N;    
R1 = G - Ug;                    %每个元素均减Ur
R2 = R1.*R1;                    %每个元素取平方
Qg = (sum(sum(R2))/N)^(1/2);   
R3 = R1.*R2;                    %R3 = R1^3
Sg = (sum(sum(R3))/N)^(1/3);  
Ub = sum(sum(B)) / N;    
R1 = G - Ub;                    %每个元素均减Ur
R2 = R1.*R1;                    %每个元素取平方
Qb = (sum(sum(R2))/N)^(1/2);   
R3 = R1.*R2;                    %R3 = R1^3
Sb = (sum(sum(R3))/N)^(1/3);  
%颜色矩向量
feature = {num2str([Ur Qr Sr]),num2str([ Ug Qg Sg]),num2str([ Ub Qb Sb])};
end 


