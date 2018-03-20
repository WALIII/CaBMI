




b =3;

% Smooth data by 'b'

GG2 = convn(GG, single(reshape([1 1 1] / b, 1, 1, [])), 'same');

% Tke the filtered mean
X = min(GG2(:,:,100),3);
X = imgaussfilt(X,120);

for i = 1:size(GG2,3); GG2(:,:,i) = (((GG2(:,:,i)+10)-X)*9) ;  end;

% 
% % Play the result
figure(); colormap(gray); for i = 1:size(GG2,3); imagesc(GG2(:,:,i)); pause(0.001); end;
