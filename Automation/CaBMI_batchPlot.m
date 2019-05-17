function DATA = CaBMI_batchPlot;
%CaBMI_batchPlot

% Go through all animals/folders and do some batch figures

% run in folder contatinig the dates

analysis_to_do = [1 2 3 4]; 


% general structure:

% Animal-> analysis_output{day}(hit,time,trial);





% Get all folders in directory
files = dir(pwd);

% Exclude some directories...
files(ismember( {files.name}, {'.', '..','Batch_Processed'})) = [];  %remove . and .. and Processed

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subFolders)
	fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
end


%% Run for each animal, on each day:

for i = 1:length(subFolders);
disp(['entering folder:  ', char(subFolders(i).name)])

cd([subFolders(i).folder,'/',subFolders(i).name])

% index every subfolder...
flight_files = dir(pwd);

% Exclude some directories...
flight_files(ismember( {flight_files.name}, {'.', '..','Processed'})) = [];  %remove . and .. and Processed

% Get a logical vector that tells which is a directory.
flight_dirFlags = [flight_files.isdir];
% Extract only those that are directories.
flight_subFolders = flight_files(flight_dirFlags);

for ii = 1:length(flight_subFolders);
    % cd into folder:
    try
    cd([flight_subFolders(ii).folder,'/',flight_subFolders(ii).name]);
    catch
        
        disp('wtf')
    end
    
    disp(['indexing into folder ',flight_subFolders(ii).name, ' on day ', subFolders(i).name])
    % load data into workspace:
[roi_ave1, roi_ave2, roi_ave3, roi_ave4, ROIa, ROIb, ds_hits, roi_hits, ROIhits, ROIhits_d, ROIhits_s, ROIhits_z,D_ROIhits, D_ROIhits_d, D_ROIhits_s, D_ROIhits_z] =  CaBMI_Figure_Generator;

     [out] = CaBMI_fast_and_slow(ROIhits, D_ROIhits_z,roi_hits);
     DATA{i}{ii} = out;
   clear out roi_ave1 roi_ave2 roi_ave3 roi_ave4 ROIa ROIb ds_hits roi_hits ROIhits ROIhits_d  ROIhits_s ROIhits_z D_ROIhits D_ROIhits_d D_ROIhits_s D_ROIhits_z
end
clear flight_subFolders % so as not to disrupt the next loop...
end

    
    
    
    

%% %animal reference:
function out_fname = MatchFname(in_name)

if strcmp('M001',in_name)
%M001 = 1;
out_fname = 1;

elseif strcmp('M010',in_name)
% M010 = 2;
out_fname = 2;

elseif strcmp('M011',in_name)
% M011 = 3;
out_fname = 3;

elseif strcmp('M00q',in_name)
% M00q = 4; 
out_fname = 4;

elseif strcmp('M006',in_name)
% M006 = 5;
out_fname = 5;

end

    