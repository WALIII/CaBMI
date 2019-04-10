
function CaBMI_BatchProcess


files = dir(pwd);
DIR = pwd

files(ismember( {files.name}, {'.', '..','DATA'})) = [];  %remove . and .. and Processed


% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subFolders)
	fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
end


% range
r1 = 2000:4000;
r2 = 12001:14000;
sp = 3;
thrh = 2.5;
% Run through all folder...
for i = 1:length(subFolders);
    cd(subFolders(i).name);
    if i ==1;
        
load('Direct_roi_map.mat','D','roi_ave');    % load releveant data

baseline =  (zscore(roi_ave.interp_dff(1,:))+zscore(roi_ave.interp_dff(2,:)))-(zscore(roi_ave.interp_dff(3,:))+zscore(roi_ave.interp_dff(4,:)));
early =  resample(D.TData.cursor(r1),sp,1);
late =  resample(D.TData.cursor(r1),sp,1);

early = baseline;
a1 = early;
b1 = late;
a1(a1<thrh) = [];
b1(b1<thrh) = [];
count1 = size(a1,2)/max(r1);
count2 = size(b1,2)/max(r1);

    else
        load('Direct_roi.mat','D');    % load releveant data

early =  [early resample(D.TData.cursor(r1),sp,1)];
late =  [late resample(D.TData.cursor(r2),sp,1)];

temp1 = resample(D.TData.cursor(r1),sp,1);
temp2 = resample(D.TData.cursor(r2),sp,1);

temp1(temp1<thrh) = [];
temp2(temp2<thrh) = [];

% a1 = [a1 temp1];
% b1 = [b1 temp2];
temp3 = size(temp1,2)/max(r1);
temp4 = size(temp2,2)/max(r1);

count1 = [ count1 temp3];
count2 = [ count2 temp4] ;

    end

    cd(DIR);
end


figure();
hold on;
h1 = histogram(early,'FaceColor','r');
h2 = histogram(late,'FaceColor','b');
h1.Normalization = 'probability';
h1.BinWidth = 0.5;
h2.Normalization = 'probability';
h2.BinWidth = 0.5;
title('b is late');

figure();
hold on;
histogram(early,'FaceColor','r');
histogram(late,'FaceColor','b');
title('b is late (log)');
set(gca,'YScale','log')

figure(); 
bihist(early,late,20);



 y = [ size(early,2) size(late,2)]
figure(); bar(y);

% Bar with error;
x = 1:2;
figure();
hold on

% x = 1:length(subFolders)';
data = [ mean(count1) mean(count2)];
errhigh = [std(count1)/2 std(count2)/2];
errlow  = errhigh;

bar(x, data)  

er = errorbar(x, data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  


