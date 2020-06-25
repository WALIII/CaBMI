function collectData(src,event,fname)
     time = event.TimeStamps;
     data = event.Data;
     trigger = event.TriggerTime;
     figure();
     plot(time,medfilt1(data,4));
     ylabel('voltsge');
     xlabel('time (s)');
     legend('Lickport','Reward');
     title('Behavioral Data');
     save(fname, 'data', 'time', 'trigger','-v7.3');
     disp('Background Acquisition complete');
end