function SIV_function_all(srcDir, output_xlsx_path)
if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end

fullpath = mfilename('fullpath');
[path,~]=fileparts(fullpath);%path�������ǵ�ǰ.m�ļ����ڵ�Ŀ¼

cd(srcDir);%�л�·������ǰ�ļ���
allnames=struct2cell(dir('*.PNG')); %����ͼƬ��ʽ
% allnames=struct2cell(dir('*.bmp')); 
out_data=zeros(1000,18);%��ʼ���������
[~,len]=size(allnames); %����ļ��ĸ���
image_name=cell(len,1);
cd(path);
addpath('uigetdir');

for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread([srcDir,'\',name]); %��ȡ�ļ������ԭʼͼƬ
    image_name{ii,1}=name;
    
    fprintf('��%d��ͼƬ:%s\n', ii,name);
    %����˵��
    [out_data(ii,1),out_data(ii,4),out_data(ii,3),out_data(ii,2)]=SIV_hole_area(I);%���μ���׶�������������׶����������Ѫ�������
    out_data(ii,6)=SIV_total_length(I); %Ѫ���ܳ���
    out_data(ii,5)=roundn((out_data(ii,2)/out_data(ii,6)),-2);%ƽ��Ѫ��ֱ��
    out_data(ii,7)=SIV_branch_point(I);%��֧������
    out_data(ii,8)=roundn(SIV_branch_point_distance(I),-2);%��֧����ƽ������
    out_data(ii,9)=SIV_budding_num(I);%��ѿ��
    [out_data(ii,10),out_data(ii,11),out_data(ii,12),out_data(ii,13),...
    out_data(ii,14),out_data(ii,15),out_data(ii,16),out_data(ii,17),out_data(ii,18)]=SIV_other(I);
%ȡ��λС��
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
N= 'SIV�ļ���';
Hn='�׶���';
Vs= 'Ѫ�����';
Hs= '�׶����';
Ssiv='SIV�����';
diameter='ƽ��Ѫ��ֱ��';
area_total_length='Ѫ���ܳ���';
bracnch_point='��֧������';
branch_points_distance='��֧��֮���ƽ������';
budding_num='��ѿ��';
%10-18
Es= 'ƫ����';
Ps= '�ܳ�';
Ck='��۱� ';
So='�̿��� ';
Sp='���ζ� ';
ap='����ܳ���';
Fs='��״����';
Irr='�������';
IRr='��״��';
Y={N,Hn,Vs,Hs,Ssiv,diameter,area_total_length,bracnch_point,branch_points_distance,budding_num...
    Es,Ps,Ck,So,Sp,ap,Fs,Irr,IRr};%��ͷ


%д��Excel�ļ�
xlswrite(output_xlsx_path,Y,'A1:S1');%д���ͷ
xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',len+1));%д���ļ���
xlswrite(output_xlsx_path,out_data,sprintf('B2:S%d',len+1));%д������
end