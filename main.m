clc;
clear all;
warning off;
%ʹ�÷�����
%1.�޸����롢���·��
%2.����Ҫ��ȡ���������ȥ�� % 
%3.������У�ѡ��ͼƬ�ļ���

srcDir='D:\QQ Data\WeChat Files\wxid_162krycbga4e22\FileStorage\File\2020-06\CDP-SIV\';%����·��
output_xlsx_path='D:\fash\Ѫ��ָ����ȡ\����ļ���\seg_fei_detailed';%���·��
tic;
SIV_function_all(srcDir, output_xlsx_path);
toc;