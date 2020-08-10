function ISV(srcDir, output_xlsx_path)
%ISV �˴���ʾ�йش˺�����ժҪ
% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡ�������������
srcDir = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)';
output_xlsx_path = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)\ISV.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
format long g;%ֻ���ʵ��
cd(srcDir);

allnames=struct2cell(dir('*.BMP')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name=cell(len,1);

N= 'ISV�ļ���';
Hn='Ѫ��������';
Vs= 'Ѫ�����';
Hs= 'Ѫ���������';
Es= '��Բ��';
Ps= '�ܳ�';
Ck='��Ӿ��γ�/�� ';
Sp='ISV�����/��Ӿ������*100 ';
Mck='�����Բ����/����';
Sisv='ISV�����';
Y= {N,Hn, Vs,Hs,Es,Ps,Ck,Sp,Mck, Sisv};
%disp(Y); %���������Ŀ
for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name);
    image_name{ii,1}=name;
    X = ISV_one_image(I);
    %disp(X);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:J1');
end

function feature = ISV_one_image(I)

 
J=rgb2gray(I); %�Ҷ�ת��
[width,height,bmsize]=size(J); %��ֵ�ָ�
for i=1:width
    for j=1:height
        if J(i,j)>0
            J(i,j)=255;
        else
            J(i,j)=0;
        end
    end
end  
J=im2double(J); %����ֵת��
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0); %��ʴ
J=imdilate(J,sehj00); %����
J=bwareaopen(J,200,8); %����С�������
J=imfill(J,'hole');%�׶����

B=rgb2gray(I); 
%��������ֵ�ָ�
T=0.3*(double(min(B(:)))+double(max(B(:))));
d=false;
while~d
     g=B>=T;
     Tn=0.3*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.1;
     T=Tn;
end
level=Tn/255;
%��ֵת��
BW=im2bw(B,level);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
BW=imerode(BW,sehj0); %��ʴ
BW=imdilate(BW,sehj00); %����
BW=bwareaopen(BW,500,8); %����С�������
BW=BW-0;
J=J-0;
%������ȡ
H=J -BW;
H2 = bwareaopen(H,20,8);
H2=bwareaopen(H2,800,8);
H2=H2-0;
sehj1=strel('disk',1);
sehj11=strel('disk',3);
H3=imerode(H2,sehj1);
H3=imdilate(H3,sehj11);
H3=bwareaopen(H3,800,8);
sehj2=strel('disk',2);
sehj22=strel('disk',3);
H3=imerode(H3,sehj2);
H3=imdilate(H3,sehj22); %�׶�����
num=max(max(bwlabel(H3))); %�׶���
S=regionprops(BW, 'Area'); 
S=cat(1,S. Area); %Ѫ�����
SH=regionprops(H2, 'Area'); 
SH=cat(1,SH. Area); %�׶����

E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity); %ƫ����
P=regionprops(J, 'Perimeter');
P=cat(1, P. Perimeter); %�ܳ�
[r c]=find(J ==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %��С��Ӿ��ο�
chang= max(ds(1:2)); %��С��Ӿ��γ�
ck=chang/kuan; %��۱�
St=regionprops(J, 'Area'); 
St=cat(1,St. Area); %ISV�������
Sq=kuan*chang;
Spercent= St/ Sq*100; %���ζ�
Mc= regionprops(J, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength);
Mk= regionprops(J, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength);
mck= mc/mk;
feature = {num2str(num), num2str(S),num2str(SH),num2str(E),num2str(P),num2str(ck),num2str(Spercent) ,num2str(mck) ,num2str(St)};


%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(J);
%subplot(2,3,3);imshow(BW);
%subplot(2,3,4);imshow(H3);
end


