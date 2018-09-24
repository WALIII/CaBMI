

function out = WL_smooth(x,num);
% filter data with a buffer to prevent edge artifacts
% x is your signal
% num is the number of frames to smooth the data;


R=0.3; % 10% of signal

Nr=50;

N=size(x,1);

NR=min(round(N*R),Nr); % At most 50 points

for i=1:size(x,2)

    x1(:,i)=2*x(1,i)-flipud(x(2:NR+1,i));  % maintain continuity in level and slope
    x2(:,i)=2*x(end,i)-flipud(x(end-NR:end-1,i));
end

x=[x1;x;x2];

% Do filtering

x=smooth(x,num);

out=x(NR+1:end-NR,:);