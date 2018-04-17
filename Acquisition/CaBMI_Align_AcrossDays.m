function [score] = CaBMI_Align_AcrossDays(ref, current)


% Pull in a frame
Frame1 = ref;
average = 3;
i= 1;
clear figure(1);

counter = 1;


global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
cF = current(:,:,counter);

if i<average;
Frame2(:,:,i) = cF;
pause(0.03);
i = i+1;
else

score.ssimval(:,counter) = ssim(mean(Frame2,3),Frame1);
score.peaksnr(:,counter) = psnr(mean(Frame2,3),Frame1);
score.err(:,counter) = immse(mean(Frame2,3),Frame1);
score.absDiffImage(:,:,counter) = imabsdiff(mean(Frame2,3),Frame1);


figure(1);
RGB1 = CaBMI_XMASS(Frame1,mean(Frame2,3),Frame1);
image(squeeze(RGB1(:,:,1,:)));
title(num2str(score.ssimval(:,counter)))
disp(['score =  ', num2str(score.err(:,counter)) ]);
% calculate the score, and display it:

i = 1;
end

counter = counter+1;
end
disp('loop ended')
function myKeyPressFcn(hObject, event)
global KEY_IS_PRESSED
KEY_IS_PRESSED  = 1;
disp('key is pressed')
