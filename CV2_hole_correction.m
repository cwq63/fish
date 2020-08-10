function CV2_hole_correction(srcDir, output_xlsx_path)
%CV2_HOLECORRECTION �˴���ʾ�йش˺�����ժҪ
% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡ�������������Excel�ļ�
if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
format long g;  
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name=cell(len,1);

%  ���������Ŀ
N= 'CV�ļ���';
Hn='Ѫ��������';
Vs= 'Ѫ�����';
Hs= 'Ѫ���������';
Es= '��Բ��';
Ps= '�ܳ�';
Ck='��Ӿ��γ�/�� ';
Sp='CV�����/��Ӿ������*100 ';
Mck='�����Բ����/����';
Scv2='CV�����';
Y= {N,Hn,Vs,Hs,Es,Ps,Ck,Sp,Mck,Scv2};
%disp(Y);
for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); 
    image_name{ii,1}=name;
    X = CV2_hole_correction_one_image(I);
    %disp(X);
    
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    %��Excel�ļ���д���ļ���
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));

end

 %��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:J1');


end

function feature = CV2_hole_correction_one_image(I)

%�Ҷ�ת��
B=rgb2gray(I);
%��������ֵ�ָ�
T=0.3*(double(min(B(:)))+double(max(B(:))));
d=false;
while~d
     g=B>=T;
     Tn=0.3*(mean(B(g))+mean(B(~g)));
     d=abs(T-Tn)<0.3;
     T=Tn;
end
level=Tn/255;
%��ֵת��
BW=im2bw(B,level);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
BW=imerode(BW,sehj0);
BW=imdilate(BW,sehj00);

BW=bwareaopen(BW,500,8);
BWH=imfill( BW , 'holes');

%������ȡ
H= BWH -BW;
H2 = bwareaopen(H,20,8);
num=max(max(bwlabel(H2))); %�׶���Ŀ
H2=H2-0;
BW2=BWH-H2;
BW2= BW2-0;
BWH=BWH-0;
S=regionprops(BW2, 'Area'); 
S=cat(1,S. Area); %Ѫ�����
SH=regionprops(H2, 'Area'); 
SH=cat(1,SH. Area); %�׶����
E=regionprops(BWH, 'Eccentricity');
E=cat(1,E. Eccentricity); %ƫ����
P=regionprops(BWH, 'Perimeter');
P=cat(1, P. Perimeter); %�ܳ�
[r c]=find(BWH ==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %��Ӿ��ο�
chang= max(ds(1:2)); %��Ӿ��γ�
ck=chang/kuan;
St=regionprops(BWH, 'Area'); 
St=cat(1,St. Area); %CV�����
Sq=kuan*chang; %��Ӿ������
Spercent= St/ Sq*100; %������
Mc= regionprops(BWH, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %�����Բ����
Mk= regionprops(BWH, 'MinorAxisLength'); 
mk=cat(1,Mk. MinorAxisLength); %�����Բ����
mck= mc/mk;
feature ={num2str(num),num2str(S),num2str(SH),num2str(E), num2str(P),num2str(ck),num2str(Spercent),num2str(mck),num2str(St)};
%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(BWH);
%subplot(2,3,3);imshow(BW2);
%subplot(2,3,4);imshow(H2);
end

