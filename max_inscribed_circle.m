function [R]=max_inscribed_circle(ContourImage)
ContourImage_2=rgb2gray(ContourImage);
ContourImage_2=imfill(ContourImage_2,'hole');%以上分割灰度值大于0并转化为二值图片，为SIV区域，获得图2
ContourImage_2=edge(ContourImage_2);
for iii=5:2:15
    se=strel('disk',iii');%圆盘型结构元素
    ContourImage_3=imdilate(ContourImage_2,se);
    ContourImage_3=imfill(ContourImage_3,'hole');
    ContourImage_3=edge(ContourImage_3);
    
    ContourImage=uint8(ContourImage_3);
    [m,n]=size(ContourImage);
    for i=1:m
        for j=1:n
            if ContourImage(i,j)>0
                ContourImage(i,j)=255;
            end
        end
    end
    % get the contour
    sz=size(ContourImage);
    [Y,X]=find(ContourImage==255,1, 'first');
    contour = bwtraceboundary(ContourImage, [Y(1), X(1)], 'W', 8);
    X=contour(:,2);
    Y=contour(:,1);
    
    % find the maximum inscribed circle:
    % The point that has the maximum distance inside the given contour is the
    % center. The distance of to the closest edge (tangent edge) is the radius.
    BW=bwdist(logical(ContourImage));
    [Mx, My]=meshgrid(1:sz(2), 1:sz(1));
    [Vin Von]=inpoly([Mx(:),My(:)],[X,Y]);
    ind=sub2ind(sz, My(Vin),Mx(Vin));
    [R RInd]=max(BW(ind));
    R=R(1); RInd=RInd(1); % handle multiple solutions: Just take first.
    % [cy cx]=ind2sub(sz, ind(RInd));
    if R~=0
        break;
    end
end
% % display result
% if (~exist('display','var'))
%     display=1;
% end
% if (display)
%     BW(cy,cx)=R+20; % to emphasize the center
%     figure,imshow(BW,[]);
%     hold on
%     plot(X,Y,'r','LineWidth',2);
%     theta = [linspace(0,2*pi) 0];
%     hold on
%     plot(cos(theta)*R+cx,sin(theta)*R+cy,'color','g','LineWidth', 2);
% end

end
