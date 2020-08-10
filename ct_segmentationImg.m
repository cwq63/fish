function [mask, maskLines] = ct_segmentationImg(img)
    mask=rgb2gray(img);
    maskLines = bwmorph(mask,'thin',inf); % find the center lines in the blood vessels
end