#We'll create a simple cron job to log system metrics periodically.
#Create a logging script (e.g., monitor_log.sh):

#!/bin/bash
LOG_DIR="/var/log/system_metrics"
mkdir -p $LOG_DIR
LOG_FILE="$LOG_DIR/metrics_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "--- System Metrics Report - $(date) ---" >> $LOG_FILE
echo "" >> $LOG_FILE

echo "--- CPU and Memory (htop snapshot) ---" >> $LOG_FILE
# htop does not easily output to file, so we'll use 'top' for a snapshot
top -bn1 | head -n 10 >> $LOG_FILE
echo "" >> $LOG_FILE

echo "--- Disk Usage (df -h) ---" >> $LOG_FILE
df -h >> $LOG_FILE
echo "" >> $LOG_FILE

echo "--- Top 5 CPU Processes ---" >> $LOG_FILE
ps aux --sort=-%cpu | head -n 6 >> $LOG_FILE
echo "" >> $LOG_FILE

echo "--- Top 5 Memory Processes ---" >> $LOG_FILE
ps aux --sort=-%mem | head -n 6 >> $LOG_FILE
echo "" >> $LOG_FILE

echo "Log generated at: $LOG_FILE"

# Make the script executable
sudo chmod +x /usr/local/bin/monitor_log.sh 
# Schedule the script to run every hour using cro
root@ip-172-31-92-10:/var/log/system_metrics# ls -lrt
total 4
-rw-r--r-- 1 root root 2448 Jul  1 11:48 metrics_2025-07-01_11-48-52.log
root@ip-172-31-92-10:/var/log/system_metrics# cat metrics_2025-07-01_11-48-52.log
--- System Metrics Report - Tue Jul  1 11:48:52 UTC 2025 ---
#output of the script will be saved in /var/log/system_metrics/metrics_YYYY-MM-DD_HH-MM-SS.log
--- CPU and Memory (htop snapshot) ---
top - 11:48:52 up  5:06,  1 user,  load average: 0.00, 0.00, 0.00
Tasks: 109 total,   1 running, 108 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :    957.4 total,    209.6 free,    340.9 used,    580.5 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.    616.5 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
      1 root      20   0   22664  13680   9456 S   0.0   1.4   0:07.01 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kthreadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00 pool_wo+

--- Disk Usage (df -h) ---
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       6.8G  2.0G  4.8G  30% /
tmpfs           479M     0  479M   0% /dev/shm
tmpfs           192M  880K  191M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/xvda16     881M   86M  734M  11% /boot
/dev/xvda15     105M  6.2M   99M   6% /boot/efi
tmpfs            96M   12K   96M   1% /run/user/1000

--- Top 5 CPU Processes ---
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
ubuntu      4311  0.0  0.7  14992  6944 ?        S    09:46   0:04 sshd: ubuntu@pts/1
root           1  0.0  1.3  22664 13680 ?        Ss   06:42   0:07 /sbin/init
root         651  0.0  3.7 1856392 36872 ?       Ssl  06:42   0:01 /usr/lib/snapd/snapd
root         960  0.0  1.9 1685572 19396 ?       Ssl  06:42   0:01 /snap/amazon-ssm-agent/11320/amazon-ssm-agent
root         185  0.0  2.7 288952 27136 ?        SLsl 06:42   0:01 /sbin/multipathd -d -s

--- Top 5 Memory Processes ---
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         651  0.0  3.7 1856392 36872 ?       Ssl  06:42   0:01 /usr/lib/snapd/snapd
root         185  0.0  2.7 288952 27136 ?        SLsl 06:42   0:01 /sbin/multipathd -d -s
root         747  0.0  2.3 110004 22912 ?        Ssl  06:42   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
root         588  0.0  2.1  32416 20608 ?        Ss   06:42   0:00 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
root         960  0.0  1.9 1685572 19396 ?       Ssl  06:42   0:01 /snap/amazon-ssm-agent/11320/amazon-ssm-agent

root@ip-172-31-92-10:/var/log/system_metrics#