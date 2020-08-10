function SIV_hole_correction(srcDir, output_xlsx_path)
%SIV_holecorrection �˴���ʾ�йش˺�����ժҪ

% ���룺
% srcDir����Ŵ������ͼƬ���ļ���
% output_xlsx_path:��������ȡ������Excel�ļ�·��

% ��������
% ����srcDir�е�����ͼƬ������png��bmp����ȡ�������������
srcDir = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)';
output_xlsx_path = 'D:\������Ѫ�ܱ�ע\����Ѫ�ܴ���ע��(һ����)\SIV_hole_correction.xls';

if exist('srcDir', 'var')
    srcDir=uigetdir('ѡ���ļ���');
end
format long g;%ֻ���ʵ��
cd(srcDir);

allnames=struct2cell(dir('*.bmp')); %����ͼƬ��ʽ
[k,len]=size(allnames); %����ļ��ĸ���
image_name=cell(len,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N= '72hpf SIV�ļ���';
Hn='�׶���';
Vs= 'Ѫ�����';
Hs= '�׶����';
Es= '��Բ��';
Cs= '��Բ��';
Ps= '�ܳ�';
Kuan='��Ӿ��ο��';
Chang='��Ӿ��γ���';
Ck='��Ӿ��γ�/�� ';
Sp='SIV�����/��Ӿ������*100 ';
Mk='�����Բ����';
Mc='�����Բ����';
Ssiv='SIV�����';
Y= {N, Hn, Vs, Hs,Es, Cs,Ps,Kuan, Chang, Ck,Sp ,Mk,Mc,Ssiv};
%disp(Y);
%%%%%%%%%%%%%%%%%%%%%%%%%����Ϊ�����Ŀ
a0 = Y;
for ii=1:len%���ȡ���ļ�
    name=allnames{1,ii};
    I=imread(name); %��ȡ�ļ������ԭʼͼƬͼ1
    image_name{ii,1}=name;
    X = SIV_holecorrection_one_image(I);
 
    %disp(X);
    %����ȡ������д��Excel�ļ�
    range=sprintf('B%d:N%d',ii+1,ii+1);
    xlswrite(output_xlsx_path,X,range);
    xlswrite(output_xlsx_path,image_name,sprintf('A2:A%d',ii+1));
end  

%��Excel�ļ���д��ָ���Ŀ

xlswrite(output_xlsx_path,Y,'A1:N1');

%subplot(2,3,1);imshow(I);
%subplot(2,3,2);imshow(J);
%subplot(2,3,3);imshow(v);
%subplot(2,3,4);imshow(Hz);
%subplot(2,3,5);imshow(vw);
end


function feature = SIV_holecorrection_one_image(I) 
% �Ժ���ܻ����ӵĲ�����
% mask������ͼ��ָ����õĴ��Ե���֯����
% mask_vessel: ����ͼ��ָ����õľ�ϸ����Ѫ������

J=rgb2gray(I); %ת��Ϊ�Ҷ�ͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[width,height,bmsize]=size(J);
for i=1:width
    for j=1:height
        if J(i,j)>0
            J(i,j)=255;
        else
            J(i,j)=0;
        end
    end
end
J=im2double(J);
sehj0=strel('disk',1);
sehj00=strel('disk',1);
J=imerode(J,sehj0);
J=imdilate(J,sehj00);
J=bwareaopen(J,200,8);
J=imfill(J,'hole');%���Ϸָ�Ҷ�ֵ����0��ת��Ϊ��ֵͼƬ��ΪSIV���򣬻��ͼ2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f=im2double(I);%
T=0.4*(min(f(:))+max(f(:)));
done=false;
while ~done
    g=f>=T;
    Tn=0.4*(mean(f(g))+mean(f(~g)));
    done=abs(T-Tn)<0.1;
    T=Tn;
end
vv=im2bw(f,T);%%%%%%%%%%%%%%%%%%%%%����Ϊ������ֵ�ָ�
%ͬһ�������ָ�Ľ���ֱ������ִ���ֱ���ͼ5��ͼ3
vw=bwareaopen(vv,40,8); %�ٵ����ָ���ͼ��ֱ�ӹ������С��40������ ���ͼ5
v=bwareaopen(vv,500,8);
seh0=strel('disk',1);
seh00=strel('disk',2);
v=imerode(v,seh0);
v=imdilate(v,seh00);
vfh=imfill(v,'hole');
hz=vfh-v;
h=bwareaopen(hz,500,8);
v=vfh-h;%�ھ�������ˣ����ͣ��ٹ��ˣ�����ٹ��˹���������֮����ͼ3��ΪSIVѪ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hz=J-vw;%�׶����������ã�ͼ2-ͼ5��
seh2=strel('disk',1);
Hz=imerode(Hz,seh2);
%Hz =imdilate(Hz,seh2);
Hz=bwareaopen(Hz,100,8);
seh1=strel('disk',2);
Hz=imerode(Hz,seh1);
Hz=bwareaopen(Hz,50,8);%�������������δ����ĵ�ͼ4�������׶���Ŀ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=J-0;
v=v-0;
num=max(max(bwlabel(Hz))); %�׶���Ŀ����
Sj=regionprops(J, 'Area');
Sj=cat(1,Sj. Area); %��ȡͼ2��SIV�����������
Sv=regionprops(v, 'Area');
Sv=cat(1,Sv. Area); %��ȡѪ�����
Sh=Sj-Sv;
if  0> Sh
    Sh=0;
end
%%%%%%����ΪSIV����ͼ2��E��Բ�ȡ�P�ܳ���C��Բ�ȡ�kuan��chang����c/k��/�����������
E=regionprops(J, 'Eccentricity');
E=cat(1,E. Eccentricity);
P=regionprops(J, 'Perimeter');
P=cat(1, P.Perimeter);
C= (4 * pi *Sj ) / P ^2;
[r c]=find(J==1);
[rectx,recty,area,perimeter] = minboundrect (c,r,'p');
dd = [rectx(1:end-1),recty(1:end-1)];
dd1 = dd([4 1 2 3],:);
ds = sqrt(sum((dd-dd1).^2,2));
kuan = min(ds(1:2));
chang= max(ds(1:2));
ck=chang/kuan;
Mc= regionprops(J, 'MajorAxisLength');
mc=cat(1,Mc. MajorAxisLength);
Mk= regionprops(J, 'MinorAxisLength');
mk=cat(1,Mk. MinorAxisLength);
Sq=kuan*chang;
Spercent= Sj/ Sq*100;
feature = {num2str(num),num2str(Sv),num2str(Sh),num2str(E),num2str(C),num2str(P),num2str(kuan),num2str(chang),num2str(ck),num2str(Spercent),num2str(mk),num2str(mc),num2str(Sj)};
end
