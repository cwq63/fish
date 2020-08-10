function [total__length] = SIV_total_length(img_input)
I=img_input;
I=rgb2gray(I);
skel = bwmorph(I,'thin',Inf);
total__length=nnz(skel);
fprintf('血管长度为： %d像素\n', total__length);
end
