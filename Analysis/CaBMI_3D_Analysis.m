
%==========================%
%     CaBMI_3D_Analysis    %
%==========================%



% Get direct neuron ROI location file from the aquisition file

% Here are some basic scripts to see what we have:
[neuron_hit, Cursor_hit] = CaIm_test_3D(TData);



% Get the 'baseline' direct neuron data by running the following in
% The MAP folder:

roi_aveB = CaBMI_plot_roi(ROI);


% Next, make a place-holder TData2:

TData2.cursorA = (zscore(roi_aveB.interp_dff(1,:)) + zscore(roi_aveB.interp_dff(3,:)))  - (zscore(roi_aveB.interp_dff(3,:)) + zscore(roi_aveB.interp_dff(4,:)));
TData2.cursorB = (zscore(roi_aveB.interp_dff(5,:)) + zscore(roi_aveB.interp_dff(6,:)))  - (zscore(roi_aveB.interp_dff(7,:)) + zscore(roi_aveB.interp_dff(8,:)));


% run both to compare the Direct neurons before and after BMI:

[IM2]= CaBMI_MakeHeatplot(TData2);
[IM]= CaBMI_MakeHeatplot(TData);


% To compare these two images, try this:
CaBMI_3D_compare(IM,IM2);

% Where do indirect neurons 'live' in 2D space?
% Load in the extracted direct neurons, and the indirect cells

roi_ave2 = CaBMI_plot_roi(ROI); % run in 'MAIN' folder


% get the indirect cell you want, and find when it is active


% Try it out on the first cell:
cell = 1;
CaBMI_occupany(roi_ave,roi_ave2,cell);


% Loop to check through a bunch of cells:
close all
for i = 41:101;
    CaBMI_occupany(roi_ave,roi_ave2,i);
    pause();
    clf
end


% Loop to check through a bunch of cells:

close all
mkdir Im_diff2
for i = 1:300;
     CaBMI_occupany(roi_ave1,roi_ave2,i);
     G = ['Cell ',num2str(i)];
     title(G);
     saveas(gcf,['IM_diff2/',G,'.png']);
     clf('reset')
     close
end



% Get the phase
CaBMI2D_theta(roi_ave,roi_ave2,cell)


% Make a Quiver Plot with the data:
CaBMI_quiver(TData);


% TO DO: some spike triggered averaing, or correlation:
scrap129(TData);



%%%%% BATCH FILES! %%%%%%%


close all
mkdir Theta2

for i = 1: 30;
     CaBMI2D_theta(roi_ave,roi_ave2,i);
     G = ['Cell  ',num2str(i)];
     title(G);
     saveas(gcf,['Theta2/',G,'.png']);
     clf('reset')
     close
end

%%% Ganguli ephys
% mkdir Ganguli
% % Unsorted data
% for i = 1:512
%     try
% GanguliCarmena2009_test(kin_data,neural_data,i);
%      G = ['Cell  ',num2str(i)];
%      title(G);
%      saveas(gcf,['Ganguli/',G,'.png']);
%      clf('reset')
%     catch
%     end
%
% end




%%%%
% Split a 3D map into 2 seperate maps:
%load('/Volumes/DATA_01/LIBERTI_DATA/Processed/2D_BMI/d050618/theta/M010_theta_main.mat')
% found in: CaBMI_schnitz_format_thetamap
t = 1:20000:54000;
for i = 1:size(t,2)-1
    try
R.C_dec = roi_ave1.C_dec(:,t(i):t(i+1));
R.S_dec = roi_ave1.S_dec(:,t(i):t(i+1));
R.F_dff = roi_ave1.F_dff(:,t(i):t(i+1));
    catch
       R.interp_dff =  roi_ave1.interp_dff(:,t(i):t(i+1));
    end
R2.interp_dff = roi_ave2.interp_dff(:,t(i):t(i+1));

[out{i}] = CaBMI_theta_map(R, R2,ROI1, ROI2);
clear R R2
end

data.directed(1,:,:) = out{1}.bins_zscore;
data.undirected(1,:,:) = out{2}.bins_zscore;
figure(); CaBMI_schnitz(data)
