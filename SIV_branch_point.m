function [s] = SIV_branch_point(img_input)
I=img_input;
I=rgb2gray(I);
[m,n]=size(I);
% figure;
% imshow(I);
bwskel = bwmorph(I,'thin',Inf);

%去除30像素内的毛刺
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

%分支点中，5*5区域内的有效像素超过5个，即为有效分支点
count=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            %计算5*5方形区域内的点的数量
            for ii=i-2:i+2
                for jj=j-2:j+2
                    count=count+bwskel(ii,jj);
                end
            end
            %             disp(count);
            if count>6
                %                 plot(j,i,'.','color','r','markersize',30);
                %                 fprintf('第%d行，第%d列有一个分支点\n', i,j);
            else
                BP(i,j)=0;
            end
            count=0;
        end
    end
end
s=nnz(BP);%计算分支点数量
fprintf('共有%d个分支点\n',s);
end