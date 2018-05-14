function [B1 C1 D1 ] = CaIm_test_(ROI,TData);


 % Hits
A = zscore((TData.hit(1,1:end-1)))';
A(A<0)=0;
figure(); plot(A);


%A = zscore(diff(smooth(TData.ROI_dff(1,:),8)));


B = zscore(TData.ROI_dff(1,:));
C = zscore(TData.ROI_dff(2,:));
D = zscore(TData.ROI_dff(3,:));
E = zscore(TData.ROI_dff(4,:));



[pks, locs] = findpeaks(double(A),'MinPeakDistance',10,'MinPeakHeight',std(A)*2);

figure();
hold on;
plot(A);  

plot(B); 
plot(C); 
plot(-(D)); 
plot(-(E)); 


B = B- median(B);
C = C- median(C);
D = D- median(D);
E = E- median(E);

plot(locs,pks,'*');

figure();
hold on;
plot(A);  


plot(B-10,'r'); 
plot(C-10,'m'); 
plot((D-10),'b'); 
plot((E)-10,'c'); 


plot(((B+C)-(D+E)),'LineWidth',2);
plot(TData.cursor_actual-5)
plot(locs,pks,'*');



figure();
hold on; 
for i = 1:size(locs,1);
    try
        B1(:,i) = B(1,locs(i)-50:locs(i)+50);
        C1(:,i) = C(1,locs(i)-50:locs(i)+50);
        D1(:,i) = D(1,locs(i)-50:locs(i)+50);
        E1(:,i) = E(1,locs(i)-50:locs(i)+50);
    plot(B1(:,i),'r');
    plot(E1(:,i),'m');
    plot(C1(:,i),'b');
    plot(D1(:,i),'c');
    
    catch
        disp('catching...');
    end
    
end


figure();
hold on; 
plot(mean(B1'),'r');
plot(mean(E1'),'m');
plot(mean(C1'),'b');
plot(mean(D1'),'c');

figure();
subplot(1,4,1)
imagesc(B1');
subplot(1,4,2)
imagesc(C1');
subplot(1,4,3)
imagesc(D1');
subplot(1,4,4)
imagesc(E1');



% Plot SEM
dataM(:,:,1) = B1;
dataM(:,:,2) = C1;
dataM(:,:,3) = D1;
dataM(:,:,4) = E1;
col = hsv(size(dataM,3));
counter = 1;
shift = 1;


figure(); 
hold on;

for i = 1:size(dataM,3);
    data = squeeze(dataM(:,:,i))';
    
L = size(data,2);
se = std(data)/sqrt(length(data));
mn = mean(data)+counter*shift;


h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(i,:)); alpha(0.5);
plot(mn,'Color',col(i,:));
    
end


