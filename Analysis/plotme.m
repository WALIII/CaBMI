function plotme(var_to_plot,col)
if nargin < 4
  font_size = 18;
end

n_epochs = size(var_to_plot{1},1)


errorbar([1:n_epochs], nanmean(var_to_plot{1}'),...
        nanstd(var_to_plot{1}')/sqrt(length(var_to_plot{1}')), 'color', ...
     col, 'LineWidth', 2);
    %std(var_to_plot{1}'), 'color', ...
      %  [30/255, 144/255, 255/255], 'LineWidth', 2);

if length(var_to_plot)>1

 hold on
 for i = 2:length(var_to_plot)
 errorbar([1:n_epochs], nanmean(var_to_plot{i}'),...
        nanstd(var_to_plot{i}')/sqrt(length(var_to_plot{i}')), 'color', ...
     col, 'LineWidth', 2);
    %std(var_to_plot{1}'), 'color', ...
      %  [30/255, 144/255, 255/255], 'LineWidth', 2);
 end
end

%
%  errorbar([1:n_epochs], nanmean(var_to_plot{2}'),...
%     nanstd(var_to_plot{2}')/sqrt(length(var_to_plot{2}')), 'color', ...
%     [60/255,179/255,113/255], 'LineWidth', 2);
%
% errorbar([1:n_epochs], nanmean(var_to_plot{3}'),...
%     nanstd(var_to_plot{3}')/sqrt(length(var_to_plot{3}')), 'color', ...
%     [255/255,165/255,0/255], 'LineWidth', 2);
%
% if length(var_to_plot) > 3
%     errorbar([1:n_epochs], nanmean(var_to_plot{4}'),...
%         nanstd(var_to_plot{4}')/sqrt(length(var_to_plot{4}')), 'k', ...
%        'LineWidth', 2);
% end

%legend({'ipsi-BMI', 'contra-BMI', 'near-BMI', 'direct-BMI'}, 'Location', 'best');
set(gca,'FontSize',18, 'box', 'off')
% xlabel('Epochs'); ylabel(var_label);
xlim([0 n_epochs+1]);

end
