function [neuron_hit, Cursor_hit] = CaIm_test_3D(TData);


 % Hits
A = zscore((TData.hit(1,1:end-1)))';
A(A<0)=0;
% figure(); plot(A);


%A = zscore(diff(smooth(TData.ROI_dff(1,:),8)));

for i = 1:8
neuron(i,:) = zscore(TData.ROI_dff(i,:));
neuron(i,:) = neuron(i,:)- median(neuron(i,:));
end

Cursor(1,:) = TData.cursorA;
Cursor(2,:) = TData.cursorB;



[pks, locs] = findpeaks(double(A),'MinPeakDistance',10,'MinPeakHeight',std(A)*2);

% figure();
% hold on;
% plot(A);  
% for i = 1:8
% plot(neuron(i,:)+ i*3);
% [c(i,:), s ] = deconvolveCa(neuron(i,:));
% end

% 
% figure();
% hold on;
% plot(A);  
% for i = 1:8
% plot(c(i,:)+ i*3); 
% end
% 
% 
% plot(locs,pks,'*');
% 
% figure();
% hold on;
% plot(A);  
% 
% for i = 1:4
% plot(neuron(i,:)-10,'r');
% end
%  
% 
% plot(((B+C)-(D+E)),'LineWidth',2);
% plot(zscore(TData.cursorA))
% plot(zscore(TData.cursorB))
% plot(locs,pks,'*');



% figure();
hold on; 
for i = 1:size(locs,1);
    try
    for ii = 1:8       
        neuron_hit(i,:,ii) = smooth(neuron(ii,locs(i)-50:locs(i)+50),3);
    end
            Cursor_hit(i,:,1) = Cursor(1,locs(i)-50:locs(i)+50);
        Cursor_hit(i,:,2) = Cursor(2,locs(i)-50:locs(i)+50);
    catch
        disp('catching...');
    end
     
end


% figure();
% hold on; 
% for i = 1:8
% plot(mean(neuron_hit(i,:)'),'r');
% end
% 
% 
% figure();
% for i = 1:4
% subplot(1,4,i)
% imagesc(neuron_hit(:,:,i));
% end
% title('E1 cells');
% 
% figure(); 
% counter = 1;
% for i = 5:8
% subplot(1,4,counter)
% imagesc(neuron_hit(:,:,i));
% counter = counter+1;
% end
% title('E2 cells');
% 
% 



% Plot SEM

dataM = neuron_hit;



counter = 1;
shift = 1;
    col = hsv(20);


figure(); 
counter2 = 1;
hold on;
title('E2 group');
for i = 1:size(dataM,3);
    data = squeeze(dataM(:,:,i));
    
L = size(data,2);
se = std(data)/sqrt(length(data));
mn = mean(data)+counter*shift;

if   counter2 == 3  || counter2 == 7
col = flipud(col);
end

h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
counter2 = counter2+1;

    
end



% figure(); 


GX = corr(squeeze(mean(neuron_hit(3:size(neuron_hit,1),30:60,:),1)));





 
GX2 = corr(TData.ROI_dff(:,1:1000)');
GX1 = corr(TData.ROI_dff(:,15000:end)');
 GX3 = GX1-GX2;

GX = corr(squeeze(mean(neuron_hit(3:size(neuron_hit,1),30:60,:),1)));

%  imagesc(GX); colorbar();
%  title('correlation around the hit of all 8 cells');
 
 
%  figure(); 
%  myColorMap =[1 0 0
%     1 0 0
%     0 0 1
%     0 0 1
%     0 0 1
%     0 0 1
%     1 0 0
%     1 0 0];
% 
%  circularGraph(GX.^2,'Colormap',myColorMap);
%  


