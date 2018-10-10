function CaBMI_RGB_placeCell(roi_ave1, roi_ave2,cells);

t = 1:round(size(roi_ave1.C_dec,2)/3)-1:size(roi_ave1.C_dec,2);
for i = 1:size(t,2)-1
    try
R.C_dec = roi_ave1.C_dec(:,t(i):t(i+1));
R.S_dec = roi_ave1.S_dec(:,t(i):t(i+1));
R.F_dff = roi_ave1.F_dff(:,t(i):t(i+1));
    catch
       R.interp_dff =  roi_ave1.interp_dff(:,t(i):t(i+1));
    end
R2.interp_dff = roi_ave2.interp_dff(:,t(i):t(i+1));

G(:,:,i) =  CaBMI_occupany(R,R2,cells);
%[outB{i}] = CaBMI_theta_map(R, R2,ROIa, ROIb,'fileName',num2str(i));
end
% G(:,:,3) = G(:,:,2);

close all;
pause(0.1);

figure(); imshow(G);

saveFileName = ['RGBplace_',num2str(cells),'.eps'];

print(gcf,'-depsc','-painters',saveFileName);
epsclean(saveFileName); % cleans and overwrites the input file



