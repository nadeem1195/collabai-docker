#!/bin/bash

# Take a backup before updating
./backup-mongodb.sh

# Pull the latest images
docker pull nadeemagadi/collabai-frontend:latest
docker pull nadeemagadi/collabai-backend:latest

# Stop only frontend and backend services
docker compose -f docker-compose.prod.yml stop frontend backend

# Remove only frontend and backend containers
docker compose -f docker-compose.prod.yml rm -f frontend backend

# Start the services again (this will use the new images)
docker compose -f docker-compose.prod.yml up -d frontend backend

echo "Update completed. MongoDB data is preserved."
echo "You can verify the services are running with: docker compose -f docker-compose.prod.yml ps" 