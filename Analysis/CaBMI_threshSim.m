function [hits, locs] = CaBMI_threshSim(sig,thresh,reset);

if nargin<3
thresh = 2.5;
reset = 0;
elseif nargin<2
    reset = 0;
end

counter = 0;
condition = 0; 
for i  = 1:length(sig)

if sig(i)> thresh && condition == 0;
    condition = 1;
    counter = counter+1;
    locs(:,counter) = i;
elseif condition ==1 && sig(i)< reset
    condition = 0;
end
end

hits = counter;


