function DATA = CaBMI_batchPlot2;

% plot data that has already been extracted and saved... ( Lily's data);



% get all mat files
mov_listing=dir(fullfile(pwd,'*.mat'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;
for i = 1:size(mov_listing,2)
    
    load(filenames{i},'ROIhits');
try
    [out] = CaBMI_SequenceEmerge(ROIhits);
   close all     
counter = counter+1;
catch
end

out_date = CaBMI_MatchDate(mov_listing{i});
out_fname = CaBMI_MatchFname(mov_listing{i});
     DATA{out_date}{out_fname} = out;
     
   clear ROIhits
end


counter = 1;
for i = 1: 5; % animal
    for ii = 1:7; % date
        try
            dat1(ii,i) = DATA{ii}{i}.mid_late- DATA{ii}{i}.early_mid;
            earl(counter) =  DATA{ii}{i}.early_early;
            lat(counter) = DATA{ii}{i}.late_late;
            counter = counter+1;
        catch
            dat1(ii,i) = 0.2;
        end
    end
end


% plot all differences, then the error bar of the mean...
figure(); 
hold on;
for i = 1:5
p1 = plot(dat1(:,i),'k');
p1.Color(4) = 0.2;
end

errorbar(mean(dat1,2),(std(dat1,[],2)/sqrt(7)));



figure();
hold on;
for i = 1:34;
x = [ 1 2];
y = [earl(i) lat(i)];;
plot(x, y, '-k')
hold on
scatter(x(1), y(1), 50, 'b', 'filled')
scatter(x(2), y(2), 50, 'r', 'filled')
axis([0.5  2.5   0 1])
end