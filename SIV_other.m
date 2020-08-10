function [E,P,ck,Sol,Spercent,AP,F,Ir,IR] = SIV_other(input_img)
I=input_img;
J=rgb2gray(I); %ת��Ϊ�Ҷ�ͼ
J=im2double(J); 
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0);
J=imdilate(J,sehj00);
J=bwareaopen(J,200,8);
J=imfill(J,'hole');%���Ϸָ�Ҷ�ֵ����0��ת��Ϊ��ֵͼƬ��ΪSIV���򣬻��ͼ2 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=J-0;


%%%%%%����ΪSIV����ͼ2��E��Բ�ȡ�P�ܳ���C��Բ�ȡ�kuan��chang����c/k��/�����������
E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity); %ƫ����
P=regionprops(J, 'Perimeter');
P=cat(1, P.Perimeter); %�ܳ�
[r, c]=find(J==1);
[rectx,recty,~,~] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2));
chang= max(ds(1:2));
ck=chang/kuan;%��۱�

Sj=regionprops(J, 'Area'); %SIV�������
Sj=cat(1,Sj. Area); %��ȡͼ2��SIV�����������
Sq=kuan*chang;
Spercent= Sj/Sq;%���ζ�
AP=Sj/P; %����ܳ���
F= (P.^2)/ (4 * pi *Sj ); %��״����
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
Ir=pi*max1/A;% Irregularity :�������
% IR=sqrt(max1/min1);% IR :��״��
min1_new=max_inscribed_circle(I);
IR=min1_new*2/chang;% IR :��״��

Sc=regionprops(J, 'ConvexArea');
Sc =cat(1, Sc. ConvexArea);
Sol=Sj/Sc;% Area/ConvexArea��ӳ������Ĺ̿��Գ̶�
end