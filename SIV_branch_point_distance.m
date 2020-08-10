function [average_distance]=SIV_branch_point_distance(img_input)
    average_distance=branch_point_distance(img_input);
end


function [average_distance] = branch_point_distance(img_input)
I=img_input;
I=rgb2gray(I);
[m,n]=size(I);

%�Ǽ�
global bwskel_branch;
bwskel_branch = bwmorph(I,'thin',Inf);


%ȥ��30�����ڵ�ë��
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

%��֧��
BP = bwmorph(bwskel_branch,'branchpoints');

%��֧���У�5*5�����ڵ���Ч���س���5������Ϊ��Ч��֧��
count=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            %����5*5���������ڵĵ������
            for ii=i-2:i+2
                for jj=j-2:j+2
                    count=count+bwskel_branch(ii,jj);
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

distance=0;total_distance=0;total_count=0;
global count_2;
count_2=0;
for i=1:m
    for j=1:n
        if BP(i,j)~=0
            distance=find_distance(bwskel_branch,i,j,BP);
%             fprintf('�÷�֧����������֧��֮���У�%d���أ�����%d��\n', distance,count_2);
            total_distance=total_distance+distance;
            total_count=total_count+count_2;
            count_2=0;
            clear bwskel_branch;
            bwskel_branch = bwmorph(I,'thin',Inf);
        end
    end
end
average_distance=roundn(total_distance/total_count,-2);
fprintf('��֧��֮���У�%d�Σ�ƽ������Ϊ%d\n',total_count, average_distance);
end


                    
%��֧�������Һ����� ���õݹ���Ұ��������ӵ㣬ֱ���ҵ���֧�㡣
function s=find_distance(bwskel_branch,i,j,BP)
    global bwskel_branch;
    global count_2;
    bwskel_branch(i,j)=0;s=0;distance=0;
    %�ҵ���֧�����˳��ݹ�
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
    %δ�ҵ���֧�������Ѱ�Ұ����������ӵ㡣
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
