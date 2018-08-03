function [result] = calc_fa(X, zDim)
%2.15.16
%DESCRIPTION:
%Takes in a data matrix and zDim
%Computes FA
%Returns some basic analyses using FA model
%INPUT:
%X - data mat
%neural_analyze_idxs - the idxs of neurons included in X
%zDim - the latent dimensionality

%[result] = est_fa_zDim(X, neural_analyze_idxs, num_folds, max_dim)

%FA:
[estParams, LL] = fastfa(X, zDim); %X: num_var x num_samples

%Unpack result:
[result] = ...
    unpack_fa_result(estParams, LL, zDim);

end

function [result] = ...
    unpack_fa_result(estParams, LL, zDim)
    
sharedCov_mat           = estParams.L*estParams.L';
sharedCov               = diag(estParams.L*estParams.L');
privateCov              = estParams.Ph;
totalCov                = sharedCov+privateCov;

SOT_over_neuron         = sharedCov./totalCov;
SOT                     = sum(sharedCov)/sum(totalCov);
%equivalent to trace(sharedCov_mat)/trace(totalCov_mat)
%where totalCov_mat = diag(privateCov) + sharedCov_mat

%%
%ASSIGN:
result.zDim             = zDim;
result.estParams        = estParams;
result.LL               = LL;
result.sharedCov_mat    = sharedCov_mat;
result.sharedCov        = sharedCov;
result.privateCov       = privateCov;

result.SOT                      = SOT;
result.SOT_over_neuron          = SOT_over_neuron;
result.SOT_over_neuron_mean     = mean(SOT_over_neuron);

end