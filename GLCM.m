function GLCM(srcDir, output_xlsx_path)
%GLCM �˴���ʾ�йش˺�����ժҪ

% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡͼƬ�ĻҶȹ���������������
% ���������ء����Ծء���صľ�ֵ�ͱ�׼�����������Excel�ļ�
if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);
N = '�ļ���';
Em = '������ֵ';
Ec = '������׼��';
Hm = '�ؾ�ֵ';
Hc = '�ر�׼��';
Im = '���Ծؾ�ֵ';
Ic = '���Ծر�׼��';
Cm = '��ؾ�ֵ';
Cc = '��ر�׼��';
Y = {N,Em,Ec,Hm,Hc,Im,Ic,Cm,Cc};
% disp(Y);
ext = {'*.bmp','*.png'};
allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name = cell(len,1);


for ii=1:len
    %���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); 
    image_name{ii,1} = name;
    X = GLCM_one_image(I);
%     disp(X);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:I%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));

end  
%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:I1');
end


function feature = GLCM_one_image(I)
G=rgb2gray(I);
[M,N] = size(G);
%2.Ϊ�˼��ټ���������ԭʼͼ��Ҷȼ�ѹ������Gray������16��
for i = 1:M
    for j = 1:N
        for n = 1:256/16
            if (n-1)*16<=G(i,j) && G(i,j)<=(n-1)*16+15
                G(i,j) = n-1;
            end
        end
    end
end

%3.�����ĸ���������P,ȡ����Ϊ1���Ƕȷֱ�Ϊ0,45,90,135
%--------------------------------------------------------------------------
P = zeros(16,16,4);
for m = 1:16
    for n = 1:16
        for i = 1:M
            for j = 1:N
                if j<N && G(i,j)==m-1 && G(i,j+1)==n-1
                    P(m,n,1) = P(m,n,1)+1;
                    P(n,m,1) = P(m,n,1);
                end
                if i>1 && j<N && G(i,j)==m-1 && G(i-1,j+1)==n-1
                    P(m,n,2) = P(m,n,2)+1;
                    P(n,m,2) = P(m,n,2);
                end
                if i<M && G(i,j)==m-1 && G(i+1,j)==n-1
                    P(m,n,3) = P(m,n,3)+1;
                    P(n,m,3) = P(m,n,3);
                end
                if i<M && j<N && G(i,j)==m-1 && G(i+1,j+1)==n-1
                    P(m,n,4) = P(m,n,4)+1;
                    P(n,m,4) = P(m,n,4);
                end
            end
        end
        if m==n
            P(m,n,:) = P(m,n,:)*2;
        end
    end
end

% �Թ��������һ��
%%---------------------------------------------------------
for n = 1:4
    P(:,:,n) = P(:,:,n)/sum(sum(P(:,:,n)));
end

%4.�Թ�����������������ء����Ծء����4���������
%--------------------------------------------------------------------------
H = zeros(1,4);
I = H;
Ux = H;      
Uy = H;
deltaX= H;  
deltaY = H;
C=H;
for n=1:4
    E(n) = sum(sum(P(:,:,n).^2)); %%����
    for i = 1:16
        for j = 1:16
            if P(i,j,n)~=0
                H(n) = -P(i,j,n)*log(P(i,j,n))+H(n); %%��
            end
            I(n) = (i-j)^2*P(i,j,n)+I(n);  %%���Ծ�
          
            Ux(n) = i*P(i,j,n)+Ux(n); %������Ц�x
            Uy(n) = j*P(i,j,n)+Uy(n); %������Ц�y
        end
    end
end
for n = 1:4
    for i = 1:16
        for j = 1:16
            deltaX(n) = (i-Ux(n))^2*P(i,j,n)+deltaX(n); %������Ц�x
            deltaY(n) = (j-Uy(n))^2*P(i,j,n)+deltaY(n); %������Ц�y
            C(n) = i*j*P(i,j,n)+C(n);            
        end
    end
    C(n) = (C(n)-Ux(n)*Uy(n))/deltaX(n)/deltaY(n); %�����  
end

A1=[E(1) E(2) E(3) E(4)];
A2=[H(1) H(2) H(3) H(4)];
A3=[I(1) I(2) I(3) I(4)];
A4=[C(1) C(2) C(3) C(4)];

%���������ء����Ծء���صľ�ֵ�ͱ�׼����Ϊ����8ά��������
%--------------------------------------------------------------------------
a1 = mean(A1);  
b1 = sqrt(cov(A1));

a2 = mean(A2);  
b2 = sqrt(cov(A2));

a3 = mean(A3);  
b3 = sqrt(cov(A3));

a4 = mean(A4);  
b4 = sqrt(cov(A4));

feature = {num2str(a1),num2str(b1),num2str(a2),num2str(b2), num2str(a3), num2str(b3),num2str(a4),num2str(b4)};
end

