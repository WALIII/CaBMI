function  caBMI_LivePlot(MM,data,counter,hf)
counter = counter-1;

if counter ==1;
hf = figure();
grid on; grid minor;
whitebg;
end


t = counter ;
cursor = 0;
for i = 1:4;
cell{i} = 0;
end
startSpot = 0;
interv = 100 ; % considering 1000 samples
step = 1 ; % lowering step has a number of cycles and then acquire more data
% while ( t <interv )
    

    
    livecursor = MM; % time averaged cursor
    
   
  

        

  if counter> 10;
          for i = 1:4
            baseline{i} = prctile(data.ROI_val(i,2:end),5);
        end
        
    for i = 1:4;
        cell{i} = (data.ROI_val(i,2:end)-baseline{i})./baseline{i}*100  +  i*2;
    end
  cursor = data.cursor;
    
  
    ax1 = subplot(10,1,1:3);
    plot(cursor,'r','LineWidth',3);
    ax2 = subplot(10,1,4:10);
    for i = 1:4;  
        hold on;
    plot(cell{i},'g','LineWidth',1); 
    end

    
grid on; 
set(get(hf,'CurrentAxes'),'GridAlpha',0.4,'MinorGridAlpha',0.7);

      if ((t/step)-100 < 0)
          startSpot = 0;
      else
          startSpot = (t/step)-100;
      end
      axis([ startSpot, (t/step+50), 0 , 15 ]);
      
      t = t + step;
      drawnow; 
      linkaxes([ax1,ax2], 'x');
      
      % Save
           % Capture the plot as an image 
      frame = getframe(hf); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if t == 0
          imwrite(imind,cm,'filename','tif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,'filename','tif','WriteMode','append'); 
      end 

 end