#Automate Backups for Mike's Nginx Server:
#Backup Script for Nginx (nginx_backup.sh):
#!/bin/bash
BACKUP_DIR="/backups"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="${BACKUP_DIR}/nginx_backup_${DATE}.tar.gz"
NGINX_CONF="/etc/nginx"
NGINX_DOC_ROOT="/usr/share/nginx/html"

echo "Starting Nginx backup at $(date)" >> /var/log/nginx_backup.log
tar -czf "$BACKUP_FILE" "$NGINX_CONF" "$NGINX_DOC_ROOT" 2>> /var/log/nginx_backup.log

if [ $? -eq 0 ]; then
    echo "Nginx backup successful: $BACKUP_FILE" >> /var/log/nginx_backup.log
    # Verify backup integrity
    tar -tzf "$BACKUP_FILE" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Nginx backup integrity verified for $BACKUP_FILE" >> /var/log/nginx_backup.log
    else
        echo "ERROR: Nginx backup integrity check FAILED for $BACKUP_FILE" >> /var/log/nginx_backup.log
    fi
else
    echo "ERROR: Nginx backup FAILED for $NGINX_CONF and $NGINX_DOC_ROOT" >> /var/log/nginx_backup.log
fi
# Make the script executable
ubuntu@ip-172-31-92-10:~$ sudo vi /backups/nginx_backup.sh
# Add the above script content to nginx_backup.sh
# Save and exit the editor
# Make the script executable
ubuntu@ip-172-31-92-10:~$ sudo chmod +x /backups/nginx_backup.sh
# Schedule the backup script to run daily at 2 AM using cron
ubuntu@ip-172-31-92-10:~$ sudo crontab -e
# Add the following line to the crontab file:
0 2 * * * /backups/nginx_backup.sh >> /var/log/nginx_backup_cron.log 2>&1
# Save and exit the crontab editor.
# This will ensure that the Nginx backup script runs daily at 2 AM and logs its output to /var/log/nginx_backup_cron.log.
# Make the script executable        
ubuntu@ip-172-31-92-10:~$ sudo ls -lh /backups/
# Check the backup directory to ensure the script is executable
# The output should show nginx_backup.sh with executable permissions (e.g., -rwxr-xr-x)
# The output should also show the backup file created with the current date (e.g., nginx_backup_2023-10-01.tar.gz)
# Verify the backup log file
ubuntu@ip-172-31-92-10:~$ sudo cat /var/log/nginx_backup.log
# This will display the log of the last backup operation, including any errors
# If the backup was successful, you should see a message indicating success and the backup file path
# If there were any errors, they will be logged in this file as well        
# Verify the cron job
ubuntu@ip-172-31-92-10:~$ sudo crontab - l
# This will list the current user's cron jobs, including the Nginx backup job scheduled to run daily at 2 AM
# You should see the line:
# 0 2 * * * /backups/nginx_backup.sh >> /var/log/nginx_backup_cron.log 2>&1
# This confirms that the Nginx backup script is scheduled to run daily at 2 AM
# If you see this line, it means the cron job is set up correctly and will execute the backup script as intended.       
# Check the backup directory to ensure the script is executable
ubuntu@ip-172-31-92-10:~$ sudo ls -lh /backups/
# The output should show nginx_backup.sh with executable permissions (e.g., -rwxr-xr-x)
ubuntu@ip-172-31-92-10:~$ sudo cat /var/log/nginx_backup.log
ubuntu@ip-172-31-92-10:~$ sudo crontab -l
 