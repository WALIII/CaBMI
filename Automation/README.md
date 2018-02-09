
### AUTOMATIC DATA PARSING/ PRE-PROCESSING

MINOS runs a MATLAB script once per day. This script can be run manually, in Matlab:

```
>> AR_DataTransfer
```

This script will gather data from acquisition computers, pre-process the incoming .mov files (seperate audio/video) and distribute them to a host RAID for future analysis.


To parse the data everyday, set up a crontab. To set this up in chron:, this is a useful URL: http://www.nncron.ru/help/EN/working/cron-format.htm

In terminal, edit in crontab with nano:
```
$  env EDITOR=nano crontab -e
 ```
To run every day, at 10PM, insert this into the crontab:
```
 0 21  * * * /Applications/MATLAB_R2015a.app/bin/matlab  -nodisplay -nosplash -r "AR_DataTransfer; quit"  >> ~/.MATLAB_logfile.log 2>&1
```

To monitor the output of this function, in a new terminal window:

```
tail -f ~/.MATLAB_logfile.log
```

This will read a ever-increasing .log file, which has the output of the matlab script directed to it. Good for troubleshooting as well.
