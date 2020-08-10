function CV_end(srcDir, output_xlsx_path)

%CV_end �˴���ʾ�йش˺�����ժҪ
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
[k,len]=size(allnames); %����ļ��ĸ���
N= '72hpf  ĩ��CV�ļ���';
Vs= 'Ѫ�����';
Es= '��Բ��';
Ps= '�ܳ�';
Kuan='��Ӿ��ο��';
Chang='��Ӿ��γ���';
Ck='��Ӿ��γ�/�� ';
Sp='SIV�����/��Ӿ������*100 ';
Mk='�����Բ����';
Mc='�����Բ����';
Y= {N,Vs, Es, Ps,Kuan,Chang,Ck,Sp,Mk,Mc};
%disp(Y); %���ָ���Ŀ
image_name=cell(len,1);
for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ�
    image_name{ii,1}=name;
    X = CV_end_one_image(I);
    %disp(X);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:J%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:J1');
end

function feature = CV_end_one_image(I)

J=rgb2gray(I); %ת��Ϊ�Ҷ�ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
J=im2double(J); %��ֵת��
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0); %��ʴ
J=imdilate(J,sehj00); %����
J=bwareaopen(J,200,8); %����С���
J=imfill(J,'hole'); %�׶����
u=J;
%�������
S=regionprops(u, 'Area'); 
S=cat(1,S. Area); %���

E=regionprops(u, 'Eccentricity');
E=cat(1,E. Eccentricity); %ƫ����

P=regionprops(u, 'Perimeter');
P=cat(1, P.Perimeter); %�ܳ�
[r c]=find(u==1);

[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %��С��Ӿ��ο�
chang= max(ds(1:2)); %��С��Ӿ��γ�
ck=chang/kuan; %��۱�
Mc= regionprops(u, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %��С��Բ����
Mk= regionprops(u, 'MinorAxisLength'); %��С��Բ����
mk=cat(1,Mk. MinorAxisLength);
Sq=kuan*chang;
Spercent= S/ Sq*100; %���ζ�
feature = {num2str(S),num2str(E),num2str(P),num2str(kuan),num2str(chang),num2str(ck),num2str(Spercent),num2str(mk),num2str(mc)}; 

%subplot(2,3,1),imshow(I);
%subplot(2,3,3),imshow(u);
end






