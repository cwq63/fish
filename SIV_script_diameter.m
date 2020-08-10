function [histDia] = SIV_script_diameter(img_input)
img=img_input;im=3;

[mask, maskLines] = ct_segmentationImg(img);

% [maskLines, branchPoints] = ct_deleteCorners(maskLines);

maskEdges = ct_findEdges(mask);

[diaAll, ~] = ct_trackVessel(maskLines,maskEdges);

histDia = ct_calculateHist(diaAll,im);
end