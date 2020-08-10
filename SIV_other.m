function [E,P,ck,Sol,Spercent,AP,F,Ir,IR] = SIV_other(input_img)
I=input_img;
J=rgb2gray(I); %转化为灰度图
J=im2double(J); 
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0);
J=imdilate(J,sehj00);
J=bwareaopen(J,200,8);
J=imfill(J,'hole');%以上分割灰度值大于0并转化为二值图片，为SIV区域，获得图2 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=J-0;


%%%%%%以下为SIV区域（图2）E椭圆度、P周长、C真圆度、kuan宽、chang长、c/k宽/长…参数输出
E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity); %偏心率
P=regionprops(J, 'Perimeter');
P=cat(1, P.Perimeter); %周长
[r, c]=find(J==1);
[rectx,recty,~,~] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2));
chang= max(ds(1:2));
ck=chang/kuan;%外观比

Sj=regionprops(J, 'Area'); %SIV区域面积
Sj=cat(1,Sj. Area); %获取图2（SIV区域）区域面积
Sq=kuan*chang;
Spercent= Sj/Sq;%矩形度
AP=Sj/P; %面积周长比
F= (P.^2)/ (4 * pi *Sj ); %形状因子
%%%%%%%%%%%%%%%%%%%%
[rows,columns]=size(J);
A=0;
for a=1:columns
    for b=1:rows
        if J(b,a)==0
            A=A+1;
        end
    end
end
C=contour(J);
X=C(1,:); Y=C(2,:);
m=size(X,2);
mx=X(1); my=Y(1);
for i=2:m
    mx=mx+X(i); my=my+Y(i);
end
mx1=mx/m; my1=my/m;
max1=1; min1=99999;
for i=1:m
    d=((X(i)-mx1)^2+(Y(i)-my1)^2);
    if (d>max1)
        max1=d;
    end
    if (d<min1) 
        min1=d; 
    end
end
%%%%%%%%%%%%%%%%%%%
Ir=pi*max1/A;% Irregularity :不规则度
% IR=sqrt(max1/min1);% IR :球状性
min1_new=max_inscribed_circle(I);
IR=min1_new*2/chang;% IR :球状性

Sc=regionprops(J, 'ConvexArea');
Sc =cat(1, Sc. ConvexArea);
Sol=Sj/Sc;% Area/ConvexArea反映出区域的固靠性程度
end