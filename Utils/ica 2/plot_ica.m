function [A] = plot_ica(ica_sig, mixing, height, width, rows, cols)
%PLOT_ICA Plot ICA results
%   Just a bunch of code to get traces and components next to each other.
%   The code uses subplots to make a nice combined figure.

% default sizing
if ~exist('rows', 'var') || isempty(rows)
    rows = 2;
end
if ~exist('cols', 'var') || isempty(cols)
    cols = 2;
end

% subplot indices
sp_components = [];
sp_traces = [];

% kludgy, but easier to reason about
% figure out subplot indices for each
for j = 1:rows
    for k = 1:(2 * cols)
        i = (j - 1) * 2 * cols + k;
        if k <= cols
            sp_components(end + 1) = i; %#ok<AGROW>
        else
            sp_traces(end + 1) = i; %#ok<AGROW>
        end
    end
end

figure;

% left side: components
for i = 1:(rows * cols)
    subplot(rows, cols * 2, sp_components(i));
    A{i} = reshape(mixing(:, i) * sign(median(mixing(:, i))), height, width);
    imagesc(reshape(mixing(:, i) * sign(median(mixing(:, i))), height, width));
    title(sprintf('Component %d', i));
end

% right side: traces
subplot(rows, cols * 2, sp_traces);
% because ICA is scale invariant, traces may be inverted
% as a result, the sign(median(mixing)) is used to get a consistent
% calcium-esque trace scaling where spikes are positive
plot_many(bsxfun(@times, ica_sig(1:(rows * cols), :)', sign(median(mixing(:, 1:(rows * cols))))));

end
