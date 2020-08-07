% purge water dispensor
% WAL3
% d0716.2020

% lick data:

PlotLicks = 1;
type1 = 2;

if PlotLicks ==1;
    s = daq.createSession('ni');
    addAnalogInputChannel(s,'Dev6', 0, 'Voltage');
    addAnalogInputChannel(s,'Dev6', 1, 'Voltage');
    
    s.Rate = 500;
    % set time
    
    s.DurationInSeconds = 12;
    
    s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;
    
    fname = 'TestLickData.mat';
    
    
    h2 = s.addlistener('DataAvailable',@(src,event)collectData(src,event,fname));
    s.startBackground();
    
    
end
if type1 ==1;
    for i = 1:1;
        
        fprintf(arduino,'%c',char(171)); pause(0.55); fprintf(arduino,'%c',char(197));% send answer variable content to arduino
        pause(0.02)
    end
elseif type1 ==2;
    % fine:
    for i = 1:5;
        fprintf(arduino,'%c',char(171)); pause(0.25); fprintf(arduino,'%c',char(17));% send answer variable content to arduino
        pause(3)
    end
end



