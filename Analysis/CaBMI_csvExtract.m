
function [data] = CaBMI_csvExtract
% Extract CSV file, export the first 2 rows


% WAL3
% d3/17/18

DIR = pwd;
mov_listing=dir(fullfile(DIR,'*.csv'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;


data = csvread(filenames{1},1,0);
data = data(:,1:3);
