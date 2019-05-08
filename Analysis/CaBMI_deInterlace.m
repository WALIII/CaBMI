function out = CaBMI_deInterlace(f2)


counter = 1;
for i = 1:(size(f2,3)-1)
GG(:,:,counter) = f2(:,:,i);
counter = counter+1;
GG(:,:,counter) = f2(:,:,i);
counter = counter+1;
end
out = imresize(GG,[240 320]);