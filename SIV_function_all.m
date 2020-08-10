function SIV_function_all(srcDir, output_xlsx_path)
if exist('srcDir', 'var')
    srcDir=uigetdir('选择文件夹');
end

fullpath = mfilename('fullpath');
[path,~]=fileparts(fullpath);%path变量就是当前.m文件所在的目录

cd(srcDir);%切换路径到当前文件夹
allnames=struct2cell(dir('*.PNG')); %处理图片格式
% allnames=struct2cell(dir('*.bmp')); 
out_data=zeros(1000,18);%初始化输出矩阵
[~,len]=size(allnames); %获得文件的个数
image_name=cell(len,1);
cd(path);
addpath('uigetdir');

for ii=1:len%逐次取出文件
    name=allnames{1,ii};
    I=imread([srcDir,'\',name]); %读取文件，获得原始图片
    image_name{ii,1}=name;
    
    fprintf('第%d张图片:%s\n', ii,name);
    %函数说明
    [out_data(ii,1),out_data(ii,4),out_data(ii,3),out_data(ii,2)]=SIV_hole_area(I);%依次计算孔洞数、总面积、孔洞区域面积、血管面积。
    out_data(ii,6)=SIV_total_length(I); %血管总长度
    out_data(ii,5)=roundn((out_data(ii,2)/out_data(ii,6)),-2);%平均血管直径
    out_data(ii,7)=SIV_branch_point(I);%分支点数量
    out_data(ii,8)=roundn(SIV_branch_point_distance(I),-2);%分支点间的平均距离
    out_data(ii,9)=SIV_budding_num(I);%出芽数
    [out_data(ii,10),out_data(ii,11),out_data(ii,12),out_data(ii,13),...
    out_data(ii,14),out_data(ii,15),out_data(ii,16),out_data(ii,17),out_data(ii,18)]=SIV_other(I);
%取两位小数
    out_data(ii,10)=roundn(out_data(ii,10),-4);
    out_data(ii,11)=roundn(out_data(ii,11),-2);
    out_data(ii,12)=roundn(out_data(ii,12),-2);
    out_data(ii,13)=roundn(out_data(ii,13),-2);
    out_data(ii,14)=roundn(out_data(ii,14),-2);
    out_data(ii,15)=roundn(out_data(ii,15),-2);
    out_data(ii,16)=roundn(out_data(ii,16),-2);
    out_data(ii,17)=roundn(out_data(ii,17),-2);
    out_data(ii,18)=roundn(out_data(ii,18),-4);
end
N= 'SIV文件名';
Hn='孔洞数';
Vs= '血管面积';
Hs= '孔洞面积';
Ssiv='SIV总面积';
diameter='平均血管直径';
area_total_length='血管总长度';
bracnch_point='分支点数量';
branch_points_distance='分支点之间的平均距离';
budding_num='出芽数';
%10-18
Es= '偏心率';
Ps= '周长';
Ck='外观比 ';
So='固靠性 ';
Sp='矩形度 ';
ap='面积周长比';
Fs='形状因子';
Irr='不规则度';
IRr='球状性';
Y={N,Hn,Vs,Hs,Ssiv,diameter,area_total_length,bracnch_point,branch_points_distance,budding_num...
    Es,Ps,Ck,So,Sp,ap,Fs,Irr,IRr};%表头


%写入Excel文件
xlswrite(output_xlsx_path,Y,'A1:S1');%写入表头
xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',len+1));%写入文件名
xlswrite(output_xlsx_path,out_data,sprintf('B2:S%d',len+1));%写入数据
end