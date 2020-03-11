function out = CaBMI_GraphPlot_Adjacency(ROIhits_z,roi_ave1,MODE);
 
% % cov matrix of data:



RANGE = [100:300];
[a b] = max(squeeze(mean(ROIhits_z(:,RANGE,:),1)));
SNR = .6;
ag = 10; % avereage over how many hits

% Spontanious Corr:
if MODE ==1;
counter = 1;
for i = 1: 10;
    tm = randi(50000,1);
    TS = tm:tm+200;
GG = corr(roi_ave1.F_dff(:,TS)');


GG = abs(GG);
GG(GG<SNR) = 0;
%  G = digraph(GG, 'OmitSelfLoops');
   G{i} = graph(GG,'upper', 'OmitSelfLoops');
   counter = counter+1;

end



else

 for i = 1:10  
GG = corr(squeeze(mean(ROIhits_z(1+((i-1)*ag):ag+((i-1)*ag),RANGE,:),1)));

GG = abs(GG);
GG(GG<SNR) = 0;
%  G = digraph(GG, 'OmitSelfLoops');
   G{i} = graph(GG,'upper', 'OmitSelfLoops');
   clear GG
 end
end




%    figure(); imagesc(GG);
%  figure();
%  plot(G)
 
 

  

 figure();
 for i = 1:10;
 colormap jet
deg = degree(G{i});
nSizes = 0.5*sqrt(deg-min(deg)+0.2);

LWidths = 200* mat2gray(G{i}.Edges.Weight/max(G{i}.Edges.Weight));

%nColors = deg;
nColors = b;
% subplot(2,5,i);
tic
h = plot(G{i},'MarkerSize',nSizes,'NodeCData',nColors,'EdgeAlpha',0.2,'EdgeCData',LWidths)
colorbar();
toc

pause(0.5);
 end
 
 
%  
%  
%  for i = 1:9;
%      if i ==1;
% GGG = addedge(G{1},G{2}.Edges.EndNodes(:,1)+500,G{2}.Edges.EndNodes(:,2)+500,G{2}.Edges.Weight);
%      else
%          GGG = addedge(GGG,G{1+i}.Edges.EndNodes(:,1)+500*i,G{1+i}.Edges.EndNodes(:,2)+500*i,G{1+i}.Edges.Weight);
%      end
%  end
%        figure();
%  colormap hsv
% deg = degree(GGG);
% nSizes = 0.5*sqrt(deg-min(deg)+0.2);
% nColors = deg;
% h = plot(GGG,'MarkerSize',nSizes,'NodeCData',nColors,'EdgeAlpha',0.1)
%    

        
out.adj = adjacency(G{1});

