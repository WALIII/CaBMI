function [cov_topKdim, subspace_topKdim] = compute_cov_in_topKdim(cov_mat, k)

[u,s,v] = svd(cov_mat); 
subspace_topKdim = u(:, 1:k); 
cov_topKdim = ...
	subspace_topKdim * s(1:k, 1:k) * subspace_topKdim';

end