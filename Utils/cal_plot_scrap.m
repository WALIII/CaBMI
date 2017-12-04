% Plot calcium data
% WAL3

hf = figure();
grid on; grid minor;
whitebg;

close all
hf = figure();
grid on; grid minor;
whitebg;
t = 0 ;
cursor = 0;
for i = 1:4;
cell{i} = 0;
end
startSpot = 0;
interv = 100 ; % considering 1000 samples
step = 0.1 ; % lowering step has a number of cycles and then acquire more data
while ( t <interv )
    
    for i = 1:4
    update{i} = rand(1); if update{i}>0.95; update{i} = update{i}+(i-1)*3+4; else update{i} = update{i}+(i-1)*3; end;
    
    end
    
    livecursor = (update{1}+update{2}) - (update{3}+update{4});
    
    cursor = [cursor, livecursor];
  
    for i = 1:4;
        cell{i} = [cell{i}, update{i}];
    end
 
    
  
    ax1 = subplot(10,1,1:3)
    plot(cursor,'r','LineWidth',3);
    ax2 = subplot(10,1,4:10)
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
      pause(0.1)
      linkaxes([ax1,ax2], 'x');
      
      % Save
%            % Capture the plot as an image 
%       frame = getframe(hf); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
%       % Write to the GIF File 
%       if t == 0
%           imwrite(imind,cm,'filename','tif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,'filename','tif','WriteMode','append'); 
%       end 

  end