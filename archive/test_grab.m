clear Im1
Im1(:,:,1) = pl.GetImage(1);
counter = 2;

for i = 1:100;
Im = pl.GetImage(1);
if Im1(:,:,counter-1) == Im;
pause(0.01) % This will approximately itteratively sync
else
  Im1(:,:,counter) = Im;
  counter = counter+1;
  pause(0.02) % should be a bit less than the frame rate
end
end