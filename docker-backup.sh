#!/bin/bash

# Script to backup a docker-compose project directory and its volumes.

# --- Validation ---
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_docker_compose_folder>"
    exit 1
fi

SOURCE_DIR=$(realpath "$1")
PROJECT_NAME=$(basename "$SOURCE_DIR")

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Directory '$SOURCE_DIR' not found."
    exit 1
fi

if [ ! -f "$SOURCE_DIR/docker-compose.yml" ]; then
    echo "Error: 'docker-compose.yml' not found in '$SOURCE_DIR'."
    exit 1
fi

echo "Starting backup for project: $PROJECT_NAME"

# --- Staging Area ---
# Create a temporary directory for staging the backup
STAGING_DIR=$(mktemp -d)
if [ ! -d "$STAGING_DIR" ]; then
    echo "Error: Could not create temporary staging directory."
    exit 1
fi
# Ensure cleanup on exit
trap 'echo "Cleaning up temporary files..."; sudo rm -rf "$STAGING_DIR"' EXIT

PROJECT_STAGING_DIR="$STAGING_DIR/$PROJECT_NAME"
mkdir -p "$PROJECT_STAGING_DIR"

echo "Copying project files to staging area..."
sudo cp -aR "$SOURCE_DIR/." "$PROJECT_STAGING_DIR/"

# --- Volume Backup ---
echo "Finding and backing up associated Docker volumes..."
# Go to project dir to correctly identify project-specific volumes
cd "$SOURCE_DIR"

echo "Ensuring containers and volumes are created (will not start them)..."
docker compose up --no-start
if [ $? -ne 0 ]; then
    echo "Error: 'docker compose up --no-start' failed. Cannot determine volumes."
    cd - > /dev/null
    exit 1
fi

# Get all unique volumes attached to the project's containers
VOLUMES=$(docker compose ps -qa | xargs docker inspect --format='{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}} {{end}}{{end}}' | sort -u | xargs)

if [ -z "$VOLUMES" ]; then
    echo "No attached volumes found to back up."
else
    VOLUMES_BACKUP_DIR="$PROJECT_STAGING_DIR/volumes_backup"
    mkdir -p "$VOLUMES_BACKUP_DIR"
    echo "Found volumes: $VOLUMES"
    for volume in $VOLUMES; do
        echo "Backing up volume '$volume' using a busybox container..."
        docker run --rm \
            -v "${volume}:/volume_data:ro" \
            -v "${VOLUMES_BACKUP_DIR}:/backup" \
            busybox tar -czf "/backup/${volume}.tar.gz" -C /volume_data .

        if [ $? -ne 0 ]; then
            echo "Warning: Failed to back up volume '$volume'. Skipping."
        fi
    done
fi
cd - > /dev/null


# --- Archiving ---
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILENAME="${PROJECT_NAME}-${TIMESTAMP}.tar.gz"
BACKUP_DEST_DIR="./${PROJECT_NAME}"
BACKUP_DEST_DIR="./docker-backup"

mkdir -p "$BACKUP_DEST_DIR"

echo "Creating archive: ${BACKUP_DEST_DIR}/${BACKUP_FILENAME}"
sudo tar -czf "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}" -C "$STAGING_DIR" "$PROJECT_NAME"

if [ $? -eq 0 ]; then
    echo "----------------------------------------"
    echo "Backup completed successfully!"
    echo "Archive created at: $(realpath "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}")"
    echo "----------------------------------------"
else
    echo "Error: Backup failed during archiving."
    exit 1
fi
