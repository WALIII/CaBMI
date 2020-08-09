function [out,hits]=  CaBMI_PCA_rotational(ROIhits_z,roi_ave1,roi_hits)
% best so far: load('d031218_M00q.mat')  load('d031418_M00q.mat')

% use best cells
[~,~,ROI_index] = CaBMI_topCells(ROIhits_z,[150:250],0.8);

% do PCA
roi2use.F_dff = roi_ave1.S_dec(ROI_index,:);

[PCA_data]= CaBMI_PCA(roi2use,roi_hits);

% JPCA
hits = PCA_data.jPCA_hits;
pc1 = squeeze(PCA_data.jPCA_hits(:,:,1));
pc2 = squeeze(PCA_data.jPCA_hits(:,:,2));

% % PCA
% hits = PCA_data.PCA_hits;
% pc1 = squeeze(PCA_data.PCA_hits(:,:,1));
% pc2 = squeeze(PCA_data.PCA_hits(:,:,2));


% remove mean
pc1 = (pc1'-mean(pc1'))';
pc2 = (pc2'-mean(pc2'))';

sz = size(pc1,1);
col = jet(sz);
figure();
hold on;
counter = 1;
for i = 1:sz-1;
%     a1 = mean(pc1((i:i+1),400:550));
%     a2 = mean(pc2((i:i+1),400:550));
      a1 = (pc1((i),400:550));
    a2 = (pc2((i),400:550));
plot(a1,a2,'color',col(counter,:),'LineWidth',1);
counter = counter+1;
arrow([a1(end-2) a2(end-2)],[a1(end) a2(end)],'FaceColor',col(counter,:))

out.pc1(:,i) = a1;
out.pc2(:,i) = a2;
%pause();
end


figure(); 
hold on;
intr = 5;
mtp = floor(sz/intr);
for i = 1:mtp;
    if i < round(mtp/2);
        col = 'b';
    else
        col = 'r';
    end
    a = mean(pc1(1+intr*(i-1):intr+intr*(i-1),470:550))';
    b = mean(pc2(1+intr*(i-1):intr+intr*(i-1),470:550))';
% a = (a-min(a));
% b = (b-min(b));

    plot(a,b,'color',col,'LineWidth',1);
    plot(a(50),b(50),'k*');
    arrow([a(end-2) b(end-2)],[a(end) b(end)],'FaceColor',col)
    
    a2save(:,i) = a;
    b2save(:,i) = b;
%pause();
end

figure(); imagesc(flipud(corr(a2save)));  colorbar();
figure(); plot(mean(flipud(corr(a2save))));