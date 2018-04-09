function [VidHits, I]= CaBMI_getvid(ds_data,ds_hits);



counter = 1;
for i = 1:size(ds_hits)
    try
VidHits(:,:,:,counter) = (ds_data(:,:,ds_hits(i)-30:ds_hits(i)+30));
    counter = counter+1;
    catch
        disp(' too close to the end///');
    end
end

% disp('making time movies')
% for i = 1:size(ds_hits)
% [im1_rgb norm_max_proj,I(:,:,:,i)] = CABMI_allpxs(single(squeeze(VidHits(:,:,:,i))));
% end
I = [];