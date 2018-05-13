% Test Serial Port Setup for arduino
% WAL3
% d11.26.17

clear all
clc
 
answer=1; % this is where we'll store the user's answer
arduino=serial('COM13','BaudRate',9600); % create serial communication object on port COM4
 
fopen(arduino); % initiate arduino communication
 counter = 1;
 try
while answer
    
    answer=input('Enter led value 1 or 2 (1=ON, 2=OFF, 0=EXIT PROGRAM): '); % ask user to enter value for variable answer
    fprintf(arduino,'%c', answer); % send answer variable content to arduino
counter = counter+1;
end

 catch
     disp('FAILED')
 end
 
 
fclose(arduino); % end communication with arduino
