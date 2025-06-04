#!/bin/bash

# Exit on any error
set -e

echo "Starting production setup..."

# Create project directory
echo "Creating project directory..."
mkdir -p collabai-prod
cd collabai-prod

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p server mongodb_backups

# Copy required files
echo "Copying required files..."
# Note: These files should be in the same directory as this script
cp ../docker-compose.prod.yml .
cp ../mongo-init.js .
cp ../server/.env.prod server/
cp ../backup-mongodb.sh .
cp ../setup-backup-cron.sh .
cp ../update-app.sh .

# Make scripts executable
echo "Setting up script permissions..."
chmod +x backup-mongodb.sh setup-backup-cron.sh

# Set up daily backups
echo "Setting up daily backups..."
./setup-backup-cron.sh

# Start the services
echo "Starting services..."
docker compose -f docker-compose.prod.yml up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Verify services are running
echo "Verifying services..."
docker compose -f docker-compose.prod.yml ps

# Print access information
echo "
===========================================
Production Setup Complete!
===========================================

Access Information:
- Frontend: http://your-server-ip:4000
- Backend API: http://your-server-ip:8002
- MongoDB: mongodb://admin:x0G319JFlnWNgs@localhost:27017/admin

Backup Information:
- Backups are stored in: ./mongodb_backups
- Daily backups run at 2 AM
- Last 7 backups are retained
- Backup logs: ./backup.log

Important Notes:
1. Make sure ports 4000, 8002, and 27017 are open on your firewall
2. Update the environment variables in server/.env.prod with production values
3. Monitor the backup.log file for backup status
4. Use './backup-mongodb.sh' for manual backups
5. Use 'docker compose -f docker-compose.prod.yml logs' to check service logs

To update the application:
./update-app.sh

To check service status:
docker compose -f docker-compose.prod.yml ps

To view logs:
docker compose -f docker-compose.prod.yml logs
"

# Verify MongoDB connection
echo "Verifying MongoDB connection..."
if docker compose -f docker-compose.prod.yml exec -T mongodb mongosh -u admin -p x0G319JFlnWNgs --authenticationDatabase admin --eval "db.runCommand({ ping: 1 })" > /dev/null 2>&1; then
    echo "MongoDB connection successful!"
else
    echo "Warning: MongoDB connection test failed. Please check the logs."
fi 