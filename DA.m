function DA(srcDir, output_xlsx_path)
%DA �˴���ʾ�йش˺�����ժҪ
% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡ�������������

srcDir = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)';
output_xlsx_path = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)\DA.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
format long g;%ֻ���ʵ��
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���png�ļ��ĸ���
image_name=cell(len,1);
N= 'DA�ļ���';
W='ƽ��ֱ��';  
Y= {N,W};
%disp(Y);%���ָ���Ŀ
for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ�
    image_name{ii,1}=name;
    X = DA_one_image(I);
    %disp(X);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:B%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:B1');
end


function feature = DA_one_image(I)

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
%imshow(J);
J=im2double(J); %��ֵת��
J=J-0;
S=regionprops(J, 'Area'); 
S=cat(1,S. Area); %���
[r c]=find(J==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2)); %��С��Ӿ��ο�
chang= max(ds(1:2)); %��С��Ӿ��γ�
w=S/chang; %ƽ��ֱ��
feature = {num2str(w)}; 

end




