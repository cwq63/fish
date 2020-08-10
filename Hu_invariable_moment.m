function Hu_invariable_moment(srcDir, output_xlsx_path)
%����:����ͼ���Hu���߸������.

%����: I-RGBͼ��

%���: inv_ m7-�߸������


%in_image = imread('1.bmp');

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);
N= '�ļ���';
Y= {N,'h1','h2','h3','h4','h5','h6','h7'};
allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name=cell(len,1);

for ii=1:len          %���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ�
    image_name{ii,1}=name;
    X = Hu_invariable_moment_one_image(I);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:H%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  
%��Excel�ļ���д��ָ���Ŀ
xlswrite(output_xlsx_path,Y,'A1:H1');
end

function inv_m7 = Hu_invariable_moment_one_image(I)

image=rgb2gray(I);
%��ͼ��������������ת����˫������
image=double(image);
%%%==============���㡢��======================
%����Ҷ�ͼ�����׼��ξ�
m00=sum(sum(image));
m10=0;
m01=0;
[row,col]=size(image);
for i=1:row
    for j=1:col

        m10=m10+i*image(i,j);

        m01 =m01+j*image(i,j); 

    end

end
%%%%%%%=============���� ========================
u10=m10/m00;
u01=m01/m00;
%%%%%%%%=============����ͼ��Ķ��׼��ξء����׼��ξ�==========
m20=0;
m02=0;
m11=0;
m30=0;
m12=0;
m21=0;
m03=0;
for i=1:row

    for j=1:col

        m20=m20+i^2*image(i,j);

        m02=m02+j^2*image(i,j);

        m11=m11+i*j*image(i,j);

        m3O=m30+i^3*image(i,j);

        m03=m03+j^3 *image(i,j);

        m12=m12+i*j^2*image(i,j);

        m21=m21+i^2*j*image(i,j);

    end

end
%%%%=============����ͼ��Ķ������ľء��������ľ�==========
y00=m00;
y10=0;
y01=0;
y11=m11-u01 * m10;
y20=m20-u10*m10;
y02=m02-u01 * m01;
y30=m30-3*u10* m20+2*u10^2*m10;
y12=m12-2*u01*m11-u10* m02+2*u01^2*m10;
y21=m21-2*u10* m11-u01*m20+2*u10^2*m01;
y03=m03-3*u01 *m02+2*u01^2*m01;
%%%==============����ͼ��Ĺ�����ľ�================
n20=y20/m00^2;
n02=y02/m00^2;
n11=y11/m00^2;
n30=y30/m00^2.5;
n03=y03/m00^2.5;
n12=y12/m00^2.5;
n21=y21/m00^2.5;
%%%==============����ͼ����߸������==================
h1=n20+n02;
h2 = (n20-n02)^2 + 4*(n11)^2;
h3 = (n30-3*n12)^2 + (3*n21-n03)^2;
h4 = (n30+n12)^2 + (n21+n03)^2;
h5=(n30-3*n12)*(n30+n12)*((n30+n12)^2-3* (n21+n03)^2)+(3*n21-n03)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2);
h6 = (n20-n02)*((n30+n12)^2-(n21+n03)^2)+4*n11*(n30+n12)*(n21+n03);
h7=(3*n21-n03)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2)+(3*n12-n30)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2);

inv_m7= {num2str(h1),num2str(h2),num2str(h3),num2str(h4),num2str(h5),num2str(h6),num2str(h7)};
% disp(inv_m7)
end


