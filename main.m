clc;
clear all;
warning off;
%使用方法：
%1.修改输入、输出路径
%2.在需要提取的特征语句去掉 % 
%3.点击运行，选择图片文件夹

srcDir='D:\QQ Data\WeChat Files\wxid_162krycbga4e22\FileStorage\File\2020-06\CDP-SIV\';%输入路径
output_xlsx_path='D:\fash\血管指标提取\输出文件夹\seg_fei_detailed';%输出路径
tic;
SIV_function_all(srcDir, output_xlsx_path);
toc;