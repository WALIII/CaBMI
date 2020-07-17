function [dat] = LickTrackingTest(a,b)

i = 1;
while toc(b) < 5;
    dat(1,i) = readVoltage(a,'A0');
    dat(2,i) = toc(b);
    i = i+1;
end
figure(); plot(dat(2,:),dat(1,:));

disp('test')