%% %animal reference:
function [out_fname, str1] = CaBMI_MatchFname(in_name)

if contains(in_name,'M001') %M001 = 1;
out_fname = 1;
str1 = 'M001';

elseif contains(in_name,'M010') % M010 = 2;
out_fname = 2;
str1 = 'M010';

elseif contains(in_name,'M011') % M011 = 3;
out_fname = 3;
str1 = 'M011';

elseif contains(in_name,'M00q')% M00q = 4; 
out_fname = 4;
str1 = 'M00q';

elseif contains(in_name,'M006')% M006 = 5;
out_fname = 5;
str1 = 'M006';

elseif contains(in_name,'M026') % M006 = 5;
out_fname = 6;
str1 = 'M026';

elseif contains(in_name,'M051')% M006 = 5;
out_fname = 7;
str1 = 'M051';

end
