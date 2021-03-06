function [N N2]= CaBMI2D_theta(roi_ave,roi_ave2,cell)
% Where do indirect neurons 'live' in 2D space?
% Load in the extracted direct neurons, and the indirect cells

% get the indirect cell you want, and find when it is active

stdx = 1;

try
ROI = roi_ave.S_dec(cell,:);

% if there is no deconvolved data, make it:
catch
for i = cell
    disp('Deconvolving data...');
 [c, s ] = deconvolveCa(roi_ave.interp_dff(cell,:));
end
ROI = s';
end
% figure(); plot(ROI)

[pks, locs] = findpeaks(double(ROI(:,1:end-10)),'MinPeakDistance',5,'MinPeakHeight',std(ROI)*2);

locs(locs<10) = []; % removed early peaks
% figure();
% hold on;
% plot(ROI);
% plot(c);
% plot(locs,pks,'*');


% Reconstruct the cursor


sM = 10;
TData2.cursorA = smooth((zscore(roi_ave2.interp_dff(1,:)) + zscore(roi_ave2.interp_dff(2,:)))  - (zscore(roi_ave2.interp_dff(3,:)) + zscore(roi_ave2.interp_dff(4,:))),sM)';
TData2.cursorB = smooth((zscore(roi_ave2.interp_dff(5,:)) + zscore(roi_ave2.interp_dff(6,:)))  - (zscore(roi_ave2.interp_dff(7,:)) + zscore(roi_ave2.interp_dff(8,:))),sM)';

% Fake cursor ( pick random cells as 'cursor')
% TData2.cursorA = (zscore(roi_ave.F_dff(1,:)) + zscore(roi_ave.F_dff(3,:)))  - (zscore(roi_ave.F_dff(3,:)) + zscore(roi_ave.F_dff(4,:)));
% TData2.cursorB = (zscore(roi_ave.F_dff(5,:)) + zscore(roi_ave.F_dff(6,:)))  - (zscore(roi_ave.F_dff(7,:)) + zscore(roi_ave.F_dff(8,:)));



% index into the 2D point in the direct cells, save the index
Rperm = randi(size(TData2.cursorA,2),1,size(locs,2)); % random timestamps
for i = 1:size(locs,2)

% Bin the location    
BinR(1,i) = TData2.cursorA(:,locs(i));
BinR(2,i) = -TData2.cursorB(:,locs(i));

% Randomize...
rBinR(1,i) = TData2.cursorA(:,Rperm(i));
rBinR(2,i) = -TData2.cursorB(:,Rperm(i));

% Get the angle
% u = TData2.cursorA(:,(locs(i)-1):(locs(i)+1));
% v = TData2.cursorB(:,(locs(i)-1):(locs(i)+1));
% ThetaInDegrees(:,i) = atan2d(norm(cross(u,v)),dot(u,v));

% y = [TData2.cursorA(:,(locs(i)-1)) TData2.cursorA(:,(locs(i)+1));];
% x = [TData2.cursorB(:,(locs(i)-1)) TData2.cursorB(:,(locs(i)+1))];

x1 = TData2.cursorA(:,(locs(i)-1));
y1 = TData2.cursorB(:,(locs(i)-1));

x2 = TData2.cursorA(:,(locs(i)+1));
y2 = TData2.cursorB(:,(locs(i)+1));

b(1,i) = y2-y1;
b(2,i) = x2-x1;

 a(:,i) = atan2d(y2-y1,x2-x1)+180;
%  figure(); plot(x,y);
%  axis equil
%a(:,i) = atan2d(x,y);
% a(:,i) = atan((y1-y2)./(x1-x2));
end


% if there is no a...
if exist('a') ==0
    a = 1:360;
    a = [a, randi(360)];
end

% figure();
% x = histogram(ThetaInDegrees,25)
figure(1);
subplot(1,2,1);
h2 = histogram(-a+360,12);
h2.Normalization = 'probability';

% subplot(1,2,2);
% col = jet(round(max(pks)*100));
% compass(b(2,:),b(1,:))
% hold on;
% for i = 1:size(b,2);
% h = compass(b(2,i),b(1,i));
% set(h, 'color', col(round(pks(i)*100),:));
% end

N = h2.Values;
N2 = -a+360;

