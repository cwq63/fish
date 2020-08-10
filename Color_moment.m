function Color_moment(srcDir, output_xlsx_path)
%�˴���ʾ�йش˺�����ժҪ

% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡͼƬ��һ��������ɫ�ز�������Excel�ļ�

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);
N= '�ļ���';
CM1 = 'һ��������ɫ��(R����)';
CM2 = 'һ��������ɫ��(G������';
CM3 = 'һ��������ɫ�أ�B������';
Y= {N,CM1,CM2,CM3};
allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name=cell(len,1);

for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    image_name{ii,1}=name;
    I=imread(name); %��ȡ�ļ�
    X = Color_moment_one_image(I);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:D%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:D1');
end


function feature = Color_moment_one_image(I)
 %����ΪRGB�������Ϊ��ɫ��
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
[m n] = size(R);
N = m*n;                        %�����ܸ���
Ur = sum(sum(R)) / N;           %R�����ֵ
R1 = R - Ur;                    %R��ÿ��Ԫ�ؾ���Ur
R2 = R1.*R1;                    %R1��ÿ��Ԫ��ȡƽ��
Qr = (sum(sum(R2))/N)^(1/2);    %R���󷽲�
R3 = R1.*R2;                    %R3 = R1^3
Sr = (sum(sum(R3))/N)^(1/3);    %R����б��
Ug = sum(sum(G)) / N;    
R1 = G - Ug;                    %ÿ��Ԫ�ؾ���Ur
R2 = R1.*R1;                    %ÿ��Ԫ��ȡƽ��
Qg = (sum(sum(R2))/N)^(1/2);   
R3 = R1.*R2;                    %R3 = R1^3
Sg = (sum(sum(R3))/N)^(1/3);  
Ub = sum(sum(B)) / N;    
R1 = G - Ub;                    %ÿ��Ԫ�ؾ���Ur
R2 = R1.*R1;                    %ÿ��Ԫ��ȡƽ��
Qb = (sum(sum(R2))/N)^(1/2);   
R3 = R1.*R2;                    %R3 = R1^3
Sb = (sum(sum(R3))/N)^(1/3);  
%��ɫ������
feature = {num2str([Ur Qr Sr]),num2str([ Ug Qg Sg]),num2str([ Ub Qb Sb])};
end 


