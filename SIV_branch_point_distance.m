function [average_distance]=SIV_branch_point_distance(img_input)
    average_distance=branch_point_distance(img_input);
end


function [average_distance] = branch_point_distance(img_input)
I=img_input;
I=rgb2gray(I);
[m,n]=size(I);

%骨架
global bwskel_branch;
bwskel_branch = bwmorph(I,'thin',Inf);


%去除30像素内的毛刺
for kk=1:30
    for i=1:m
        for j=1:n
            if bwskel_branch(i,j)==1
                left=bwskel_branch(i-1,j)+bwskel_branch(i+1,j)+bwskel_branch(i-1,j-1)+bwskel_branch(i,j-1)+bwskel_branch(i+1,j-1)+bwskel_branch(i-1,j+1)+bwskel_branch(i,j+1)+bwskel_branch(i+1,j+1);
                if left<=1
                    bwskel_branch(i,j)=0;
                end
            end
        end
    end
end

%分支点
BP = bwmorph(bwskel_branch,'branchpoints');

%分支点中，5*5区域内的有效像素超过5个，即为有效分支点
count=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            %计算5*5方形区域内的点的数量
            for ii=i-2:i+2
                for jj=j-2:j+2
                    count=count+bwskel_branch(ii,jj);
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

distance=0;total_distance=0;total_count=0;
global count_2;
count_2=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            distance=find_distance(bwskel_branch,i,j,BP);
%             fprintf('该分支点与其他分支点之间有：%d像素，共有%d段\n', distance,count_2);
            total_distance=total_distance+distance;
            total_count=total_count+count_2;
            count_2=0;
            clear bwskel_branch;
            bwskel_branch = bwmorph(I,'thin',Inf);
        end
    end
end
average_distance=roundn(total_distance/total_count,-2);
fprintf('分支点之间有：%d段，平均距离为%d\n',total_count, average_distance);
end


                    
%分支点距离查找函数。 运用递归查找八领域连接点，直到找到分支点。
function s=find_distance(bwskel_branch,i,j,BP)
    global bwskel_branch;
    global count_2;
    bwskel_branch(i,j)=0;s=0;distance=0;
    %找到分支点则退出递归
    for ii=i-1:i+1
        for jj=j-1:j+1
            if(bwskel_branch(ii,jj)==1)
                if(BP(ii,jj)==1)
                    s=s+1;
                    count_2=count_2+1;
                    return ;
                end
            end
        end
    end
    %未找到分支点则继续寻找八领域内连接点。
    for ii=i-1:i+1
        for jj=j-1:j+1
            if(bwskel_branch(ii,jj)==1)
                distance=find_distance(bwskel_branch,ii,jj,BP);
                if(distance~=0)
                    s=s+1;
                end
                s=s+distance;
            end
        end
    end
end
