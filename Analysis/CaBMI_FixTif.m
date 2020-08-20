function CaBMI_FixTif
% preprocess all tiffs, write to .h5
% Addressing Scanimage Format

% WAL3
% d08/08/2020

homeDir = pwd;
% get all .tif files
mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;

for i = 1:size(mov_listing,2)
    cd(homeDir);
    tname = filenames{i}; % Get filename
    
    reader=ScanImageTiffReader(tname); % get
    I=reader.data();
    SI_format =1;
    GG =  mean(I(:,:,151:300),3);
    
    % replace first few seconds where the data is lost..
    for ii = 1:150;
        I(:,:,ii) = GG;
    end
    
    data_type = class(I);
    
    % create folder:
    if i == 1;
    mkdir('H5_files');
    else
    end
    cd('H5_files')
    
    %  Change filename so that Before, BMI and After are in order..
    
   if contains(tname,'BEFORE')
       output_name = 'T01';
   elseif contains(tname,'BMI')
       output_name = 'T02';
   elseif contains(tname,'AFTER')
       output_name = 'T03';
   end
% check if they exist
    h5create([output_name,'.h5'],'/mov',(size(I)),'Datatype',data_type);
    h5write([output_name,'.h5'],'/mov',I);
    clear GG I output_name
end

