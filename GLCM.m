function GLCM(srcDir, output_xlsx_path)
%GLCM 此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹
% output_xlsx_path:保存所提取特征的Excel文件路径

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取图片的灰度共生矩阵纹理特征
% （能量、熵、惯性矩、相关的均值和标准差），并保存在Excel文件
if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);
N = '文件名';
Em = '能量均值';
Ec = '能量标准差';
Hm = '熵均值';
Hc = '熵标准差';
Im = '惯性矩均值';
Ic = '惯性矩标准差';
Cm = '相关均值';
Cc = '相关标准差';
Y = {N,Em,Ec,Hm,Hc,Im,Ic,Cm,Cc};
% disp(Y);
ext = {'*.bmp','*.png'};
allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name = cell(len,1);


for ii=1:len
    %逐次取出文件
    name=allnames{1,ii};
    I=imread(name); 
    image_name{ii,1} = name;
    X = GLCM_one_image(I);
%     disp(X);
    %将提取的特征写入Excel文件
    range=sprintf('B%d:I%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));

end  
%在Excel文件中写入指标横目
xlswrite(output_xlsx_path,Y,'A1:I1');
end


function feature = GLCM_one_image(I)
G=rgb2gray(I);
[M,N] = size(G);
%2.为了减少计算量，对原始图像灰度级压缩，将Gray量化成16级
for i = 1:M
    for j = 1:N
        for n = 1:256/16
            if (n-1)*16<=G(i,j) && G(i,j)<=(n-1)*16+15
                G(i,j) = n-1;
            end
        end
    end
end

%3.计算四个共生矩阵P,取距离为1，角度分别为0,45,90,135
%--------------------------------------------------------------------------
P = zeros(16,16,4);
for m = 1:16
    for n = 1:16
        for i = 1:M
            for j = 1:N
                if j<N && G(i,j)==m-1 && G(i,j+1)==n-1
                    P(m,n,1) = P(m,n,1)+1;
                    P(n,m,1) = P(m,n,1);
                end
                if i>1 && j<N && G(i,j)==m-1 && G(i-1,j+1)==n-1
                    P(m,n,2) = P(m,n,2)+1;
                    P(n,m,2) = P(m,n,2);
                end
                if i<M && G(i,j)==m-1 && G(i+1,j)==n-1
                    P(m,n,3) = P(m,n,3)+1;
                    P(n,m,3) = P(m,n,3);
                end
                if i<M && j<N && G(i,j)==m-1 && G(i+1,j+1)==n-1
                    P(m,n,4) = P(m,n,4)+1;
                    P(n,m,4) = P(m,n,4);
                end
            end
        end
        if m==n
            P(m,n,:) = P(m,n,:)*2;
        end
    end
end

% 对共生矩阵归一化
%%---------------------------------------------------------
for n = 1:4
    P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
end

%4.对共生矩阵计算能量、熵、惯性矩、相关4个纹理参数
%--------------------------------------------------------------------------
H = zeros(1,4);
I = H;
Ux = H;      
Uy = H;
deltaX= H;  
deltaY = H;
C=H;
for n=1:4
    E(n) = sum(sum(P(:,:,n).^2)); %%能量
    for i = 1:16
        for j = 1:16
            if P(i,j,n)~=0
                H(n) = -P(i,j,n)*log(P(i,j,n))+H(n); %%熵
            end
            I(n) = (i-j)^2*P(i,j,n)+I(n);  %%惯性矩
          
            Ux(n) = i*P(i,j,n)+Ux(n); %相关性中μx
            Uy(n) = j*P(i,j,n)+Uy(n); %相关性中μy
        end
    end
end
for n = 1:4
    for i = 1:16
        for j = 1:16
            deltaX(n) = (i-Ux(n))^2*P(i,j,n)+deltaX(n); %相关性中σx
            deltaY(n) = (j-Uy(n))^2*P(i,j,n)+deltaY(n); %相关性中σy
            C(n) = i*j*P(i,j,n)+C(n);            
        end
    end
    C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %相关性  
end

A1=[E(1) E(2) E(3) E(4)];
A2=[H(1) H(2) H(3) H(4)];
A3=[I(1) I(2) I(3) I(4)];
A4=[C(1) C(2) C(3) C(4)];

%求能量、熵、惯性矩、相关的均值和标准差作为最终8维纹理特征
%--------------------------------------------------------------------------
a1 = mean(A1);  
b1 = sqrt(cov(A1));

a2 = mean(A2);  
b2 = sqrt(cov(A2));

a3 = mean(A3);  
b3 = sqrt(cov(A3));

a4 = mean(A4);  
b4 = sqrt(cov(A4));

feature = {num2str(a1),num2str(b1),num2str(a2),num2str(b2), num2str(a3), num2str(b3),num2str(a4),num2str(b4)};
end

