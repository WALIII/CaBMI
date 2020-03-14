%% LOAD VIDEO

% loading

%% CALCULATE ICA

% use nice wrapper to handle resizing and unrolling video
[ica_sig, mixing, separating, height, width] = NP_PerformICA(SG2_all);

%% APPLY TO ORIGINAL VIDEO

% plot
plot_ica(ica_sig, mixing, height, width);

%% APPLY TO NEW VIDEO


% the actual ICA part:
% use separating matrix to perform saming unmixing
ica_sig2 = NP_ApplyICA(SG2_all, separating, height, width);

% plot
plot_ica(ica_sig2, mixing, height, width);
