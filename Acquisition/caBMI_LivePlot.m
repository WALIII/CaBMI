function caBMI_LivePlot(data,counter,hf)
 % Plot Cursor data. Adds latency.
 
 % TO DO: Decrease liveplot latency, or ship out values to another program
 % that can plot in not real time....
 
 
%% Initialize vars
counter = counter-1; % offset counter;
t = counter;
cursor = 0;
for i = 1:4;
cell{i} = 0;
end
startSpot = 0;
interv = 100 ; % considering 1000 samples
step = 1 ; % lowering step has a number of cycles and then acquire more data

    
  
  
%% Plot Data


        hold on;
  for i = 1:4
     plot(data.ROI_dff(i,:)+(i-1)*3,'g','LineWidth',1);
  end
  

  plot(data.cursor+12,'r','LineWidth',3);
  
 grid on; 
 %set(get(hf,'CurrentAxes'),'GridAlpha',0.4,'MinorGridAlpha',0.7);

      if ((t/step)-100 < 0)
          startSpot = 0;
      else
          startSpot = (t/step)-100;
      end
      axis([ startSpot, (t/step+50), 0 , 15 ]);
      
      t = t + step;

 drawnow; 

%% Save As a video
%            Capture the plot as an image 
%       frame = getframe(hf); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
%       Write to the GIF File 
%       if t == 0
%           imwrite(imind,cm,'filename','tif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,'filename','tif','WriteMode','append'); 
%       end 

 end