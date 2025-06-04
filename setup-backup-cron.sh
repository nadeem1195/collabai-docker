#!/bin/bash

# Get the absolute path of the backup script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BACKUP_SCRIPT="$SCRIPT_DIR/backup-mongodb.sh"

# Make sure the backup script is executable
chmod +x "$BACKUP_SCRIPT"

# Create a temporary file for the crontab
TEMP_CRON=$(mktemp)

# Export the current crontab
crontab -l > "$TEMP_CRON" 2>/dev/null || echo "# MongoDB Backup Cron Jobs" > "$TEMP_CRON"

# Add the backup job to run daily at 2 AM
echo "0 2 * * * $BACKUP_SCRIPT >> $SCRIPT_DIR/backup.log 2>&1" >> "$TEMP_CRON"

# Install the new crontab
crontab "$TEMP_CRON"

# Remove the temporary file
rm "$TEMP_CRON"

echo "Daily backup cron job has been set up to run at 2 AM every day"
echo "Backup logs will be written to: $SCRIPT_DIR/backup.log" 