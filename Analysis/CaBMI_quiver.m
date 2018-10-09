
function CaBMI_quiver(TData);

figure(); 
colormap(jet);
clear a b c d XA XB
% j = (1:10:(size(TData.cursorA,2)-1000));
%     
XA = smooth(TData.cursorA,5);
XB = smooth(TData.cursorB,5);
lead = 1;
samp = 1;
a = XA(1:samp:end-lead);
b = XB(1:samp:end-lead);
c = XA((1+lead):samp:end);
d = XB((1+lead):samp:end);
q = quiver(a,b,a-c,b-d,'linewidth',2);


%// Compute the magnitude of the vectors
mags = mat2gray(sqrt(sum(cat(2, q.UData(:), q.VData(:), ...
            reshape(q.WData, numel(q.UData), [])).^2, 2)));

%// Get the current colormap
currentColormap = colormap(jet);

%// Now determine the color to make each arrow using a colormap
[~, ~, ind] = histcounts(mags, size(currentColormap, 1));

%// Now map this to a colormap to get RGB
cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
cmap(:,:,4) = 255;
cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);

%// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
set(q.Head, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

%// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
set(q.Tail, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:2,:,:), [], 4).');





figure();
q2 = quiver(a,b,a-c,b-d,'linewidth',1.5);

%// Compute the magnitude of the vectors
mags = 1:size(ind,1);
%// Get the current colormap
currentColormap = colormap(jet);

%// Now determine the color to make each arrow using a colormap
[~, ~, ind] = histcounts(mags, size(currentColormap, 1));

%// Now map this to a colormap to get RGB
cmap = uint8(ind2rgb(ind(:), currentColormap) * 255);
cmap(:,:,4) = 255;
cmap = permute(repmat(cmap, [1 3 1]), [2 1 3]);
%// We repeat each color 3 times (using 1:3 below) because each arrow has 3 vertices
set(q2.Head, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:3,:,:), [], 4).');   %'

%// We repeat each color 2 times (using 1:2 below) because each tail has 2 vertices
set(q2.Tail, ...
    'ColorBinding', 'interpolated', ...
    'ColorData', reshape(cmap(1:2,:,:), [], 4).');


% a = XA(2:3:end-2);
% b = XB(2:3:end-2);
% c = XA(4:3:end);
% d = XB(4:3:end);
% quiver(a,b,c,d);
% 
% a = TData.cursorA(3:3:end-2);
% b = TData.cursorB(3:3:end-2);
% c = TData.cursorA(5:3:end);
% d = TData.cursorB(5:3:end);
% quiver(a,b,c,d);
