function CaBMI_FixTif
% preprocess all tiffs, write to .h5
% Addressing Scanimage Format

% WAL3
% d08/08/2020

% get all .tif files
mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;

for i = 1:size(mov_listing,2)
    
tname = filenames{i}; % Get filename

reader=ScanImageTiffReader(tname); % get 
I=reader.data();
SI_format =1;
GG =  mean(I(:,:,151:300),3);

% replace first few seconds where the data is lost..
for i = 1:150;
    I(:,:,i) = GG;
end

    data_type = class(I);
    % create:
    
    % TO DO: change filename so that Before, BMI and After are in order..
    
     h5create([tname,'.h5'],'/mov',(size(I)),'Datatype',data_type);
    h5write([tname,'.h5'],'/mov',I); 
clear GG I
end
    
    