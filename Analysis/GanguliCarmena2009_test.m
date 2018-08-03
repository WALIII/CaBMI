function GanguliCarmena2009_test(kin_data,neural_data,cell)

% find nearest point
V = kin_data.kin_ts;
N = neural_data.spikes_cell{cell}';
SM2 = 5; % number of drawn rand distributions...




% Plot the Density of the Cursor:

h=fspecial('gaussian',10,10);
xb = kin_data.kin_values(:,1);
xa = kin_data.kin_values(:,2);
[val, cent] = hist3([xa(:) xb(:)],[100 100]);
val=imfilter(val,h,'circular','replicate');

figure();
imagesc(cent{2}([1 end]),cent{1}([1 end]),val);




counter = 1;

for ii = 1:SM2;
    Rperm = randi(size(V,2),1,size(N,2)); % random timestamps

for i = 1:size(N,2);
    
if ii ==1;
[minDistance, indexOfMin(:,i)] = min(abs(V-N(i)));

P1(1,i) = kin_data.kin_values_ts(indexOfMin(:,i),1);
P1(2,i) = kin_data.kin_values_ts(indexOfMin(:,i),2);

R1{ii}(1,i) = kin_data.kin_values_ts(Rperm(:,i),1);
R1{ii}(2,i) = kin_data.kin_values_ts(Rperm(:,i),2);

% Get angle:
try % In case spikes are on edges...
x1 = kin_data.kin_values_ts(indexOfMin(:,i)-1,1);
y1 = kin_data.kin_values_ts(indexOfMin(:,i)-1,2);

x2 = kin_data.kin_values_ts(indexOfMin(:,i)+2,1);
y2 = kin_data.kin_values_ts(indexOfMin(:,i)+2,2);

b(1,counter) = y2-y1;
b(2,counter) = x2-x1;

 a(:,counter) = atan2d(y2-y1,x2-x1)+180;
%  figure(); plot(x,y);
%  axis equil
% a(:,counter) = atan2d(x,y);
% a(:,counter) = atan((y1-y2)./(x1-x2));
counter = counter+1;
catch
end

else
R1{ii}(1,i) = kin_data.kin_values_ts(Rperm(:,i),1);
R1{ii}(2,i) = kin_data.kin_values_ts(Rperm(:,i),2);
end
end
end

figure(); plot(P1(1,:),P1(2,:),'*');
ylim([2 5]);



Sz = 200;
filt = 15;
% Real Dist
h=fspecial('gaussian',filt,filt);
y = P1(1,:);
x = P1(2,:);

[values, centers] = hist3([x(:) y(:)],[Sz Sz]);
values2=imfilter(values,h,'circular','replicate');

indexb = 0:.1:5;
indexa = -1.5:.1:2.5;
%  ylim([2 5]);
%  xlim([-1 2.5]);

% Plot Actual 
figure()
image(indexa,indexb,zeros(Sz,Sz));

hold on; 
imagesc(centers{2}([1 end]),centers{1}([1 end]),values2);
hold on
colormap(gray);
hold off

IMa = getframe(); % Get zoomed portion that is visible.
IM1 = double(squeeze(IMa.cdata(:,:,1)));




% Null Dist
for i = 1:SM2
h=fspecial('gaussian',filt,filt);
y2 = R1{i}(1,:);
x2 = R1{i}(2,:);
[valuesB, centers2] = hist3([x2(:) y2(:)],[Sz Sz]);
valuesB2=imfilter(valuesB,h,'circular','replicate');

% Generage figure
figure();
image(indexa,indexb,zeros(Sz,Sz));
hold on; 
imagesc(centers2{2}([1 end]),centers2{1}([1 end]),valuesB2);
hold on
colormap(gray);
hold off

IMb = getframe(); % Get zoomed portion that is visible.
IM2_temp(:,:,i) = double(squeeze(IMb.cdata(:,:,1)));
end
IM2 = mean(IM2_temp,3);


close all

figure();

subplot(2,3,[1 2 4 5]);
X = IM1-IM2;
X(X<0) = 0;

% filter out artifacts...
filt = 20;
h=fspecial('gaussian',filt,filt);
X=imfilter(X,h,'circular','replicate');

% imagesc(indexa,indexa,zeros(100,100));
hold on; 
image(indexa,indexb,zeros(Sz,Sz));
imagesc(centers{2}([1 end]),centers{1}([1 end]),X);
colormap('jet');
ylim([2 5]);
xlim([-1 2.5]);
 
 
 
 % Get Angle
subplot(2,3,3);
h2 = histogram(-a+360,15);
h2.Normalization = 'probability';


subplot(2,3,6);
% col = jet(round(max(pks)*100));
compass(b(2,:),b(1,:))
% hold on;
% for i = 1:size(b,2);
% h = compass(b(2,i),b(1,i));
% set(h, 'color', col(round(pks(i)*100),:));
% end

