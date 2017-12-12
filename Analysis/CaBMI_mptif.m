function CaBMI_mptif

mkdir('Mtiff_folder');
  % motion correction;
  mov_listing=dir('*.tif');
  mov_listing={mov_listing(:).name};

  num_frames = (numel(mov_listing));

  disp('Loading in Tiffs to RAM');

G = 1:1999:num_frames; G = [G,num_frames]

for i = 1:(size(G,2)-1) % number of Tiffs

  counter = 1;

  tic
  for ii = G(i):G(i+1)
  I(:,:,counter) = loadtiff(mov_listing{ii});
  counter = counter+1;
  end
  toc

  filename = ['Mtiff_folder\Data_',num2str(i),'.tif'];
  disp('Saving data...');


saveastiff(I,filename);
clear I
end
