function [RGB1 RGB2] = CaBMI_XMASS(GG1,GG2,GG3,varargin);


   HL = [0.2 .4];
   T = 1:size(GG1,2);
   F = 1:size(GG1,1);
    movie = 1;

    % Manual inputs
vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'Direct') % manually inputing a sort order
    ROI=vin{i+1};
    plotROI =1;
  elseif isequal(vin{i},'Indirect')
    ri=vin{i+1};
end
end
    
    
Llim = HL(1);
 Hlim = HL(2);

im1(:,:,:,1)=  mat2gray(GG1);
im1(:,:,:,2)=  mat2gray(GG2);
im1(:,:,:,3)=  mat2gray(GG3);

% Mean subtracted/Normalized
im2 = im1./(mean(im1(:,:,[1:30 110:120],:),3)+.01);
im2 = im2 - mean(im2(:,:,1:30,:),3);
im2 = mat2gray(im2);

rsjp = imadjust(im1(:),[Llim ; Hlim]);
rsjp2 = imadjust(im2(:),[Llim ; Hlim]);


 RGB1 = reshape(rsjp,[size(im1,1),size(im1,2),size(im1,3),3]);
 RGB2 = reshape(rsjp2,[size(im2,1),size(im2,2),size(im2,3),3]);

 %F = flip(F,1);
%RGB1 = RGB1(size(RGB1,1):-1:1,:,:);

%image(T,F,(RGB1));set(gca,'YDir','normal');

title('baseleine to baseline')

if movie ==1;
    
    h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';
for i = 1:121; 
    % Text assignment
     % Draw plot for y = x.^n
                if i < 10
                      image = squeeze(RGB2(:,:,i,:));
                    if plotROI ==1; 
                     for ii = 1:4
                         if ii<3
                            image = insertShape(image,'circle',[mean(ROI.coordinates{ii}(:,1)) mean(ROI.coordinates{ii}(:,2)) 10],'Color','g','LineWidth',5);
                         else
                            image = insertShape(image,'circle',[mean(ROI.coordinates{ii}(:,1)) mean(ROI.coordinates{ii}(:,2)) 10],'Color','r','LineWidth',5);
                         end
                       image = insertText(image,[0 0],'E1','FontSize',18,'BoxColor','black','TextColor','green');
                       image = insertText(image,[0 30],'E2','FontSize',18,'BoxColor','black','TextColor','red');

                     end
                    end
                elseif i < 10
                     image = squeeze(RGB2(:,:,i,:));
                      image = insertText(image,[0 0],txt,'FontSize',18,'BoxColor','black','TextColor','white');
                elseif i ==60
                  txt = ['HIT!'];
                      image = squeeze(RGB2(:,:,i,:));
                       image = insertText(image,[0 0],txt,'FontSize',18,'BoxColor','black','TextColor','white');
                else
                 txt = ['Time post hit: ',num2str(i-60)];
                     image = squeeze(RGB2(:,:,i,:));
                     image = insertText(image,[0 0],txt,'FontSize',18,'BoxColor','black','TextColor','white');
                end
                

    imshow(squeeze(image)); 
axis tight manual % this ensures that getframe() returns a consistent size
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf);

 
      else 
          
          imwrite(imind,cm,filename,'gif','DelayTime',0,'WriteMode','append'); 
  end
end
end
