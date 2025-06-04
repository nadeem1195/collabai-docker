#!/bin/bash

# Create backup directory if it doesn't exist
BACKUP_DIR="./mongodb_backups"
mkdir -p $BACKUP_DIR

# Get current timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup
docker compose -f docker-compose.prod.yml exec -T mongodb mongodump \
    --authenticationDatabase admin \
    -u admin \
    -p x0G319JFlnWNgs \
    --out=/tmp/mongodb_backup_$TIMESTAMP

# Copy backup from container to host
docker compose -f docker-compose.prod.yml cp mongodb:/tmp/mongodb_backup_$TIMESTAMP $BACKUP_DIR/

# Remove backup from container
docker compose -f docker-compose.prod.yml exec -T mongodb rm -rf /tmp/mongodb_backup_$TIMESTAMP

# Compress the backup
tar -czf $BACKUP_DIR/mongodb_backup_$TIMESTAMP.tar.gz -C $BACKUP_DIR mongodb_backup_$TIMESTAMP

# Remove the uncompressed backup
rm -rf $BACKUP_DIR/mongodb_backup_$TIMESTAMP

# Keep only the last 7 backups
ls -t $BACKUP_DIR/mongodb_backup_*.tar.gz | tail -n +8 | xargs -r rm

echo "Backup completed: mongodb_backup_$TIMESTAMP.tar.gz"