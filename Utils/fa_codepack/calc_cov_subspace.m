function [subspaceA] = calc_cov_subspace(cov_mat)
%Calculates the subspace in which 'cov_mat' exists
    dimA = rank(sharedCov_A); 
    [u,s,v] = svd(sharedCov_A); 
    subspaceA = u(:, 1:dimA);
end
