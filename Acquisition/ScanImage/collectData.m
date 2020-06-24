function collectData(src,event,fname)
     time = event.TimeStamps;
     data = event.Data;
     trigger = event.TriggerTime;
     figure();
     plot(time,data)
     save(fname, 'data', 'time', 'trigger','-v7.3');
     disp('Background Acquisition complete');
end