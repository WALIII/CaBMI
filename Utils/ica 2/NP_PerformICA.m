function [ica_sig, mixing, separating, height, width] = NP_PerformICA(frames, varargin)
%NP_PERFORMICA Perform indepdent component analysis
%   This function performs independent component analysis on a video. It
%   will first resize the video to a more managable size (by default, 1/4
%   the width and height). It then unfurls the video and uses the FastICA
%   algorithm. The FastICA algorithm will reduce the dimensionality using
%   principal component alaysis to get a lower dimensional space (default
%   100 dimensions) and will then extract independent components (by
%   default, the first 25).
%
%   Mostly this function serves as a nice wrapper around the FastICA
%   algorithm, handling video resizing and unrolling.

% parameters
resize_factor = 4;
eig_components = 100;
ica_components = 20;

% load custom parameters
nparams=length(varargin);
if 0 < mod(nparams, 2)
	error('Parameters must be specified as parameter/value pairs');
end
for i = 1:2:nparams
    nm = lower(varargin{i});
    if ~exist(nm, 'var')
        error('Invalid parameter: %s.', nm);
    end
    eval([nm ' = varargin{i+1};']);
end

% check parameters
if ica_components > eig_components
    error('There must be more PCA components than ICA components.');
end

% turn into movie data
if isstruct(frames)
    video_gs = cat(3, frames(:).cdata);
else
    video_gs = frames;
end

% convert to single
video_gs = im2single(video_gs);

% resize
video_gs = imresize(video_gs, 1 / resize_factor);
height = size(video_gs, 1);
width = size(video_gs, 2);

% unroll (each row corresponds to a pixel, each column corresponds to a
% time step)
data = reshape(video_gs, [], size(video_gs, 3));

% perform pca
[ica_sig, mixing, separating] = fastica(data, 'lastEig', eig_components, 'numOfIC', ica_components);

end
