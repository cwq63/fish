function  ltp(srcDir)
%ltp 此处显示有关此函数的摘要

% 输入：
% srcDir：存放待处理的图片的文件夹

% 函数功能
% 遍历srcDir中的所有图片，包括png和bmp，提取图片的ltp

if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得bmp文件的个数
image_name = cell(len,1);

for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread(name); %读取文件
    image_name{ii,1} = name;
    ltp_one_image(I);
end
end
%img=imread('1.bmp');
function ltp_one_image(I)
I=rgb2gray(I);
t=5;
I=double(I);
[m n]=size(I);
imgn_upper=zeros(m,n);%初始化结果矩阵(正值)  
imgn_lower=zeros(m,n);%初始化结果矩阵(负值)
for i=2:m-1
   for j=2:n-1
        for p=i-1:i+1%遍历周边像素
            for q =j-1:j+1
                if p~=i || q~=j  %不取目标像素
                        %%%正值提取结果
                     if (I(p,q) - I(i,j))>t||(I(p,q) - I(i,j))==t
                        if(p==i&&q==j-1)                  
                           imgn_upper(i,j)=imgn_upper(i,j)+2^0;
                        end
                        if(p==i+1&&q==j-1)               
                           imgn_upper(i,j)=imgn_upper(i,j)+2^1;
                        end
                        
                        if(p==i+1&&q==j)                
                           imgn_upper(i,j)=imgn_upper(i,j)+2^2;
                        end
                        if(p==i+1&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^3;
                        end
                        if(p==i&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^4;
                        end
                        if(p==i-1&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^5;
                        end
                        if(p==i-1&&q==j)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^6;
                        end
                        if(p==i-1&&q==j-1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^7;
                        end
                      %%%负值提取结果
                     elseif (I(p,q) - I(i,j))<-t||(I(p,q) - I(i,j))==-t
                        if(p==i&&q==j-1)                  
                            imgn_lower(i,j)=imgn_lower(i,j)+2^0;
                        end
                        if(p==i+1&&q==j-1)               
                            imgn_lower(i,j)=imgn_lower(i,j)+2^1;
                        end
                        if(p==i+1&&q==j)                
                            imgn_lower(i,j)=imgn_lower(i,j)+2^2;
                        end
                        if(p==i+1&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^3;
                        end
                        if(p==i&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^4;
                        end
                        if(p==i-1&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^5;
                        end
                        if(p==i-1&&q==j)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^6;
                        end
                        if(p==i-1&&q==j-1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^7;
                        end
                     end
                 end
            end
        end
   end
end
figure;
subplot(1,2,1),imshow(imgn_upper,[]),title('LTP正值提取');
subplot(1,2,2),imshow(imgn_lower,[]),title('LTP负值提取');
end


