function [private_cov, LL] = est_fa_LL_zdim0(X_train, X_test)
%1.10.15
%Description:
%Tests the cross-validated log-likelihood of the FA model with no latent variables, i.e. that each neuron's variance is private
%
%Input:
%X_train:   xDim x N_train
%X_test:    xDim x N_test

[xDim, N_train]     = size(X_train);
[xDim, N_test]      = size(X_test);

Xc_train    = cov(X_train'); %cov wants: row observation, column variable (N x xDim)

private_cov     = diag(diag(Xc_train));
MM          = inv(private_cov);

%Now use this covariance to test LL on X_test:
N           = N_test;
Xc_test     = cov(X_test');

const       = -xDim/2*log(2*pi);
ldM         = sum(log(diag(chol(MM))));
LL          = N*const + 0.5*N*logdet(MM) - 0.5*N*sum(sum(MM .* Xc_test));

%From byron yu code:
%const   = -xDim/2*log(2*pi);
%ldM     = sum(log(diag(chol(MM))));
%LLi   = N*const + N*ldM - 0.5*N*sum(sum(MM .* cX));

