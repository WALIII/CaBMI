function CaBMI_mptif

  % motion correction;
  mov_listing=dir('*.tif');
  mov_listing={mov_listing(:).name};

  num_frames = (numel(mov_listing));

  disp('Loading in Tiffs to RAM');

  tic
  for ii = 1:num_frames;
  I(:,:,ii) = loadtiff(mov_listing{ii});
  end
  toc
  
  disp('Saving data...');
  tic
saveastiff(I,'All_Data.tif');
toc
  