

answer=1; % this is where we'll store the user's answer
arduino=serial('COM13','BaudRate',9600); % create serial communication object on port COM4
 
fopen(arduino); % initiate arduino communication
 try
 counter = 1;
 n = 10; 
 pause(1);
 
 G1 = round((rand(1,2000)*500));
 G2 = round((rand(1,2000)*500));
  G1 = 1:1:1000;
 G2 = 1:1:1000;
 G2 = 500-G2;
G1(G1<0) = 0;
G2(G2<0) = 0;

answer= 1;
     for i = 1:100;
          a =  char(sprintfc('%03d',50)); % TONE
          b = char(sprintfc('%03d',10)); % BEAT
    
    answer = [a,b];
    disp(answer);
    fprintf(arduino,'%s',answer); % send answer variable content to arduino
pause(0.03);
%     if i>n
%      answer = answer+1;
%      n = n+10;
%     end
end

 catch
     disp('FAILED')
 end
 
 
fclose(arduino); % end communication with arduino


%figure(); plot(G1,G2);
