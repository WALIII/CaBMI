

    

%% %animal reference:
function out_fname = CaBMI_MatchFname(in_name)

if contains(in_name,'M001')
%M001 = 1;
out_fname = 1;

elseif contains(in_name,'M010')
% M010 = 2;
out_fname = 2;

elseif contains(in_name,'M011')
% M011 = 3;
out_fname = 3;

elseif contains(in_name,'M00q')
% M00q = 4; 
out_fname = 4;

elseif contains(in_name,'M006')
% M006 = 5;
out_fname = 5;

elseif contains(in_name,'M026')
% M006 = 5;
out_fname = 6;

elseif contains(in_name,'M051')
% M006 = 5;
out_fname = 7;


end
