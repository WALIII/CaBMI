
% plot position
figure(); plot(xPos,yPos);
%
% get time difference
t1 = datetime(DateTime(1,1),'ConvertFrom','datenum');
t2 = datetime(DateTime(end,1),'ConvertFrom','datenum');
totalTime = t1-t2;
disp(['total Time is  ', str(totalTime)]);

% get pos, v and accel
vx = diff(xPos);
vy = diff(yPos);
v  = sqrt( vx.^2 + vy.^2 );
theta = atan2( vy , vx ); % note the order of vx and vy for atan2 function

figure(); plot(v);
figure(); plot(v); hold on; plot(diff(v));
figure(); plot(smooth(v,10)); hold on; plot(diff(v));
figure(); plot(smooth(v,10)); hold on; plot(diff(smooth(v,1)));

