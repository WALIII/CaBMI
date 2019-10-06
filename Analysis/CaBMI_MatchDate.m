
%% %animal reference:
function out_date = CaBMI_MatchDate(in_name)

if contains(in_name,'d030818')
%M001 = 1;
out_date = 1;

elseif contains(in_name,'d030918')
% M010 = 2;
out_date = 2;

elseif contains(in_name,'d031018')
% M011 = 3;
out_date = 3;

elseif contains(in_name,'d031118')
% M00q = 4; 
out_date = 4;

elseif contains(in_name,'d031218')
% M006 = 5;
out_date = 5;

elseif contains(in_name,'d031318')
% M006 = 5;
out_date = 6;

elseif contains(in_name,'d031418')
% M006 = 5;
out_date = 7;


end
