function CaBMI_TaskRelevancy(ROIhits_z,ROIhits_s,D_ROIhits_z,varargin)
% See how the task relavancy of the netwrok changes over time


threshplot = 0;
sorting = 1:size(ROIhits_s,1);
nparams=length(varargin);
SaveFile =0;
UIin =0;
if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'sort'
			sorting=varargin{i+1};
            disp('sorting based on input');
        case 'thresh'
			xtrue=varargin{i+1};
            threshplot = 1;
        case 'uiin'
            UIin=varargin{i+1};
    end
end

if SaveFile ==1;
    % make directory
mkdir SparseCells
end
% Sort by the 'task re;evant cells- most active at the hit.)
range = 190:250;
n1_range = 1:150;
n1_range = 350:400;
clear a b b2 a2

Hitrange_2 = round((size(ROIhits_z,1)/2)-(size(ROIhits_z,1)/4)): round(size(ROIhits_z,1)/2)+(size(ROIhits_z,1)/4);
Hitrange_3 =  round((size(ROIhits_z,1))-(size(ROIhits_z,1)/4)): (size(ROIhits_z,1));

size(ROIhits_z);
% Early
 a = abs(max(mean(ROIhits_z(1:10,range,:),1)) - min(mean(ROIhits_z(1:10,range,:),1)));
 b = abs(max(mean(ROIhits_z(1:10,n1_range,:),1)) - min(mean(ROIhits_z(1:10,n1_range,:),1)));
 
 aD = abs(max(mean(D_ROIhits_z(1:10,range,:),1)) - min(mean(D_ROIhits_z(1:10,range,:),1)));
 bD = abs(max(mean(D_ROIhits_z(1:10,n1_range,:),1)) - min(mean(D_ROIhits_z(1:10,n1_range,:),1)));
% Mid
 a2 = abs(max(mean(ROIhits_z(Hitrange_2 ,range,:),1)) - min(mean(ROIhits_z(Hitrange_2 ,range,:),1)));
 b2 = abs(max(mean(ROIhits_z(Hitrange_2 ,n1_range,:),1)) - min(mean(ROIhits_z(Hitrange_2 ,n1_range,:),1)));
 a2D = abs(max(mean(D_ROIhits_z(Hitrange_2 ,range,:),1)) - min(mean(D_ROIhits_z(Hitrange_2 ,range,:),1)));
 b2D = abs(max(mean(D_ROIhits_z(Hitrange_2 ,n1_range,:),1)) - min(mean(D_ROIhits_z(Hitrange_2 ,n1_range,:),1)));
% Late
 a3 = abs(max(mean(ROIhits_z(Hitrange_3 ,range,:),1)) - min(mean(ROIhits_z(Hitrange_3,range,:),1)));
 b3 = abs(max(mean(ROIhits_z(Hitrange_3 ,n1_range,:),1)) - min(mean(ROIhits_z(Hitrange_3,n1_range,:),1)));
 a3D = abs(max(mean(D_ROIhits_z(Hitrange_3 ,range,:),1)) - min(mean(D_ROIhits_z(Hitrange_3,range,:),1)));
 b3D = abs(max(mean(D_ROIhits_z(Hitrange_3 ,n1_range,:),1)) - min(mean(D_ROIhits_z(Hitrange_3,n1_range,:),1)));
 
 
 figure();
 for ii = 1:2;
 subplot(1,2,ii)
 hold on;

 h1 = histogram(a./b,100);
 h2 = histogram(a2./b2,100);
 h3 = histogram(a3./b3,100);
h1.Normalization = 'probability';
h1.BinWidth = 0.5;
h1.FaceColor = 'r';

h2.Normalization = 'probability';
h2.BinWidth = 0.5;
h2.FaceColor = 'g';

h3.Normalization = 'probability';
h3.FaceColor = 'b';
h3.BinWidth = 0.5;

plot([1 1],[0 0.03],'--','LineWidth',1) 
title(' Modulation Ratio  (RGB = early, mid, late)');
% Plot lines for Direct units
Dd = aD./bD;
D3d = a3D./b3D;
col = ['r','r','g','g'];
%early
for i = 1:4;
plot([Dd(:,i) Dd(:,i)],[0 0.03],'Color',col(i),'LineWidth',1) 
end
% late
for i = 1:4;
plot([D3d(:,i) D3d(:,i)],[0 0.03],'Color',col(i),'LineWidth',2) 
end

if ii ==2
 set(gca,'xscale','log');
end
end


hit_interval = 1:15:size(ROIhits_z,1);
for i = 1: size(hit_interval,2)-1;
    
int = [hit_interval(i):hit_interval(i+1)];

 at = abs(max(mean(ROIhits_z(int,range,:),1)) - min(mean(ROIhits_z(int,range,:),1)));
 bt = abs(max(mean(ROIhits_z(int,n1_range,:),1)) - min(mean(ROIhits_z(int,n1_range,:),1)));
 hit_dist(:,i) = at-bt;
 clear at bt
end


figure(); 
y = skewness(hit_dist);
hh2 = std(hit_dist,[],1)/2;
errorbar(y,hh2);


% Find the most consistant hits:



figure(); 
for i = 1:size(ROIhits_s,3);  
    GG(:,i) = abs( max((smooth(mean(ROIhits_s(:,150:300,i)),10)))- min((smooth(mean(ROIhits_s(:,:,i)),10))));
end

[ax bx] = sort(GG,'descend');
[ay by] = sort(GG,'ascend');


multiplot = 1;
if multiplot ==1;
figure();  

for i = 1:size(ROIhits_s,3); 
%     map = brewermap(100,'YlOrRd');
% map(1,:) = [1 1 1]; % optionally force first color to white
map = (gray);
colormap(flipud(map));
    clf;
  bFig(1) = subplot(10,1,1:2);
hold on
    plot(smooth(mean(ROIhits_s(sorting(:),1:400,bx(i))),10),'r')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
    %plot(smooth(mean(ROIhits_s(sorting(30:50),:,bx(i))),10),'g')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
    %plot(smooth(mean(ROIhits_s(sorting(60:80),:,bx(i))),10),'b')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
  bFig(2) = subplot(10,1,3:10); 
    imagesc(ROIhits_s(sorting,1:400,bx(i))); 
hold on; line([203 203], [0 size(sorting,2)],'LineStyle','--');
    linkaxes(bFig,'x'); 
        title(['Neuron number:  ', num2str(bx(i))]);
        if threshplot ==1;
            hold on;
            scatter1 = scatter(xtrue(sorting),1:size(ROIhits_s,1),'b.');
            scatter1.MarkerFaceAlpha = .2;
            scatter1.MarkerEdgeAlpha = .2;
        end
        
                 pause();
        if SaveFile ==1;
            if UIin ==1
                if i ==1;
                    mkdir 'SparseCells/TaskMod'
                    mkdir 'SparseCells/NotMod'
                end
        prompt = 'Do you want more? Y/N [Y]: ';
                str = input(prompt,'s');
                    if isempty(str)
                         str = 'N';
                    end
                    if str == 't';
                folder = 'SparseCells/TaskMod';
                disp('Task Modulated Cell IDd');
                        else
                 folder = 'SparseCells/NotMod';
                        end
               
            else
                folder = 'SparseCells';
            end
            
            
print(gcf,'-depsc','-painters',[folder,'/',['Neuron number:  ', num2str(bx(i))],'.eps']);
epsclean([folder,'/',['Neuron number:  ', num2str(bx(i))],'.eps']); % cleans and overwrites the input file
        end
            
    
end;
end


if multiplot ==2;

% Align to Second threshold point!
for i = 1:size(ROIhits_s,1)
    startcut = xtrue(i)-200;
uuu = squeeze(ROIhits_s(i,startcut:end,:));
uu2 = zeros(size(ROIhits_s,3),startcut)'-.00;
ff = cat(1,uuu,uu2);

EndAlignedHIts(i,:,:)  = ff;
clear startcut uu2 ff
end

figure();  

for i = 1:size(ROIhits_s,3); 
%     map = brewermap(100,'YlOrRd');
% map(1,:) = [1 1 1]; % optionally force first color to white
map = flipud(gray);
colormap(map);
    clf;
  bFig(1) = subplot(10,1,1:2);
hold on
    plot(smooth(mean(EndAlignedHIts(sorting(:),:,bx(i))),10),'r')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
    %plot(smooth(mean(ROIhits_s(sorting(30:50),:,bx(i))),10),'g')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
    %plot(smooth(mean(ROIhits_s(sorting(60:80),:,bx(i))),10),'b')%./(smooth(var(ROIhits_s(:,:,bx(i))),10)+.1));
  bFig(2) = subplot(10,1,3:10); 
    imagesc(EndAlignedHIts(sorting,:,bx(i))); 
    linkaxes(bFig,'x'); 
        title(['Neuron number:  ', num2str(bx(i))]);
        if threshplot ==1;
            hold on;
            %scatter1 = scatter(xtrue(sorting),1:size(ROIhits_s,1),'b.');
            %scatter1.MarkerFaceAlpha = .2;
            %scatter1.MarkerEdgeAlpha = .2;
        end
            
end;
end
end
    