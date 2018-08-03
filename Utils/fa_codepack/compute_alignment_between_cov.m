function [frac_covA_in_subspaceB, frac_covB_in_subspaceA] = ...
    compute_alignment_between_cov(covA, covB)
%computes the fraction of shared covariance A captured in shared covariance
%B's subspace, and vice versa
    subspaceA = calc_cov_subspace(covA);
    subspaceB = calc_cov_subspace(covB);
    
    %frac_covA_in_subspaceB
    [frac_covA_in_subspaceB] = ...
        frac_var_in_subspace(covA, subspaceB);
    
    %frac_covB_in_subspaceA
    [frac_covB_in_subspaceA] = ...
        frac_var_in_subspace(covB, subspaceA);    
end


