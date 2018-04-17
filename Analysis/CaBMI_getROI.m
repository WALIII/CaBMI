function [ROIhits, ROIhits_d, ROIhits_s]= CaBMI_getROI(roi_ave,roi_hits);
% CaBMI_getROI.m

% wal3
% d03.19.18


  for i = 1:size(roi_hits)
      try
ROIhits(i,:,:) = (roi_ave.F_dff(:,roi_hits(i)-200:roi_hits(i)+200))';
ROIhits_d(i,:,:) = (roi_ave.C_dec(:,roi_hits(i)-200:roi_hits(i)+200))';
ROIhits_s(i,:,:) = (roi_ave.S_dec(:,roi_hits(i)-200:roi_hits(i)+200))';
      catch
          disp(' one hit is too close to the end...');
      end
  end

  
  for i = 1:size(ROIhits_s,1)
for ii = 1:size(ROIhits_s,3)
ROIhits_s(i,:,ii) =  smooth(ROIhits_s(i,:,ii), 10);
end
  end

  

  