function  ltp(srcDir)
%ltp �˴���ʾ�йش˺�����ժҪ

% ���룺
% srcDir����Ŵ������ͼƬ���ļ���

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡͼƬ��ltp

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���bmp�ļ��ĸ���
image_name = cell(len,1);

for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ�
    image_name{ii,1} = name;
    ltp_one_image(I);
end
end
%img=imread('1.bmp');
function ltp_one_image(I)
I=rgb2gray(I);
t=5;
I=double(I);
[m n]=size(I);
imgn_upper=zeros(m,n);%��ʼ���������(��ֵ)  
imgn_lower=zeros(m,n);%��ʼ���������(��ֵ)
for i=2:m-1
   for j=2:n-1
        for p=i-1:i+1%�����ܱ�����
            for q =j-1:j+1
                if p~=i || q~=j  %��ȡĿ������
                        %%%��ֵ��ȡ���
                     if (I(p,q) - I(i,j))>t||(I(p,q) - I(i,j))==t
                        if(p==i&&q==j-1)                  
                           imgn_upper(i,j)=imgn_upper(i,j)+2^0;
                        end
                        if(p==i+1&&q==j-1)               
                           imgn_upper(i,j)=imgn_upper(i,j)+2^1;
                        end
                        
                        if(p==i+1&&q==j)                
                           imgn_upper(i,j)=imgn_upper(i,j)+2^2;
                        end
                        if(p==i+1&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^3;
                        end
                        if(p==i&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^4;
                        end
                        if(p==i-1&&q==j+1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^5;
                        end
                        if(p==i-1&&q==j)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^6;
                        end
                        if(p==i-1&&q==j-1)                   
                           imgn_upper(i,j)=imgn_upper(i,j)+2^7;
                        end
                      %%%��ֵ��ȡ���
                     elseif (I(p,q) - I(i,j))<-t||(I(p,q) - I(i,j))==-t
                        if(p==i&&q==j-1)                  
                            imgn_lower(i,j)=imgn_lower(i,j)+2^0;
                        end
                        if(p==i+1&&q==j-1)               
                            imgn_lower(i,j)=imgn_lower(i,j)+2^1;
                        end
                        if(p==i+1&&q==j)                
                            imgn_lower(i,j)=imgn_lower(i,j)+2^2;
                        end
                        if(p==i+1&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^3;
                        end
                        if(p==i&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^4;
                        end
                        if(p==i-1&&q==j+1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^5;
                        end
                        if(p==i-1&&q==j)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^6;
                        end
                        if(p==i-1&&q==j-1)                   
                            imgn_lower(i,j)=imgn_lower(i,j)+2^7;
                        end
                     end
                 end
            end
        end
   end
end
figure;
subplot(1,2,1),imshow(imgn_upper,[]),title('LTP��ֵ��ȡ');
subplot(1,2,2),imshow(imgn_lower,[]),title('LTP��ֵ��ȡ');
end


