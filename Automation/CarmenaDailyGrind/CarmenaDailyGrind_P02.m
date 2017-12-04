function CarmenaDailyGrind_P02(DIR)




  % CarmenaDailyGrind.m  Run all subroutenes
  % CarmenaDailyGrind_P01 % Pull data from 2P computer
  % CarmenaDailyGrind_P02 % Basic video alignment and data integrity check
  % CarmenaDailyGrind_P03 % Automatic ROI extraction and alignment with cursors

  % AR_DataTransfer

  % Transfer Data from Multiphoton Computer every evening at midnight, and run
  % analysis on the aquired DATA

  %   Created: 2017/12/01
  %   By: WALIII
  %   Updated: 2017/12/01
  %   By: WALIII



  % Format:

  % C:\Data\Imaging Data\d120117\trial01\(*DATA* + *LOGS* + *SYNC*)

  % Now, a .m file with:
  %    1. Video processing offsets
  %    2. E1 and E2 cell ( cursor)
  %    3. Triggers matrix ( frame triggers, )
  %    4. ...

% Get all folders
cd(DIR);
files = dir(DIR);
  dirFlags = [files.isdir];
  % Extract only those that are directories.
  subFolders = files(dirFlags);


for i = 3:size(subFolders)

  % index into folder
  cd(DIR);
  cd(subFolders(i).name);





%% Perform Motion Correction on all frames
Y = single(I(:,:,:));% convert to single precision
T = size(Y,ndims(Y));

% Motion Correction Params:
options_rigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'bin_width',200,'max_shift',15,'us_fac',50,'init_batch',200);

%options_nonrigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'grid_size',[32,32],'mot_uf',4,'bin_width',200,'max_shift',15,'max_dev',3,'us_fac',50,'init_batch',200);

% perform motion correction
%tic; [M2,shifts2,template2,options_nonrigid] = normcorre_batch(Y,options_nonrigid); toc
tic; [M2,shifts2,template2,options_rigid] = normcorre(Y,options_rigid); toc
% compute metrics

M.nnY = quantile(Y(:),0.005);
M.mmY = quantile(Y(:),0.995);
[M.cM2,M.mM2,M.vM2] = motion_metrics(M2,10);

clear I;
I = M2;

mov_data =  convn(I(:,:,1:end), single(reshape([1 1 1] / 5, 1, 1, [])), 'same'); % Smooth data:


figure();% Display movie:
for i = 1:size(mov_data,3)
imagesc(mov_data(:,:,i));
pause(0.01);
end



[M.cY,M.mY,M.vY] = motion_metrics(I,10);

%% Take local cross-corr
disp('Performing Local Cross-correlation...')
[data.ccimage]=CrossCorrImage(mov_data(:,:,10:end));
data.Mov = I;
data.M = M;
%% Save Data
mkdir('mat');
cd('mat');

save('processed_data','data','-v7.3');
cd(DIR);


end
