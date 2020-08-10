function [EulerNumber,totle_area_piex,hole_area_piex,Vs] = SIV_hole_area(img_input)
I=img_input;
I=rgb2gray(I);
[m,n]=size(I);

%计算孔洞数
L=bwmorph(I,'thin',Inf);
L=bwareaopen(L,100,8); %过滤小面积区域
stats=regionprops(L,'EulerNumber');
k=length(stats);
if k==1
    if stats.EulerNumber==1
        EulerNumber=0;
    else
        EulerNumber=abs(stats.EulerNumber)+1;
    end
else
    EulerNumber=0;
    for i=1:k
        if stats(i).EulerNumber==1
        else
            EulerNumber=EulerNumber+abs(stats(i).EulerNumber);
        end
    end
end


lunkuo = bwperim(I);
lunkuo2= imfill(lunkuo,'holes');
hole_area_piex=0;totle_area_piex=0;
for i=1:m
    for j=1:n
        if lunkuo2(i,j)==1
            totle_area_piex=totle_area_piex+1;
            if I(i,j)==0
                hole_area_piex=hole_area_piex+1;
            end
        end
    end
end
Vs=totle_area_piex-hole_area_piex;
fprintf('孔洞数为：         %d\n', EulerNumber);
fprintf('区域总像素为：     %d\n', totle_area_piex);
fprintf('孔洞区域总像素为： %d\n', hole_area_piex);
fprintf('血管区域总像素为： %d\n', Vs);
end
