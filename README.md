# **Monitoring-System-Load**
Bash shell script runs every 1min to monitor system load, record an entry to `/var/log/systemload` file, and record an event to `/tmp/events` file in case of high load (System Load increases).

## Create needed files
```
[root@server ~]# touch   /var/log/systemload

[root@server ~]# touch   /tmp/events
```


## Schedule task to run the script
Go to `/etc/cron.d` directory and create a file for the task schedule **This method make the task robust against reboots and service configuration files updates** 
```
[root@server ~]# vim  /etc/cron.d/Load
```

Add the following line to the file:
```
*/1    *       *       *       *       root   /root/Scripts/LoadMonitoring.sh
```

Restart crond service
```
[root@server ~]# systemctl   restart   crond.service
```


## Add log facility 
Create `Load.conf` file under `/etc/rsyslog.d/` directory to add facility entry which direct log record to `/var/log/systemload` log file
```
[root@server ~]# vim  /etc/rsyslog.d/Load.conf
```

Add the following line to the file:
```
local3.crit	      /var/log/systemLoad
```

Restart rsyslog service
```
[root@server ~]# systemctl   restart   rsyslog.service
```

## Monitoring
```
[root@server ~]# tail -f   /var/log/systemLoad
```
Output:   
> Mar  2 04:19:01 server root[6591]: system load is  0.09, 0.04, 0.01 at Thu Mar  2 04:19:01 AM EET 2023


To see the event in  `/tmp/events` file :
```
[root@server ~]# cat   /tmp/events
```

Output:
> Subject: Server XXX.XXX.XXX.XXX  load 
>
> Body:
>
>  	   Dear,
>
> 	  	 The system RHEL-SERVER runs with IP XXX.XXX.XXX.XXX  has a load of 
>
> 	  	 1MIN load: 0.09
>
> 	  	 5MIN load: 0.04 
>
> 	  	 15MIN load: 0.01
>
> 	   Thank you .


