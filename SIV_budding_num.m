function feature = SIV_budding_num(I)
J=rgb2gray(I); %灰度转化
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
J= imdilate(J,sehj00); %膨胀
J=bwareaopen(J,200,8); %过滤小面积区域
J=imfill(J,'hole'); %孔洞填充 
se0=strel('square',15);
se1=strel('square',15);
N1=imerode(J,se0); %再次腐蚀
N2= imdilate(N1,se1); %再次膨胀
N=J-N2; %出芽区域
N=bwareaopen(N,20,8); %过滤小面积区域
num=max(max(bwlabel(N)))-2; % 出芽数  总会多出两个边角区域故扣除
 %偶尔会出现出芽数为负数的情况按0输出
if 0>num 
num=0;  
end
feature =num;
end

