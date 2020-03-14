function ica_sig = NP_ApplyICA(frames, separating, height, width)
%NP_APPLYICA Apply ICA separating matrix to video
%   Like the NP_PerformICA, this resizes and unrolls the videos, but simply
%   applies an existing separating matrix to extract the components.

% turn into movie data
if isstruct(frames)
    video_gs = cat(3, frames(:).cdata);
else
    video_gs = frames;
end

% convert to single
video_gs = im2single(video_gs);

% resize
video_gs = imresize(video_gs, [height width]);

% unroll (each row corresponds to a pixel, each column corresponds to a
% time step)
data = reshape(video_gs, [], size(video_gs, 3));

% use separating matrix to perform unmixing
ica_sig = separating * data;

end

