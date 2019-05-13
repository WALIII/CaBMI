function CaBMI_raster_plot(ROIhits_s,ROIhits_z)



    [x,y,z] = size(ROIhits_s);

    
    
% startT = 1
% stopT = 10
% Determine the best neurons
ga = 1:2:size(ROIhits_z,1);
gb = 2:2:size(ROIhits_z,1);
for i = 1: size(ROIhits_z,3);
    cX = zscore(smooth(mean(ROIhits_s(ga,100:350,i)),10));
    cY = zscore(smooth(mean(ROIhits_s(gb,100:350,i)),10));
    [rho(:,i),pval(:,i)] = corr(cX,cY);
end
figure(); histogram(rho);

IN = find(rho>0.5);


figure();
% interesting neuron 
%IN = [967 138 589 455 180 968 370 807 181 403 313 141 853 165 167 467 524 166 645 480 214 452 302 479 539 227 995 984 949 600 531 891 294 108 186 783 775 755  642 600 579 262 302 318 388 494];
for i = 1:size(IN,2)
        
SPKs = squeeze(ROIhits_s(end-100:end,:,IN(i)))'; 
%figure(); imagesc(SPKs'); 
[~, srt(i)] = max(smooth(mean(squeeze(ROIhits_z(end-50:end,150:350,IN(i))),1),20)); 
%SPKs = flipud(SPKs);
spk1 = mat2gray(SPKs(:));
G = find(spk1>.1);
[xx{i}, yy{i}] = rasterplot(G,x,y);

end

[as bs] = sort(srt);

figure(); 
map = lines(size(IN,2));
hold on;
for i = 1:size(IN,2);
    if i ==1;
    plot(xx{bs(i)},yy{bs(i)},'Color',map(i,:),'LineWidth',2)
    else
    plot(xx{bs(i)},yy{bs(i)}+(max(yy{2})*(i-1)),'Color',map(i,:),'LineWidth',2)
    end
end
set(gca,'Ydir','reverse')


