Backup Script for Apache (apache_backup.sh):
ubuntu@ip-172-31-92-10:~$ sudo vi /backups/apache_backup.sh
#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="${BACKUP_DIR}/apache_backup_${DATE}.tar.gz"
APACHE_CONF="/etc/httpd" # For Red Hat/CentOS. Use /etc/apache2 for Debian/Ubuntu
APACHE_DOC_ROOT="/var/www/html"

echo "Starting Apache backup at $(date)" >> /var/log/apache_backup.log
tar -czf "$BACKUP_FILE" "$APACHE_CONF" "$APACHE_DOC_ROOT" 2>> /var/log/apache_backup.log

if [ $? -eq 0 ]; then
    echo "Apache backup successful: $BACKUP_FILE" >> /var/log/apache_backup.log
    # Verify backup integrity
    tar -tzf "$BACKUP_FILE" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Apache backup integrity verified for $BACKUP_FILE" >> /var/log/apache_backup.log
    else
        echo "ERROR: Apache backup integrity check FAILED for $BACKUP_FILE" >> /var/log/apache_backup.log
    fi
else
    echo "ERROR: Apache backup FAILED for $APACHE_CONF and $APACHE_DOC_ROOT" >> /var/log/apache_backup.log
fi
# Make the script executable
ubuntu@ip-172-31-92-10:~$ sudo chmod +x /backups/apache_backup.sh
# Schedule the backup script to run daily at 2 AM using cron
ubuntu@ip-172-31-92-10:~$ sudo crontab -e
# Add the following line to the crontab file:
0 2 * * * /backups/apache_backup.sh >> /var/log/apache_backup_cron.log 2>&1
# Save and exit the crontab editor. 
# This will ensure that the Apache backup script runs daily at 2 AM and logs its output to /var/log/apache_backup_cron.log. 
# Make the script executable        
ubuntu@ip-172-31-92-10:~$ sudo ls -lh /backups/
root@ip-172-31-92-10:/var/log# sudo ls -lh /backups/
total 20K
-rwxr-xr-x 1 root root  920 Jul  1 10:24 apache_backup.sh
-rw-r--r-- 1 root root 3.5K Jul  1 11:36 apache_backup_2025-07-01.tar.gz
-rwxr-xr-x 1 root root  853 Jul  1 10:30 nginx_backup.sh
-rw-r--r-- 1 root root 7.1K Jul  1 11:36 nginx_backup_2025-07-01.tar.gz         
ubuntu@ip-172-31-92-10:~$ sudo cat /var/log/apache_backup.log

