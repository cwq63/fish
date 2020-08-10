function Color_entropy(srcDir, output_xlsx_path)
%COLOR_ENTROPY �˴���ʾ�йش˺�����ժҪ

% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡͼƬ����ɫ�ز�������Excel�ļ�

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);
N = '�ļ���';
H_x='��ɫ��';
Y= {N,H_x};
allnames = struct2cell(dir('*.bmp'));%ֻ����8λ��bmp�ļ�
[k,len] = size(allnames); %���bmp�ļ��ĸ���
image_name = cell(len,1);
for ii = 1:len%���ȡ���ļ�
    name = allnames{1,ii};
    I = imread(name); %��ȡ�ļ�
    image_name{ii,1} = name;
    X = Color_entropy_one_image(I);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:B%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:B1');
end



function feature = Color_entropy_one_image(I)

[C,L]=size(I); %��ͼ��Ĺ��
Img_size=C*L; %ͼ�����ص���ܸ���
G=256; %ͼ��ĻҶȼ�
H_x=0;
nk=zeros(G,1);%����һ��G��1�е�ȫ�����
for i=1:C
    for j=1:L
        Img_level=I(i,j)+1; %��ȡͼ��ĻҶȼ�
        nk(Img_level)=nk(Img_level)+1; %ͳ��ÿ���Ҷȼ����صĵ���
    end
end
for k=1:G  %ѭ��
    Ps(k)=nk(k)/Img_size; %����ÿһ�����ص�ĸ���
    if Ps(k)~=0           %������ص�ĸ��ʲ�Ϊ��
        H_x=-Ps(k)*log2(Ps(k))+H_x; %����ֵ�Ĺ�ʽ
    end
end
feature = {H_x};
end


