
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
mkdir Im_diff
for i = 219:300;
     CaBMI_occupany(roi_ave,roi_ave2,i);
     G = ['Cell ',num2str(i)];
     title(G);
     saveas(gcf,['IM_diff/',G,'.png']);
     clf('reset')
end



% Get the phase
CaBMI2D_theta(roi_ave,roi_ave2,cell)


% Make a Quiver Plot with the data:
CaBMI_quiver(TData);


% TO DO: some spike triggered averaing, or correlation:
scrap129(TData);



%%%%% BATCH FILES! %%%%%%%


close all
mkdir Theta

for i = 1: 300;
     CaBMI2D_theta(roi_ave,roi_ave2,i);
     G = ['Cell  ',num2str(i)];
     title(G);
     saveas(gcf,['Theta/',G,'.png']);
     clf('reset')
end

%%% Ganguli ephys
mkdir Ganguli
% Unsorted data
for i = 1:512
    try
GanguliCarmena2009_test(kin_data,neural_data,i);
     G = ['Cell  ',num2str(i)];
     title(G);
     saveas(gcf,['Ganguli/',G,'.png']);
     clf('reset')
    catch
    end
    
end




