function [result] = est_fa_zDim(X, neural_analyze_idxs, num_folds, max_dim)
%11.26.14   
%DESCRIPTION:
%Estimates the maximum likelihood latent dimensionality for data matrix X.
%Divides X into a train and test set.  
%INPUT:
%X - num_neurons x num_trials
%neural_analyze_idxs - idxs of the neurons analyzed, just so it can be
%stored with the results
num_neurons     = size(X,1);
num_trials      = size(X,2);
train_frac = .7; %Use 'train_frac' of trials to train, the remaining % to test
%sadtler et al. used 0.75 to train, 0.25 to test

num_train   = ceil(train_frac*num_trials);

%Train & Test Matrices:
%num_folds = 4;
train_over_folds    = cell(num_folds, 1);
test_over_folds     = cell(num_folds, 1);

for fold_idx    = 1:num_folds 
    
    while(1)
        train_idxs   = sort(randi([1 num_trials], num_train,1));
        all_trials  = 1:num_trials;
        test_idxs    = all_trials(~ismember(all_trials, train_idxs));    

        %Data Matrices:
        train_over_folds{fold_idx} = ...
            X(:, train_idxs);
        test_over_folds{fold_idx} = ...
            X(:, test_idxs); 
        
        if(rank(train_over_folds{fold_idx}) == num_neurons)
            break;
        end
    end
end

% Run FA on Train Data:
fa_over_folds_dim  = repmat(struct(...
    'estParams', [], ...
    'test_LL', []), [num_folds max_dim]); 

test_LL_over_folds_dim = zeros(num_folds, max_dim);

for dim = 1:max_dim
    for fold_idx = 1:num_folds
%         disp(['Estimating dim: ' num2str(dim) ' fold: ' num2str(fold_idx)]);
        %Fit Parameters on Train Data
        train_mat   = train_over_folds{fold_idx};
        %train_mat
        params = ...
            fastfa(train_mat, dim); 
        
        fa_over_folds_dim(fold_idx, dim).estParams = ...
            params;
        
        %Test Parameters on Test Data:
        [Z, LL] = fastfa_estep(test_over_folds{fold_idx}, params);
        fa_over_folds_dim(fold_idx, dim).test_LL = ...     
            LL;
        test_LL_over_folds_dim(fold_idx, dim) = ...
            LL;
        
    end
end

fa_over_folds_dim0  = repmat(struct(...
    'estParams', [], ...
    'test_LL', []), [num_folds 1]);

test_LL_over_folds_dim0     = zeros(num_folds,1);

for fold_idx = 1:num_folds
%     disp(['Estimating LL zdim0 fold: ' num2str(fold_idx)]);
    %Fit Parameters on Train Data
    train_mat   = train_over_folds{fold_idx};
    test_mat    = test_over_folds{fold_idx};
    
    [private_cov, test_LL] = est_fa_LL_zdim0(train_mat, test_mat);
    
    fa_over_folds_dim0(fold_idx).estParams  = private_cov;
    fa_over_folds_dim0(fold_idx).test_LL    = test_LL;
    
    test_LL_over_folds_dim0(fold_idx)       = test_LL;
end
    

    
%% ASSIGN:

avg_test_LL     = mean(test_LL_over_folds_dim, 1);
sem_LL          = std(test_LL_over_folds_dim, 0, 1)/sqrt(num_folds);
[LL_max, est_dim]     = max(avg_test_LL, [], 2);

result.neural_analyze_idxs = ...
    neural_analyze_idxs;
result.fa_over_folds_dim = ...
    fa_over_folds_dim;
result.max_dim  = ...
    max_dim;
result.test_LL_over_folds_dim = ...
    test_LL_over_folds_dim;
result.avg_test_LL = ...
    avg_test_LL;
result.sem_LL = ...
    sem_LL;
result.max_LL = ...
    LL_max;
result.est_dim = ...
    est_dim;
result.fa_over_folds_dim0 = ...
    fa_over_folds_dim0;
result.test_LL_over_folds_dim0 = ...
    test_LL_over_folds_dim0;
result.test_LL_over_folds_dim_plus0 = ...
    [test_LL_over_folds_dim0 test_LL_over_folds_dim];
