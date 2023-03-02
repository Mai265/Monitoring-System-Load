# **Monitoring-System-Load**
Bash shell script runs every 1min to monitor system load, record an entry to `/var/log/systemload` file, and record an event to `/tmp/events` file in case of high load (System Load increases).

## Create needed files
```
[x@server ~]# touch   /var/log/systemload

[x@server ~]# touch   /tmp/events
```


## Schedule task to run the script
Go to `/etc/cron.d` directory and create a file for the task schedule **This method make the task robust against reboots and service configuration files updates** 
```
[x@server ~]# vim  /etc/cron.d/Load
```

Add the following line to the file:
```
*/1    *       *       *       *       root   /root/Scripts/LoadMonitoring.sh
```

Restart crond service
```
[x@server ~]# systemctl   restart   crond.service
```


## Add log facility 
Create `Load.conf` file under `/etc/rsyslog.d/` directory to add facility entry which direct log record to `/var/log/systemload` log file
```
[x@server ~]# vim  /etc/rsyslog.d/Load.conf
```

Add the following line to the file:
```
local3.crit	      /var/log/systemLoad
```

Restart rsyslog service
```
[x@server ~]# systemctl   restart   rsyslog.service
```


