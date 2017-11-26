clear all
clc
 
answer=1; % this is where we'll store the user's answer
arduino=serial('/dev/tty.usbmodem1421','BaudRate',9600); % create serial communication object on port COM4
 
fopen(arduino); % initiate arduino communication
 counter = 1;
 try
for i = 1:10
    fprintf(arduino,'%c', counter); % send answer variable content to arduino
counter = counter+1;
pause(0.1);
end

 catch
     disp('FAILED')
 end
 
 
fclose(arduino); % end communication with arduino
