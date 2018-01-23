function dff2 = CaBMI_Batch_Dff



  filt_rad=3; % gauss filter radius
  filt_alpha=3; % gauss filter alpha
  lims=3; % contrast prctile limits (i.e. clipping limits lims 1-lims)
  cmap=colormap('jet');
  per=4; % baseline percentile (0 for min)
  counter = 1;

  mat_dir='DFF_MOVIES';
  counter = 1;

  if exist(mat_dir,'dir') rmdir(mat_dir,'s'); end
  mkdir(mat_dir);


  outlier_flag=0;
  if nargin<1 | isempty(DIR), DIR=pwd; end
  mov_listing=dir(fullfile(DIR,'*.mat'));
  mov_listing={mov_listing(:).name};
  filenames=mov_listing;


  disp('Creating Dff movies');

  [nblanks formatstring]=fb_progressbar(100);
  fprintf(1,['Progress:  ' blanks(nblanks)]);

  for i=1:length(mov_listing)
  clear video;
  clear NormIm;
  clear dff2;
  clear dff;
  clear mov_data3;
  clear mov_data2;
  clear mov_data;

      [path,file,ext]=fileparts(filenames{i});
  	fprintf(1,formatstring,round((i/length(mov_listing))*100));
    save_filename=[ fullfile(mat_dir,file) ];



  load(fullfile(DIR,mov_listing{i}),'video');
counter = 1;

  for frameIter = 5:(size(video.frames,2))-5;

     mov_data(:,:,counter) = uint16(video.frames(counter).cdata);
     counter = counter+1;
  end


mov_data = convn(mov_data, single(reshape([1 1 1] / 3, 1, 1, [])), 'same'); % smooth data

test = single(mov_data(:,:,1:end));
[rows,columns,frames]=size(test);





disp('Gaussian filtering the movie data...');

h=fspecial('gaussian',filt_rad,filt_alpha);
test=imfilter(test,h,'circular','replicate');

disp(['Converting to df/f using the ' num2str(per) ' percentile for the baseline...']);

baseline=repmat(prctile(test,per,3),[1 1 frames]);

h=fspecial('gaussian',10,10);
baseline = imfilter(baseline,h,'circular','replicate'); % filter baseline

dff2 = (test.^2-baseline.^2)./baseline;

h=fspecial('disk',2);
dff2=imfilter(dff2,h); %Clean up
% baseline2=mean(tot,3);
% for iii=1:size(tot,3)
%   dff2 =  tot(:,:,iii)./baseline2.*100;
% end





H = prctile(max(max(dff2(:,:,:))),80);
L = prctile(mean(max(dff2(:,:,:))),3);

    clim = [double(L) double(H)];

NormIm(:,:,:) = mat2gray(dff2, clim);



%figure(1); for  iii = 7:size(NormIm,3);  IM(:,:) = NormIm(:,:,iii); imagesc(IM); pause(0.05); end



%% Write VIDEO


v = VideoWriter(save_filename);
v.Quality = 30;
v.FrameRate = 30;

open(v)


for ii = 2:size(NormIm,3);
figure(1);
colormap(gray);
IM(:,:) = NormIm(:,:,ii);
writeVideo(v,IM)
imagesc(IM);
end
close(v)


imwrite(std(NormIm,[],3),strcat(save_filename,'.png'));


end


%% Save Data from aggregate
% Test = TotalX2;
%mov_data = video.frames;
%im_resize = 1;

%save(save_filename,'Test','mov_data','im_resize','-v7.3')
