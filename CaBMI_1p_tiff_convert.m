function CaBMI_1p_tiff_convert




v = VideoReader('pilot2.mov');

counter = 1;
endNum = 1:100;
i = 1;


while hasFrame(v)

    vid = readFrame(v);
    Xx(:,:,counter) = imresize(squeeze(vid(:,:,2)),0.50);
   
    
    if counter == 2001;
        
     disp('Smoothing data')
    %b = 10; % frames to smooth by
     %Xx = convn(Xx, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
     Xx = single(medfilt3(Xx,[1 1 9]));
     % min
     if i ==1;
     Xj = (max(Xx(:))-min(Xx(:)));
     end
     
     Xx_sc = Xx*200/(Xj);
     Xx = uint8(Xx_sc);
     
        disp('writing data...')
     imwrite(Xx(:,:,1),strcat('frame-',num2str(endNum(i)),'.tif'));
      for ii = 2: 1999;
     imwrite(Xx(:,:,ii),strcat('frame-',num2str(endNum(i)),'.tif'),'WriteMode','append')
      end
     i = i+1;
     counter = 1;
     disp('Saving data...')
    else
    
     counter = counter+1;
    end

    
end
