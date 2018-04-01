function RGB1 = XMASS_song(GG1,GG2,GG3,F,T,HL);


if nargin < 4
   %HL = [0.00005 .05];
   HL = [0.01 .55];
   T = 1:size(GG1,2);
   F = 1:size(GG1,1);
elseif nargin < 6
   HL = [0.005 .05];
end

Llim = HL(1);
 Hlim = HL(2);

im1(:,:,1)=  mat2gray(GG1);
im1(:,:,2)=  mat2gray(GG2);
im1(:,:,3)=  mat2gray(GG3);


RGB1 = imadjust(im1,[Llim Llim Llim; Hlim Hlim Hlim],[]);

% RGB1 = flipdim(RGB1,1);
 %F = flip(F,1);
%RGB1 = RGB1(size(RGB1,1):-1:1,:,:);

image(T,F,(RGB1));set(gca,'YDir','normal');

title('baseleine to baseline')

