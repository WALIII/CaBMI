%%=======================================================================%%
%                   CaBMI SFN FIGURE GENERATOR                           %%
%%=======================================================================%%

% d10/01/2018-d11/01/18
% WAL3


clear all
close all


% Go thorugh all folders:
% Call FigDispatch.m to deploy to all folders...


%% load data
%   1.Load in ROI  data
load('csv_data.mat');

A = load('ave_roi.mat');
B = load('Direct_roi.mat');
roi_ave1 = A.roi_ave;
roi_ave2 = B.roi_ave;
ROIa = A.ROI;
ROIb = B.ROIS;
D = B.D;

Abase = load('Indirect_roi_map.mat');
Bbase = load('Direct_roi_map.mat');
roi_ave3 = Abase.roi_ave;
roi_ave4 = Bbase.roi_ave;

%% Basic Ectraction
 %   Basic Extraction of 'Hits' from .CSV file
[ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave1); %   1. Load in Y ( temporally downsampled movie) from ds_data

% Get ROI traces in a matrix, bounded by the hits
[ROIhits, ROIhits_d, ROIhits_s, ROIhits_z]= CaBMI_getROI(roi_ave1,roi_hits);

% Get ROI traces for DIRECT neurons...
[D_ROIhits, D_ROIhits_d, D_ROIhits_s, D_ROIhits_z]= CaBMI_getROI(roi_ave2,roi_hits);

%% User Input

% What type of experiment?
ExpTyp =1;
pwd_here = cd;

% Which Figures should we generate?
figs = [1];


%% 1D FIGURES
if ExpTyp == 1; % if 2D experiment,

if ismember(1,figs)
 out_spacetime =  CaBMI_Spatiotemporal(ROIhits, ROIa,ROIb);
cd(pwd_here);
cd('..')
if exist('DATA_spacetime')<1;
    mkdir('DATA_spacetime');
end
save(['DATA_spacetime/','SpaceTime_',datestr(datetime('now')),'.mat'],'out_spacetime')
end
cd(pwd_here);

if ismember(2,figs)
disp('plotting shuffeled schnitz');
CaBMI_SchnitzConsistancy(ROIhits)
print(gcf,'-depsc','-painters','Schnitz_hist.eps');
epsclean('Schnitz_hist.eps'); % cleans and overwrites the input file
end

if ismember(3,figs)
    % Get PCA
    mkdir('PCA');
    disp('plotting PCA...')
  [PCA_data]= CaBMI_PCA(roi_ave1,roi_hits);
%   disp('plotting jPCA...')
%  [PCAout] = jpca_analysis(roi_ave1,roi_hits);
%  CaBMI_PCA_trajectory(PCAout);

end

if ismember(4,figs) % Get within day improvement data...
% Plot change in variance and mean activity over time...
    [out.improve] = CaBMI_Improvement(D_ROIhits,ROIhits_d,ROIhits_z,roi_hits);
% Hit rate is defined by this funciton ( found in the CaBMI repo ):
    [out.hitRate] = CaBMI_HitRate(roi_ave1,roi_ave2);
end


if ismember(5,figs) % Get within day improvement data...

[out.seq_length] = CaBMI_sequence_len(ROIhits);
end


if ismember(6,figs) % Get within day improvement data...

% TO DO: Save data
cd(pwd_here);
cd('..')
if exist('DATA')<1;
    mkdir('DATA');
save(['DATA/','hitrate_',datestr(datetime('now')),'.mat'],'out')
cd(pwd_here);
end

end

if ismember(7,figs);
    [dim_explained] = CaBMI_FA(ROIhits_z,roi_ave1);
    % TO DO: Save data
cd(pwd_here);
cd('..')
if exist('DATA_dim')<1;
    mkdir('DATA_dim');
end
save(['DATA_dim/','DimData_',datestr(datetime('now')),'.mat'],'dim_explained')
end
cd(pwd_here);




if ismember(8,figs);
    [PCA_hits]= CaBMI_PCA(roi_ave1,roi_hits);
[out_con] = CaBMI_PCA_consistancy(PCA_hits);
    % TO DO: Save data
cd(pwd_here);
cd('..')
if exist('DATA_con')<1;
    mkdir('DATA_con');
end
save(['DATA_con/','ConData_',datestr(datetime('now')),'.mat'],'out_con')
cd(pwd_here);
end




%% 2D Figures
elseif ExpTyp ==2;% if 2D experiment,

% 1: Plot Dir cells
% 2: Theta for all cells,
% 3: 'Place cell' for all cells
% 4:  Theta map
% 4:  Place map?
% 5:


% Generate real and basline cursor:
TData2.cursorA = (zscore(roi_ave2.interp_dff(1,:)) + zscore(roi_ave2.interp_dff(2,:)))  - (zscore(roi_ave2.interp_dff(3,:)) + zscore(roi_ave2.interp_dff(4,:)));
TData2.cursorB = (zscore(roi_ave2.interp_dff(5,:)) + zscore(roi_ave2.interp_dff(6,:)))  - (zscore(roi_ave2.interp_dff(7,:)) + zscore(roi_ave2.interp_dff(8,:)));
TData4.cursorA = (zscore(roi_ave4.interp_dff(1,:)) + zscore(roi_ave4.interp_dff(2,:)))  - (zscore(roi_ave4.interp_dff(3,:)) + zscore(roi_ave4.interp_dff(4,:)));
TData4.cursorB = (zscore(roi_ave4.interp_dff(5,:)) + zscore(roi_ave4.interp_dff(6,:)))  - (zscore(roi_ave4.interp_dff(7,:)) + zscore(roi_ave4.interp_dff(8,:)));


if ismember(1,figs)
[neuron_hit, Cursor_hit] = CaIm_test_3D(D.TData);
CaBMI_cursorOccupancy(TData2,TData4);
[out_3D] = CaBMI_3D_plot(Cursor_hit);

% Save figure

cd(pwd_here);
cd('..')
if exist('DATA_3Dplot')<1;
    mkdir('DATA_3Dplot');
end
save(['DATA_3Dplot/','3Dplot_',datestr(datetime('now')),'.mat'],'out_3D')
cd(pwd_here);

end




if ismember(2,figs)
mkdir Theta2
for i = 1: 300;
     CaBMI2D_theta(roi_ave1,roi_ave2,i);
     G = ['Cell  ',num2str(i)];
     title(G);
print(gcf,'-depsc','-painters',['Theta2/',G,'.eps']);
epsclean(['Theta2/',G,'.eps']); % cleans and overwrites the input file

     clf('reset')
     close all
     pause(0.01);
end
end


if ismember(3,figs)
  topCells = 50;
mkdir Im_diff2
% for i = 1:topCells;
%      CaBMI_occupany(roi_ave1,roi_ave2,i);
%      G = ['Cell ',num2str(i)];
%      pause(0.1);
%      title(G);
%      saveas(gcf,['Im_diff2/',G,'.png']);
%      clf('reset')
%      close all
%      pause(0.1);
% end

cd('Im_diff2')

for i = 1:topCells; CaBMI_RGB_placeCell(roi_ave1, roi_ave2,roi_ave3, roi_ave4,i); end
cd(pwd_here);

end







if ismember(4,figs)
  [out_map{1}] = CaBMI_theta_map(roi_ave1, roi_ave2,ROIa, ROIb);
end

pwd_here = cd;
mkdir('splitMap')

if ismember(5,figs)
    cd('splitMap')
      [out_map{1}] = CaBMI_theta_map(roi_ave1, roi_ave2,ROIa, ROIb);

    % Baseline map:


   try
R.C_dec = roi_ave3.C_dec(:,:);
R.S_dec = roi_ave3.S_dec(:,:);
R.F_dff = roi_ave3.F_dff(:,:);
    catch
       R.interp_dff =  roi_ave3.interp_dff(:,:);
    end
R2.interp_dff = roi_ave4.interp_dff(:,:);
[out_map{2}] = CaBMI_theta_map(R, R2,ROIa, ROIb,'fileName',num2str(0101));
clear R R2


t = 1:round(size(roi_ave1.C_dec,2)/2)-1:size(roi_ave1.C_dec,2);
for i = 1:size(t,2)-1
    try
R.C_dec = roi_ave1.C_dec(:,t(i):t(i+1));
R.S_dec = roi_ave1.S_dec(:,t(i):t(i+1));
R.F_dff = roi_ave1.F_dff(:,t(i):t(i+1));
    catch
       R.interp_dff =  roi_ave1.interp_dff(:,t(i):t(i+1));
    end
R2.interp_dff = roi_ave2.interp_dff(:,t(i):t(i+1));


[out_map{i+2}] = CaBMI_theta_map(R, R2,ROIa, ROIb,'fileName',num2str(i));
clear R R2
end

clear data;
data.directed(1,:,:) = out_map{2}.bins_zscore;
data.undirected(1,:,:) = out_map{3}.bins_zscore;

figure(); [indX,B,C] = CaBMI_schnitz(data);

% plot only the high vals

for i = 1:size(B,1);
    cb(:,1) = (B(i,:))';
    cb(:,2) = (C(i,:))';
r = corr(cb);
rk(:,i) = r(1,2);
end

% fale alpha = ccd = ones(1,size(B1,2))'; % alpha valu
 ccd = mat2gray(rk);
[a,b] = max(B'); % this will be the max of the image matrix ( use b)

% ccd = 1-round(mat2gray(c),1);
ccd2 = ccd;
ccd(ccd<.80)=.1; % Set opacity to all low mean correlation scores
B4 = (indX);
B4(ccd2<.80) = []; % Remove low values


figure();
clear data3
data3.undirected(1,:,:) = out_map{2}.bins_zscore(:,B4);
data3.directed(1,:,:) = out_map{3}.bins_zscore(:,B4);
[indX,B,C] = CaBMI_schnitz(data3);
title('true range, all high corr values ');

print(gcf,'-depsc','-painters','SortedCells.eps');
epsclean('SortedCells.eps'); % cleans and overwrites the input file


figure();  hold on; for i = 1:2; h1 = histogram(out_map{i}.theta,12);
h1.Normalization = 'probability'; end

figure();
h1 = polarhistogram((out_map{1}.theta.*(pi/180)),12,'FaceColor','r');
h1.DisplayStyle = 'stairs';
h1.Normalization = 'probability';


print(gcf,'-depsc','-painters','orientation_true.eps');
epsclean('orientation_true.eps'); % cleans and overwrites the input file
figure();
h1 = polarhistogram((out_map{2}.theta.*(pi/180)),12,'FaceColor','b');
h1.DisplayStyle = 'stairs';
h1.Normalization = 'probability';
print(gcf,'-depsc','-painters','orientation_base.eps');
epsclean('orientation_base.eps'); % cleans and overwrites the input file


end
cd(pwd_here);

end


%% EXTRA

% To plot from aggregate data:
% GetDataScrap % run in folter with mat files!
