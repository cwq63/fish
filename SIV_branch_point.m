function [s] = SIV_branch_point(img_input)
I=img_input;
I=rgb2gray(I);
[m,n]=size(I);
% figure;
% imshow(I);
bwskel = bwmorph(I,'thin',Inf);

%ȥ��30�����ڵ�ë��
for kk=1:30
    for i=1:m
        for j=1:n
            if bwskel(i,j)==1
                left=bwskel(i-1,j)+bwskel(i+1,j)+bwskel(i-1,j-1)+bwskel(i,j-1)+bwskel(i+1,j-1)+bwskel(i-1,j+1)+bwskel(i,j+1)+bwskel(i+1,j+1);
                if left<=1
                    bwskel(i,j)=0;
                end
            end
        end
    end
end


% figure;
% imshow(bwskel);
% hold on;

BP = bwmorph(bwskel,'branchpoints');

%��֧���У�5*5�����ڵ���Ч���س���5������Ϊ��Ч��֧��
count=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            %����5*5���������ڵĵ������
            for ii=i-2:i+2
                for jj=j-2:j+2
                    count=count+bwskel(ii,jj);
                end
            end
            %             disp(count);
            if count>6
                %                 plot(j,i,'.','color','r','markersize',30);
                %                 fprintf('��%d�У���%d����һ����֧��\n', i,j);
            else
                BP(i,j)=0;
            end
            count=0;
        end
    end
end
s=nnz(BP);%�����֧������
fprintf('����%d����֧��\n',s);
end