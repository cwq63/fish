function feature = SIV_budding_num(I)
J=rgb2gray(I); %�Ҷ�ת��
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
J= imdilate(J,sehj00); %����
J=bwareaopen(J,200,8); %����С�������
J=imfill(J,'hole'); %�׶���� 
se0=strel('square',15);
se1=strel('square',15);
N1=imerode(J,se0); %�ٴθ�ʴ
N2= imdilate(N1,se1); %�ٴ�����
N=J-N2; %��ѿ����
N=bwareaopen(N,20,8); %����С�������
num=max(max(bwlabel(N)))-2; % ��ѿ��  �ܻ��������߽�����ʿ۳�
 %ż������ֳ�ѿ��Ϊ�����������0���
if 0>num 
num=0;  
end
feature =num;
end

