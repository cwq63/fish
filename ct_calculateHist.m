function [return_mean_dia] = ct_calculateHist(diaAll,im)

    fprintf('\n')
%     display(['直径范围 --> [' num2str(min(diaAll)) ', ' num2str(max(diaAll)) '];'])
    return_mean_dia=mean(diaAll);
    display(['直径的平均值 --> ' num2str(mean(diaAll))])
    
%     y = 0:0.5:22; % ranges in consideration
%     histDia = hist(diaAll,y); % calculate the histogram
%     histDia = histDia ./ sum(histDia); % normalize the histogram
    
    % plot the histogram
%     figure; bar(y,histDia,'FaceColor',[.3 .2 .5]); axis([0 21 0 0.1]); 
%     title('直方图');
    
%     if nargout == 1 % if the histogram vector is needed
%         
%         varargout{1} = histDia;
%         
%     end

end