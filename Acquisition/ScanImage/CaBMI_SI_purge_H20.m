% purge water dispensor 
% WAL3
% d0716.2020
% coarse:
for i = 1: 5;
    
    fprintf(arduino,'%c',char(171)); pause(1); fprintf(arduino,'%c',char(17));% send answer variable content to arduino
    pause(0.3)
end

% fine
for i = 1: 10;
    fprintf(arduino,'%c',char(171)); pause(0.1); fprintf(arduino,'%c',char(17));% send answer variable content to arduino
    pause(0.3)
end