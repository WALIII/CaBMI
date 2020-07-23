function DATA = CaBMI_batchPlot2;

% plot data that has already been extracted and saved... ( Lily's data);

% optimized for PCA...


% get all mat files
mov_listing=dir(fullfile(pwd,'*.mat'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;
for i = 1:size(mov_listing,2)
    
    % LOADING  ROI_hits
    
    load(filenames{i},'ROIhits_z');
    
    % Loading ROI_data
    
    load(filenames{i},'roi_ave1','roi_hits');



    % Get data for batch plotting
    
    [out] = CaBMI_SequenceEmerge(ROIhits_z);
    
    % PCA plotting
    [PCA_data,hits]=  CaBMI_PCA_rotational(ROIhits_z,roi_ave1,roi_hits);
    [outputB NumCellsTS] = CaBMI_FineSequenceEmerge(ROIhits_z);
    

    
    
   close all     
counter = counter+1;
% catch
%     disp('SKIPPING TRIAL WARNING');
% end

out_date = CaBMI_MatchDate(mov_listing{i});
out_fname = CaBMI_MatchFname(mov_listing{i});
     DATA.S{out_date}{out_fname} = out;
     DATA.PCA{out_date}{out_fname} = PCA_data;
     DATA.Consistancy{out_date}{out_fname} = outputB;
    % DATA.numCells{out_date}{out_fname} = numCells;
     DATA.numCellsTS{out_date}{out_fname} =  NumCellsTS;
   clear ROIhits roi_ave1 roi_hits 
end


counter = 1;
for i = 1: 5; % animal
    for ii = 1:7; % date
        try
            dat1(ii,i) = DATA.S{ii}{i}.mid_late- DATA.S{ii}{i}.early_mid;
            earl(counter) =  DATA.S{ii}{i}.early_early;
            lat(counter) = DATA.S{ii}{i}.late_late;
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






counter = 1;
col = hsv(7);
figure();
hold on;
for i = 1: 5; % animal
    for ii = 1:7; % date
        plot(DATA.Consistancy{ii}{i},'Color',col(i,:))
        try
            Dat(i,ii,:) = DATA.Consistancy{ii}{i};
        catch
            Dat(i,ii,:) = DATA.Consistancy{ii-1}{i};
        end
    end
end
 
 
% plot all differences, then the error bar of the mean?

% plot all differences, then the error bar of the mean...
figure();
hold on;
for i = 1:5
p1 = plot(Dat(:,i),'k');
p1.Color(4) = 0.2;
end
 
errorbar(mean(Dat,2),(std(Dat,[],2)/sqrt(7)));






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