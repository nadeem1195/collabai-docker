# Production Deployment Guide

## Prerequisites
- Docker and Docker Compose installed on the server
- Git installed on the server

## Initial Deployment Steps

1. Create a new directory for the project:
```bash
mkdir collabai-prod
cd collabai-prod
```

2. Copy the following files to the server:
   - `docker-compose.prod.yml`
   - `mongo-init.js`
   - `server/.env.prod`
   - `backup-mongodb.sh`
   - `update-app.sh`

3. Make the scripts executable:
```bash
chmod +x backup-mongodb.sh update-app.sh
```

4. Create the necessary directories:
```bash
mkdir -p server
```

5. Start the services:
```bash
docker compose -f docker-compose.prod.yml up -d
```

6. Verify the services are running:
```bash
docker compose -f docker-compose.prod.yml ps
```

## Accessing the Application
- Frontend: http://your-server-ip:4000
- Backend API: http://your-server-ip:8002
- MongoDB: mongodb://admin:x0G319JFlnWNgs@localhost:27017/admin

## Updating the Application

### Automatic Update
To update only the frontend and backend while preserving MongoDB data:
```bash
./update-app.sh
```
This script will:
1. Take a backup of MongoDB
2. Pull the latest images
3. Update only frontend and backend services
4. Preserve all MongoDB data

### Manual Update Steps
If you prefer to update manually:
1. Take a backup first:
```bash
./backup-mongodb.sh
```

2. Pull new images:
```bash
docker pull nadeemagadi/collabai-frontend:latest
docker pull nadeemagadi/collabai-backend:latest
```

3. Update services:
```bash
docker compose -f docker-compose.prod.yml up -d frontend backend
```

## Backup and Restore

### Automatic Backup
The system automatically creates backups when updating. You can also create a backup manually:
```bash
./backup-mongodb.sh
```
Backups are stored in `./mongodb_backups` directory and the system keeps the last 7 backups.

### Setting up Daily Backups
To set up automatic daily backups:
```bash
chmod +x setup-backup-cron.sh
./setup-backup-cron.sh
```
This will:
1. Set up a cron job to run backups daily at 2 AM
2. Store backup logs in `backup.log`
3. Keep only the last 7 backups

### Restore from Backup
To restore from a backup:
1. Extract the backup:
```bash
tar -xzf mongodb_backups/mongodb_backup_TIMESTAMP.tar.gz
```

2. Restore the backup:
```bash
docker compose -f docker-compose.prod.yml exec -T mongodb mongorestore \
    --authenticationDatabase admin \
    -u admin \
    -p x0G319JFlnWNgs \
    /tmp/mongodb_backup_TIMESTAMP
```

## Important Notes
- Make sure ports 4000, 8002, and 27017 are open on your server's firewall
- The MongoDB data is persisted in a Docker volume
- All services are configured to restart automatically unless stopped manually
- Make sure to update the environment variables in `server/.env.prod` with production values
- Always take a backup before updating the application
- The update process only affects frontend and backend services, MongoDB data is preserved

## Troubleshooting
- Check logs: `docker compose -f docker-compose.prod.yml logs`
- Check specific service logs: `docker compose -f docker-compose.prod.yml logs [service-name]`
- Restart services: `docker compose -f docker-compose.prod.yml restart`
- If MongoDB needs to be restarted: `docker compose -f docker-compose.prod.yml restart mongodb`
- Verify MongoDB data: `docker compose -f docker-compose.prod.yml exec mongodb mongosh -u admin -p x0G319JFlnWNgs --authenticationDatabase admin` 