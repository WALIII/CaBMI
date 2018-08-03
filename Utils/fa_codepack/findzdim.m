% findzdim
% Albert You
% 5/31/2018

% findzdim is a function that finds the optimal latent dimensions for a
% featurematrix

% inputs:
% featurematrix [matrix] - FA matrix of neural spikebins and neurons
% tolerance (double) - variance to be captured by latent factors (default
% 0.9)

% outputs:
% dim_to_use (integer) - number of dimensions that captures specified
% tolerance variance

% Note: this calculates the dimension to use for a single featurematrix
% (e.g. one target of a dataset).  May need to run this for each target,
% then take the max value among all targets.

function [dim_to_use, result] = findzdim(featurematrix, tolerance)

    if nargin == 1
        tolerance = 0.9; % threshold
        disp('default tolerance is 0.9')
    end

    [result] = calc_fa(featurematrix, size(featurematrix, 2));
    SOT_individual= result.SOT;
    SOT_over_neuron = result.SOT_over_neuron_mean;
    
    % Run this block to figure out which dimensions are optimal
    LL = result.sharedCov_mat;
    S = svd(LL);
    plot(cumsum(S)/sum(S))
    result.cumsum = cumsum(S);
    result.sum = sum(S);
    result.line = cumsum(S)/sum(S);
    
    dim_to_use= min(find(cumsum(S)/sum(S)>tolerance));
    
    clear SOT_individual
    %     clear result

end