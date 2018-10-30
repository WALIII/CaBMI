function CaBMI_RGB_placeCell(roi_ave1, roi_ave2,roi_ave3,roi_ave4,cells);

% roi_ave1 = indirect cells
% roi_ave2 = direct cells
% roi_ave3 = baseline data ( indirect)
% roi_ave4 = baseline data ( direct)

% Baseline


   try
R.C_dec = roi_ave3.C_dec(:,:);
R.S_dec = roi_ave3.S_dec(:,:);
R.F_dff = roi_ave3.F_dff(:,:);
    catch
       R.interp_dff =  roi_ave2.interp_dff(:,:);
    end
R2.interp_dff = roi_ave4.interp_dff(:,:);
G(:,:,1) =  CaBMI_occupany(R,R2,cells);
clear R R2



t = 1:round(size(roi_ave1.C_dec,2)/2)-1:size(roi_ave1.C_dec,2);
for i = 1:size(t,2)-1
    try
R.C_dec = roi_ave1.C_dec(:,t(i):t(i+1));
R.S_dec = roi_ave1.S_dec(:,t(i):t(i+1));
R.F_dff = roi_ave1.F_dff(:,t(i):t(i+1));
    catch
       R.interp_dff =  roi_ave1.interp_dff(:,t(i):t(i+1));
    end
R2.interp_dff = roi_ave2.interp_dff(:,t(i):t(i+1));

G(:,:,i+1) =  CaBMI_occupany(R,R2,cells);
%[outB{i}] = CaBMI_theta_map(R, R2,ROIa, ROIb,'fileName',num2str(i));
end
% G(:,:,3) = G(:,:,2);

close all;
pause(0.1);

figure(); imshow(G);

saveFileName = ['RGBplace_',num2str(cells),'.eps'];

print(gcf,'-depsc','-painters',saveFileName);
epsclean(saveFileName); % cleans and overwrites the input file



