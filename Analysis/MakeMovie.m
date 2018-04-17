


GG2 = double(Y(:,:,1:1000));
%G = imresize(G,0.4);

b =10;


% Smooth data by 'b'



% Tke the filtered mean
% X = mean((GG2(:,:,1:100)),3);
% X = imgaussfilt(X,10);

%for i = 1:size(GG2,3); GG2(:,:,i) = (((GG2(:,:,i)+10)-X)*4) ;  end;

%GG2 = convn(G, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
for i = 101:size(GG2,3)
    
    X = mean((GG2(:,:,i-100:i)),3);
    X = imgaussfilt(X,1);
    GG2(:,:,i) = (((GG2(:,:,i)+50)-X)-100) ; 

end


% 
% % Play the result
figure(); colormap(gray); for i = 1:size(GG2,3); image((GG2(:,:,i))); pause(0.01); end;

