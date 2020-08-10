function CCV(srcDir, output_xlsx_path)
%CCV �˴���ʾ�йش˺�����ժҪ
% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡ�������������Excel�ļ�

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
% allnames=struct2cell(dir('*.PNG')); %����ͼƬ��ʽ
[k,len]=size(allnames);             %���bmp�ļ��ĸ���

N= 'CCV�ļ���';
Vs= 'Ѫ�����';
Es= '��Բ��';
Cs= '��Բ��';
Ps= '�ܳ�';
Kuan='��Ӿ��ο��';
Chang='��Ӿ��γ���';
Mk='�����Բ����';
Mc='�����Բ����';
Y= {N,Vs,Es,Cs,Ps,Kuan,Chang,Mk,Mc};
%disp(Y); %���ָ����Ŀ
image_name=cell(len,1);

for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ�
    image_name{ii,1}=name;
    X = CCV_one_image(I);
    %disp(X);  
    
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:I%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:I1');
   
end

function feature = CCV_one_image(I)

J=rgb2gray(I); %�Ҷ�ֵת��
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
seh0=strel('disk',1);
seh00=strel('disk',1);
J=imerode(J,seh0); %����ʴ
J=imdilate(J,seh00); %��������

J=bwareaopen(J,1000,8); %С�������
J=imfill(J, 'hole'); %�׶����
J=im2double(J); %��ֵת��
u=J;
u=u-0;
S=regionprops(u, 'Area'); 
S=cat(1,S. Area); %���Ѫ�����
E=regionprops(u, 'Eccentricity');
E=cat(1,E. Eccentricity); %���ƫ����
P=regionprops(u, 'Perimeter');
P=cat(1, P.Perimeter); %����ܳ�
C= (4 * pi *S ) / P ^2; %�����Բ��
[r c]=find(u==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %�����Ӿ��ο�
chang= max(ds(1:2)); %�����Ӿ��γ�
ck=chang/kuan; %�����Ӿ��γ�/�����
Mc= regionprops(u, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength); %��������Բ����
Mk= regionprops(u, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength); %��������Բ����
feature = {num2str(S),num2str(E),num2str(C),num2str(P),num2str(kuan),num2str(chang),num2str(mk),num2str(mc)};
end


