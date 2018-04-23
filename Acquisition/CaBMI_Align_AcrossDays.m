function [score] = CaBMI_Align_AcrossDays(ref, pl)
% CaBMI_Align_AcrossDays

% Align data using PrarieView's format...



% Pull in a frame
Frame1 = double(ref);
average = 2;
i= 1;
clear figure(1);

counter = 1;

% gram frame
X = pl.PixelsPerLine(); % get x dim of the image
Y = pl.LinesPerFrame(); % get y dim of the image



global KEY_IS_PRESSED
KEY_IS_PRESSED = 0;
gcf
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
while ~KEY_IS_PRESSED
current(:,:) = double( pl.GetImage_2(2,X,Y)); % Build the image

if i<average;
Frame2(:,:,i) = current;
pause(0.01);
i = i+1;
else

score.ssimval(:,counter) = ssim(mean( Frame2,3),Frame1);
score.peaksnr(:,counter) = psnr(mean(Frame2,3),Frame1);
score.err(:,counter) = immse(mean(Frame2,3),Frame1);
score.absDiffImage(:,:,counter) = imabsdiff(mean(Frame2,3),Frame1);


figure(1);
RGB1 = CaBMI_XMASS(Frame1,mean(Frame2,3),Frame1);
image(squeeze(RGB1(:,:,1,:)));
title(['score =  ', num2str(score.ssimval(:,counter)), ' ---- ', 'Best = ', num2str(max(score.ssimval))])
disp(['score =  ', num2str(score.err(:,counter)), ' ---- ', 'Best = ', num2str(max(score.err))]);
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


% Save Data with a unique filename
filename = ['scores-', datestr(datetime)]
disp('Saving Data...')
save(filename,scores);
