function CaBMI_mptif



final_folder = 'Processed\Mtiff_folder2';
mkdir(final_folder);
  % motion correction;
  mov_listing=dir('*.tif');
  mov_listing={mov_listing(:).name};

  num_frames = (numel(mov_listing));

  disp('Loading in Tiffs to RAM');

G = 1:2000:num_frames; G = [G,num_frames];

for i = 1:(size(G,2)-1) % number of Tiffs

  counter = 1;

  for ii = G(i):(G(i+1)-1)
  I(:,:,counter) = loadtiff(mov_listing{ii});
  counter = counter+1;
  end
try
  filename = [final_folder,'\Data_',num2str(i.','%03d'),'.tif'];
  disp('Saving data...');

saveastiff(I,filename);
catch
    disp('file already exists')
end


clear I
end
