function plot_many(x, ys, clrs, labels)
%PLOT_MANY Plot multiple lines
%   All lines (one per column of ys) are plotted, spaced out equally and
%   consistently normalized. This is useful for comparing time synchronized
%   spike or region traces.
%
%   Arguments:
%
%   x - The x coordinates shared by all lines (vector).
%
%   ys - Matrix of lines or traces to plot, with each column corresponding
%        to a line.
%
%   cls - (Optional.) The colors to use for each line (matrix). If there
%         are more lines than colors, then the colors will be cycled
%         through in order.
%
%   labels - (Optional.) Labels for each line (cell). Provide an empty
%            vector to skip printing labels, otherwise provide a cell array
%            with the same number of entries as there are columns in ys.

% support single argument
if nargin == 1
    ys = x;
    x = 1:size(ys, 1);
end

% number of lines to plot
y_count = size(ys, 2);

% default colors
if ~exist('clrs', 'var') || isempty(clrs)
    clrs = lines(y_count); % make colorful lines
end
clr_count = size(clrs, 1);

% default labels
if ~exist('labels', 'var')
    labels = cell(1, y_count);
    for i = 1:y_count
        labels{i} = num2str(i);
    end
end

% check variables
if size(ys, 1) ~= length(x)
    error('The length of vector x (%d) must match the number of rows in matrix ys (%d).', length(x), size(ys, 1));
end
if 3 ~= size(clrs, 2)
    error('The color matrix must have three columns (found %d).', size(clrs, 2));
end
if ~isempty(labels) && length(labels) ~= y_count
    error('The length of the labels cell array (%d) must match the number of columns in matrix ys (%d).', length(labels), y_count);
end

% normalize lines
mn = min(ys, [], 1);
mx = max(ys, [], 1);
ys = bsxfun(@minus, ys, mn);
ys = bsxfun(@rdivide, ys, max(mx - mn));

% plot
xlim([x(1) x(end)]);
ylim([0 y_count]);
xlabel('Time (s)');
if isempty(labels)
    % no labels
    set(gca, 'YTick', []);
else
    set(gca, 'YTick', 0.5:1:(y_count - 0.5), 'YTickLabel', labels(end:-1:1));
end
hold on;
for i = 1:y_count
    % get line
    y = ys(:, i);
    plot(x, y_count - i + y, 'Color', clrs(1 + mod(i - 1, clr_count), :));
end
hold off;

end

