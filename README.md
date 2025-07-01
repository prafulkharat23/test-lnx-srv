DevOps Environment Setup and Management
This repository contains the documentation, scripts, and configurations for setting up and managing secure, monitored, and well-maintained development environments for new DevOps engineers (Sarah and Mike) at TechCorp. This project addresses key operational and security standards, including system monitoring, user management, and automated backup procedures for web servers.

Table of Contents
Project Overview

# Tasks Completed

    Task 1: System Monitoring Setup

    Task 2: User Management and Access Control

    Task 3: Backup Configuration for Web Servers

# Implementation Details

    Usage

    Deliverables

    Challenges and Learnings

    Future Enhancements

# Project Overview

As a Fresher DevOps Engineer, I assisted Rahul, a Senior DevOps engineer, in establishing robust development environments. The primary goals were to ensure:

System Health: Proactive monitoring of CPU, memory, and disk usage.

Secure Access: Proper user account creation, isolated workspaces, and strong password policies.

Data Integrity: Automated and verified backup procedures for critical web server configurations and data.

This repository serves as a comprehensive guide and a collection of the artifacts generated during this project.

# Tasks Completed
# Task 1: System Monitoring Setup
Objective: Configure a monitoring system to ensure the development environment’s health, performance, and capacity planning.

# Key Actions:

Installation and basic configuration of htop for real-time process monitoring.

Utilization of df and du for comprehensive disk usage tracking.

Implementation of a cron job to capture and log system metrics (CPU, memory, processes, disk usage) periodically to /var/log/system_metrics/.

Relevant Files/Commands:

sudo apt install htop (or sudo yum install htop)

df -h, du -sh /path/to/directory

monitor_log.sh (script for logging metrics)

crontab -e (cron entry for monitor_log.sh)

# Task 2: User Management and Access Control
Objective: Set up user accounts and configure secure access controls for the new developers, Sarah and Mike.

Key Actions:

Creation of user accounts Sarah and Mike with secure passwords.

Setup of isolated working directories: /home/Sarah/workspace and /home/Mike/workspace with chmod 700 permissions.

Enforcement of a password policy using chage (30-day expiration) and PAM (pam_pwquality module) for complexity (min length, character types, history).

Relevant Files/Commands:

sudo useradd -m Sarah, sudo passwd Sarah

sudo mkdir -p /home/Sarah/workspace, sudo chown Sarah:Sarah /home/Sarah/workspace, sudo chmod 700 /home/Sarah/workspace

sudo chage -M 30 Sarah

Modifications to /etc/pam.d/common-password (or /etc/pam.d/system-auth)

# Task 3: Backup Configuration for Web Servers
Objective: Configure automated backups for Sarah’s Apache server and Mike’s Nginx server to ensure data integrity and recovery.

Key Actions:

Development of shell scripts (apache_backup.sh, nginx_backup.sh) to backup web server configurations and document roots (/etc/httpd/, /var/www/html/ for Apache; /etc/nginx/, /usr/share/nginx/html/ for Nginx).

Scheduling of cron jobs to run backups every Tuesday at 12:00 AM.

Implementation of a naming convention: server_backup_YYYY-MM-DD.tar.gz in the /backups/ directory.

Inclusion of backup integrity verification (tar -tzf) and logging within the scripts.

Relevant Files/Commands:

apache_backup.sh (script for Apache backups)

nginx_backup.sh (script for Nginx backups)

sudo crontab -e (cron entries for backup scripts)

ls -lh /backups/ (to view backup files)

/var/log/apache_backup.log, /var/log/nginx_backup.log (backup logs)

Implementation Details
This section would typically contain the actual shell scripts and configuration snippets.

monitor_log.sh
#!/bin/bash
LOG_DIR="/var/log/system_metrics"
mkdir -p $LOG_DIR
LOG_FILE="$LOG_DIR/metrics_$(date +%Y-%m-%d_%H-%M-%S).log"

echo "--- System Metrics Report - $(date) ---" >> $LOG_FILE
echo "" >> $LOG_FILE

echo "--- CPU and Memory (top snapshot) ---" >> $LOG_FILE
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

apache_backup.sh
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

nginx_backup.sh
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

Cron Entries (root crontab)
# System Monitoring Log (hourly)
0 * * * * /path/to/monitor_log.sh

# Apache Backup (every Tuesday at 12:00 AM)
0 0 * * 2 /path/to/apache_backup.sh

# Nginx Backup (every Tuesday at 12:00 AM)
0 0 * * 2 /path/to/nginx_backup.sh

(Remember to replace /path/to/ with the actual directory where you save the scripts.)

Usage
To set up your environment based on this project:

Clone the Repository:

git clone https://github.com/your-username/devops-environment-setup.git
cd devops-environment-setup

Place Scripts: Copy monitor_log.sh, apache_backup.sh, and nginx_backup.sh to a suitable directory on your server (e.g., /usr/local/bin/).

Make Scripts Executable:

sudo chmod +x /usr/local/bin/monitor_log.sh
sudo chmod +x /usr/local/bin/apache_backup.sh
sudo chmod +x /usr/local/bin/nginx_backup.sh

Install htop:

sudo apt update && sudo apt install htop -y # For Debian/Ubuntu
# OR
sudo yum install htop -y # For CentOS/RHEL

Configure Cron Jobs: Edit the root crontab (sudo crontab -e) and add the entries provided in the Implementation Details section, adjusting paths as necessary.

Create Users and Directories: Manually execute the useradd, passwd, mkdir, chown, and chmod commands as outlined in Task 2.

Configure PAM for Password Policy: Edit /etc/pam.d/common-password (or /etc/pam.d/system-auth) and add the pam_pwquality.so line as described in Task 2.

# Deliverables
Documentation: This README file and the detailed report (if provided separately).

Scripts: monitor_log.sh, apache_backup.sh, nginx_backup.sh.

Configuration Snippets: Cron job entries, PAM configuration details.

Logs (simulated): Examples of system metric logs (/var/log/system_metrics/) and backup verification logs (/var/log/apache_backup.log, /var/log/nginx_backup.log).

Backup Files (simulated): Examples of compressed backup archives in /backups/.

# Challenges and Learnings
Interactive vs. Scriptable Monitoring: htop is great for interactive use, but for automated logging, top -bn1 or similar non-interactive tools are necessary.

PAM Configuration Nuances: Password complexity enforcement is powerful but requires precise configuration of PAM modules, which can vary slightly between Linux distributions.

Permissions Management: Ensuring scripts and cron jobs have the necessary permissions to access and modify system files (especially web server configurations) is critical and often requires root privileges.

Path Consistency: Being mindful of different default paths for applications (e.g., Apache on Debian vs. Red Hat) is important for writing portable scripts.

Backup Integrity: Simply creating a backup isn't enough; verifying its integrity is crucial for reliable disaster recovery.

# Future Enhancements
Centralized Monitoring Stack: Integrate Prometheus and Grafana for more advanced metrics collection, dashboards, and alerting.

Configuration Management: Use Ansible, Puppet, or Chef to automate the entire setup process, ensuring idempotence and scalability.

Offsite Backups: Implement offsite storage for backups (e.g., S3, Google Cloud Storage) for enhanced disaster recovery.

Backup Retention Policy: Implement a script to automatically prune old backups to manage storage space.

User Management Automation: Integrate with an LDAP or Active Directory for centralized user authentication and authorization.
