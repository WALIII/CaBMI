% Auto Figure generator




% Go thorugh all folders:



% load data
%   1.Load in ROI  data
load('csv_data.mat');

A = load('ave_roi.mat');
B = load('Direct_roi.mat');
roi_ave1 = A.roi_ave;
roi_ave2 = B.roi_ave;
ROIa = A.ROI;
ROIb = B.ROIS;
D = B.D;

 %   Basic Extraction of 'Hits' from .CSV file
[ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave1); %   1. Load in Y ( temporally downsampled movie) from ds_data

% Get ROI traces in a matrix, bounded by the hits
[ROIhits, ROIhits_d, ROIhits_s]= CaBMI_getROI(roi_ave1,roi_hits);


% What type of experiment?
ExpTyp =2;

% Which Figures should we generate?
figs = [3]

if ExpTyp == 1; % if 2D experiment,

  % 1: Theta for all cells,
  % 2: 'Place cell' for all cells
  % 3: Theta map
  % 4: Place map?
  % 5:




elseif ExpTyp ==2;

% 1: Plot Dir cells
% 2: Theta for all cells,
% 3: 'Place cell' for all cells
% 4:  Theta map
% 4:  Place map?
% 5:

if ismember(1,figs)
[neuron_hit, Cursor_hit] = CaIm_test_3D(D.TData);
end

close all

if ismember(2,figs)
mkdir Theta2
for i = 1: 30;
     CaBMI2D_theta(roi_ave1,roi_ave2,i);
     G = ['Cell  ',num2str(i)];
     title(G);
     saveas(gcf,['Theta2/',G,'.png']);
     clf('reset')
     close all
     pause(0.1);
end
end


close all
if ismember(3,figs)
  topCells = 50;
mkdir Im_diff2
for i = 1:topCells;
     CaBMI_occupany(roi_ave1,roi_ave2,i);
     G = ['Cell ',num2str(i)];
     pause(0.1);
     title(G);
     saveas(gcf,['Im_diff2/',G,'.png']);
     clf('reset')
     close all
     pause(0.1);
end

cd('Im_diff2')

for i = 1:topCells; CaBMI_RGB_placeCell(roi_ave1, roi_ave2,i); end
cd(pwd_here);

end






if ismember(4,figs)
  [out] = CaBMI_theta_map(roi_ave1, roi_ave2,ROIa, ROIb);
end

pwd_here = cd;
mkdir('splitMap')
cd('splitMap')
if ismember(5,figs)
t = 1:round(size(roi_ave1.C_dec,2)/3)-1:size(roi_ave1.C_dec,2);
for i = 1:size(t,2)-1
    try
R.C_dec = roi_ave1.C_dec(:,t(i):t(i+1));
R.S_dec = roi_ave1.S_dec(:,t(i):t(i+1));
R.F_dff = roi_ave1.F_dff(:,t(i):t(i+1));
    catch
       R.interp_dff =  roi_ave1.interp_dff(:,t(i):t(i+1));
    end
R2.interp_dff = roi_ave2.interp_dff(:,t(i):t(i+1));


[outB{i}] = CaBMI_theta_map(R, R2,ROIa, ROIb,'fileName',num2str(i));
clear R R2
end

clear data;
data.directed(1,:,:) = outB{1}.bins_zscore;
data.undirected(1,:,:) = outB{3}.bins_zscore;

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
ccd(ccd<.85)=.1; % Set opacity to all low mean correlation scores
B4 = (indX);
B4(ccd2<.85) = []; % Remove low values


figure();
clear data3
data3.undirected(1,:,:) = outB{1}.bins_zscore(:,B4);
data3.directed(1,:,:) = outB{3}.bins_zscore(:,B4);
[indX,B,C] = CaBMI_schnitz(data3);
title('true range, all high corr values ');

print(gcf,'-depsc','-painters','SortedCells.eps');
epsclean('SortedCells.eps'); % cleans and overwrites the input file



end
cd(pwd_here);

end
