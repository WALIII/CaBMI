function CaBMI_Prediction_Plot(); 
% Plot predition data from Lily

% TO DO: Add in the data through UI

    data2 = readNPY('dat2.npy');
    d = readNPY('delayNeg60to60_perf_20190318.npy'); % npy data
     
     
    smth = 2; % Smoothing Factor
    col = jet(21); % colormap
    
    d(61,:) = []; % to remove NaNs... at the hit..

  
    
    figure(); 
hold on;

    for ii = 1:20;
    % Lint data...
   data = squeeze(data2(ii,:,[1 2 3 4 6 7 ])); 

   data(61,:) = []; % to remove NaNs... at the hit..
  
   % Smooth data
    for i = 1:size(data,2);
        data(:,i) = smooth(data(:,i),smth);
    end
  
    c2 = d(:,5)';
    data = data(:,:)';
    

    
L = size(data,2);
se = std(data)/sqrt(length(data));
mn = mean(data);

hold on; 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(ii,:,:)); alpha(1);
plot(mn,'Color',col(ii,:));

data = data';
% Calculate CI
for i = 1:size(c2,1);
    
x = data(i,:)';
SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([0.025  0.975],length(x)-1);      % T-Score
CI(i,:) = mean(x) + ts*SEM;                      % Confidence Intervals
end


hold on; 
plot(CI(:,1),'k');
plot(CI(:,2),'k');
plot(c2,'r', 'linewidth',3)

    end

x=[60 60];
y=[-.3 1];
plot(x,y,'k--')


ii = 5

figure(); 

   data = squeeze(data2(:,:,5)); 
   data3 = squeeze(data2(:,:,1)); 
       data(:,61) = []; % to remove NaNs... at the hit..
       data3(:,61) = []; % to remove NaNs... at the hit..
   data = mat2gray(zscore(data,[],2));
   data3 = mat2gray(zscore(data3,[],2));

   
   c2 = smooth(c2,1);
   
    
L = size(data,2);
se = std(data);
mn = mean(data);

hold on; 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(ii,:,:)); alpha(0.2);
plot(mn,'Color',col(ii,:));

ii = ii+5
% data 3
L = size(data3,2);
se = std(data3);
mn = mean(data3);

hold on; 
h = fill([1:L L:-1:1],[mn-se fliplr(mn+se)],col(ii,:,:)); alpha(0.2);
plot(mn,'Color',col(ii,:));



plot(mat2gray(zscore(c2)),'b', 'linewidth',3)
   

x=[60 60];
y=[0 1];
plot(x,y,'k--')

title('Cursor Prediction vs IND Prediction ');
xlabel('Frames ( 30fps)');
ylabel('Norm. Prediction');


