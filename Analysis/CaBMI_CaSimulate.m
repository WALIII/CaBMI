function [roi_ave_test] = CaBMI_CaSimulate


% make null distribution, to demonstrate cell motor place fields
numCell = 100;
t = 0 ;
cursor = 0;
for i = 1:numCell;
cell{i} = 0;
end
startSpot = 0;
interv = 100 ; % considering 1000 samples
step = 0.1 ; % lowering step has a number of cycles and then acquire more data
for i = 1:numCell;
    adn{i} = 0;
end

for step = 1:600;
    
    for i = 1:numCell
    update{i} = rand(1); 
    if update{i}>0.995; 
        spk{i} = 1;
        adn{i} = (randi(8))+2;
        update{i} = update{i}/5 +adn{i};
    else
        spk{i} = 0;
        update{i} = update{i}/5+adn{i};
    if adn{i}>0;
        adn{i} = adn{i} -0.05;
    else
        adn{i} = 0;
    end
    end;
    
    end
    
    livecursor = (update{1}+update{2}) - (update{3}+update{4});
    
    cursor = [cursor, livecursor];
  
    for i = 1:numCell;
        cellF(i,step) = update{i};
        cell_s(i,step) = spk{i};
    end

end
cellF2 = cellF;
    for i = 1:numCell;
        cellF(i,:) = zscore(smooth(cellF(i,:),20));
    end

    
    
    % Display Fake Cursor:
    figure(); plot((cellF(1,:)+cellF(2,:))-(cellF(3,:)+cellF(4,:)));
    title('plot the cursor');
    
    C1 = (cellF(1,:)+cellF(2,:))-(cellF(3,:)+cellF(4,:));
    C2 = (cellF(5,:)+cellF(6,:))-(cellF(7,:)+cellF(8,:));
    
    figure(); plot(C1,C2)
    title('plot the 2D trajectory');
    
    % plot 2D histogram of random cells:
    
    roi_ave_test.S_dec = cell_s(9:numCell,:);
    roi_ave2_test.interp_dff = cellF(1:8,:);
    cell2use = 1;
    
    close all
    
  %  CaBMI_occupany(roi_ave_test,roi_ave2_test,cell2use)
    
    
    % Make a fake movie
    
    s1 = 500;
    s2 = 500;
    for i = 1: 100;   
        cellloc(1,i) = randi(500);
        cellloc(2,i) = randi(500);
        radius(1,i) = 5+randi(20);
    end
    
filt = 35;

h=fspecial('gaussian',filt,filt);
        
    for i = 1:500;
        % initialize frame
    X = zeros(s1,s2);
        % place cells
        for ii = 1:50;
           
            x1 = cellloc(1,ii);
            y1 = cellloc(2,ii);
            

            [xx,yy] = ndgrid((1:s1)-y1,(1:s2)-x1);
            mask = (xx.^2 + yy.^2)<radius(1,ii)^2;
            activity = cellF2(ii,i)-(radius(1,ii)/max(radius))*2; % weight by radius
            activity(activity<0) = 0;
            X(mask) = activity;

        end
        
        disp(['smoothing frame',num2str(i)]);
        X=imfilter(X,h,'circular','replicate');
X2(:,:,i) = X;
    end
    
    disp('smoothing matrix')
    A_wnoise = 3*randn(size(X2));
    figure();
    m = min(min(min(X2)));
    ma = max(max(max(X2)));
    for i = 1:500;
        imagesc(X2(:,:,i)-A_wnoise(:,:,i),[0 8])
         norm_data(:,:,i) = (X2(:,:,i) - m)./  (ma - m);

    end
    
%     N = norm_data*255;
    
    