function [VidHits, I]= CaBMI_getvid(ds_data,ds_hits);




for i = 1:size(ds_hits)
VidHits(:,:,:,i) = (ds_data(:,:,ds_hits(i)-7:ds_hits(i)+7));
end

disp('making time movies')
for i = 1:size(ds_hits)
[im1_rgb norm_max_proj,I(:,:,:,i)] = CABMI_allpxs(single(squeeze(VidHits(:,:,:,i))));
end
