
function [out] = CaBMI_theta_map(roi_ave, roi_ave2,ROIa, ROIb,varargin);

%plot a nice map of where the cells are, based on their theta value

% roi_ave = indirect cells
% roi_ave2 = direct cells
addendum = num2str(0);
% Manual inputs
vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'fileName') % manually inputing a sort order
    addendum=vin{i+1};
    man =1;
  elseif isequal(vin{i},'ri')
    ri=vin{i+1};
  end
end
  

try
for i = 1:size(roi_ave.F_dff,1)
[N(:,i) N2{i}]= CaBMI2D_theta(roi_ave,roi_ave2,i);
end
catch
    roi_ave.F_dff = roi_ave.interp_dff;
for i = 1:size(roi_ave.F_dff,1)
[N(:,i) N2{i}] = CaBMI2D_theta(roi_ave,roi_ave2,i);
end
end
for i = 1:size(roi_ave.F_dff,1)
 ff = smooth(N(:,i),2);
%  f=fit((1:size(s,1))',s,'poly9');
%  ff = f(1:size(N,1));
 [a b(:,i)] = max(ff);


 c(:,i) =  a-min(ff);
 S(:,i) = zscore(ff);
end

hbins = size(N,1);

ccd = 1-round(mat2gray(c),1);
ccd(ccd<.75)=.10;
col = hsv(hbins);
figure(); hold on;
% imagesc(flip(ROI_1.reference_image));
% colormap(gray);
hold on;

for i = 1:size(roi_ave.F_dff,1)
col1 = cat(2,col(b(i),:),ccd(i));
plot(ROIa.coordinates{i}(:,1),ROIa.coordinates{i}(:,2),'LineWidth',1,'Color',col1);
end
colormap(hsv)
colorbar;


hold on;
for i = 1:8;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color','k');
end

% Save figure

saveFileName = ['ROI_Theta_Map',addendum,'.eps'];

print(gcf,'-depsc','-painters',saveFileName);
epsclean(saveFileName); % cleans and overwrites the input file



figure();

hold on;
col2 = {'g','g','r','r','c','c','b','b'};
for i = 1:8;
    plot(ROIb.coordinates{i}(:,1),ROIb.coordinates{i}(:,2),'LineWidth',1,'Color',col2{i});
end

% Save figure
print(gcf,'-depsc','-painters','ROI_Theta_Map_DirCells.eps');
epsclean('ROI_Theta_Map_DirCells.eps'); % cleans and overwrites the input file

xlim([0 500]);
ylim([0 500]);
b= round((b/hbins)*360);
out.theta = b; % the angle
out.alpha = ccd;
out.bins = N; % bins for each cell
out.bins_zscore = S;
out.histogram = N2;
out.color = ccd;
