function [result] = frac_var_in_subspace(cov_mat, subspace_mat)
%3.18.15
%DESCRIPTION
%Computes the fraction of variance in the data (with covariance matrix
%cov_mat) that lives in the subspace spanned by 'subspace_mat'.  Note:
%subspace_mat must have orthonormal columns
%
%CALCULATION:
% X - data matrix, m - number of observations
%cov_mat = 1/m*X*X'
% Y = subspace_mat'*X = projected data
% 1/m*Y*Y' = cov mat of projected data
% = 1/m*subspace_mat'*X*X'*subspace_mat
% tr(1/m*Y*Y') = var of data projected in subspace
% = tr(1/m*subspace_mat'*X*X'*subspace_mat)
% = tr(subspace_mat*subspace_mat'*cov_mat)

result.var_in_subspace = trace(subspace_mat*subspace_mat'*cov_mat);
result.total_var       = trace(cov_mat);
result.frac_var        = var_in_subspace/total_var;