function [smooth_ROIhits] = CaBMI_SmoothHits(ROIhits,kernSize);

 w = gausswin(kernSize);
    disp(['Smoothing hits with a kernal of size ',num2str(kernSize)]);
for i = 1: size(ROIhits,1)
    for ii = 1:size(ROIhits,3)
    
    smooth_ROIhits(i,:,ii) = filter(w,1,ROIhits(i,:,ii));
    end
%disp(['Trial ',num2str(i),' of ', num2str(size(ROIhits,1))]);
end