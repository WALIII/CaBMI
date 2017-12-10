function CaBMI_mptif

  % motion correction;
  mov_listing=dir('*.tif');
  mov_listing={mov_listing(:).name};

  num_frames = (numel(mov_listing));

  disp('Loading in Tiffs to RAM');

G = 1:2000:num_frames; G = [G,num_frames]

for i = 1:(size(G)-1) % number of Tiffs

  counter = 1;

  tic
  for iii = G(i):G(i+1)
  I(:,:,counter) = loadtiff(mov_listing{ii});
  end
  toc

  filename = ['Data_',num2str(i)];
  disp('Saving data...');


saveastiff(I,filename);
clear I
end
