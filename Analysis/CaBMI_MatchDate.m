
%% %animal reference:
function [out_date, str1] = CaBMI_MatchDate(in_name)

if contains(in_name,'d030818')
%M001 = 1;
out_date = 1;
str1 = 'd030818';

elseif contains(in_name,'d030918')
% M010 = 2;
out_date = 2;
str1 = 'd030918';

elseif contains(in_name,'d031018')
% M011 = 3;
out_date = 3;
str1 = 'd031018';

elseif contains(in_name,'d031118')
% M00q = 4; 
out_date = 4;
str1 = 'd031118';

elseif contains(in_name,'d031218')
% M006 = 5;
out_date = 5;
str1 = 'd031218';

elseif contains(in_name,'d031318')
% M006 = 5;
out_date = 6;
str1 = 'd031318';

elseif contains(in_name,'d031418')
% M006 = 5;
out_date = 7;
str1 = 'd031418';


end
