function CaBMI_Manuscript01
% CaBMI_Manuscript01.m

% Functions used to generate figures for the manuscript 'XXX' from processed ROI data
% WAL3
% d07/17/2020

% Required Repositories:
  % CaBMI: https://github.com/WALIII/CaBMI
  % Model CaBMI:

% Data Location:
  % Processed ROI Data:
  % Model Data:
  % additional Data:


%% ===== [ Figure 1 ] ===== %%

  % Figure 1g: Across day Differences:

  % FIgure 1h: Wighin day learning differences:


%% ===== [ Figure 2 ] ===== %%

  % Figure 2a-c: Changes in Variance, IND amplitude, and DIR amplitude

  % Figure 2d: Rasters from individual cells ( Example mouse/day/neurons: )

  % Figure 2e: SnakePlots ( mouse/day/neurons)
    [output_1] =  CaBMI_SequenceEmerge(ROIhits); % single use

  % Figure 2f: Task relevant Neurons
[ROIhits_z2 ROIhits_z3,ROI_index, percent_modulated] = CaBMI_topCells(ROIhits,150:250,0.8);
  % Figure 2g: Task Moulated Cells
    % variable 'percent modulated'
    [out] = CaBMI_TaskRelevantIncrease(ROIhits); % will give the %mod by the first/last ~30 hits
  % Figure 2h-i: Task Moulated Cells: SnakePlot quantification

  % Figure 2j: ROI timing

  % Figure 2k-l: ROI timing quantification


%% ===== [ Figure 3 ] ===== %%

  % Figure 3:PCA Plots

  % Figure 3: PCA Plots and quantification


%% ===== [ Figure 4 ] ===== %%

  % Figure 3b-c: Prediction Quantification


  %% ===== [ Supplimental Figure 1 ] ===== %%
