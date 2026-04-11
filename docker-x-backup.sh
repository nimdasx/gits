#!/bin/bash

# Script to backup a docker-compose project directory and its volumes.

# --- Prerequisite Check ---
if ! command -v rsync &> /dev/null; then
    echo "Error: 'rsync' is not installed. It is required for copying files with progress."
    echo "Please install it (e.g., 'sudo apt-get install rsync' or 'sudo yum install rsync') and try again."
    exit 1
fi

if ! command -v pv &> /dev/null; then
    echo "Error: 'pv' (Pipe Viewer) is not installed. It is required for progress bars."
    echo "Please install it (e.g., 'sudo apt-get install pv' or 'sudo yum install pv') and try again."
    exit 1
fi


# --- Validation ---
AUTO_STOP=0
SOURCE_DIR_ARG=""
DEST_DIR_ARG="./docker-backup"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -s|--stop-running) AUTO_STOP=1; shift ;;
        -d|--dest)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                DEST_DIR_ARG="$2"
                shift 2
            else
                echo "Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        -*)
            echo "Unknown option passed: $1"
            echo "Usage: $0 [-s|--stop-running] [-d|--dest <backup_destination>] <path_to_docker_compose_folder>"
            exit 1
            ;;
        *)
            if [ -z "$SOURCE_DIR_ARG" ]; then
                SOURCE_DIR_ARG="$1"
            else
                echo "Unknown parameter passed: $1"
                echo "Usage: $0 [-s|--stop-running] [-d|--dest <backup_destination>] <path_to_docker_compose_folder>"
                exit 1
            fi
            shift
            ;;
    esac
done

if [ -z "$SOURCE_DIR_ARG" ]; then
    echo "Usage: $0 [-s|--stop-running] [-d|--dest <backup_destination>] <path_to_docker_compose_folder>"
    exit 1
fi

SOURCE_DIR=$(realpath "$SOURCE_DIR_ARG")
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
sudo rsync -a --info=progress2 "$SOURCE_DIR/" "$PROJECT_STAGING_DIR/"


# --- Volume Backup ---
echo "Finding and backing up associated Docker volumes..."
# Go to project dir to correctly identify project-specific volumes
cd "$SOURCE_DIR"

# Check if docker-compose services are running
WAS_RUNNING=0
if [ -n "$(docker compose ps -q --filter "status=running")" ]; then
    if [ "$AUTO_STOP" -eq 1 ]; then
        echo "Docker Compose services are running. Automatically stopping them..."
        docker compose down
        WAS_RUNNING=1
    else
        echo "Error: Docker Compose services are currently running."
        echo "Please stop them manually, or run this script with '-s' or '--stop-running' to automatically stop and restart them."
        exit 1
    fi
fi

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

    # Convert space-separated string to array to count them
    read -ra VOLUME_ARRAY <<< "$VOLUMES"
    TOTAL_VOLUMES=${#VOLUME_ARRAY[@]}
    CURRENT_VOLUME=0

    for volume in "${VOLUME_ARRAY[@]}"; do
        ((CURRENT_VOLUME++))
        echo "Backing up volume '$volume' ($CURRENT_VOLUME of $TOTAL_VOLUMES)..."

        # Get the total size of the volume for pv
        VOLUME_SIZE_BYTES=$(docker run --rm -v "${volume}:/volume_data:ro" busybox du -sb /volume_data | awk '{print $1}')
        if [ -z "$VOLUME_SIZE_BYTES" ] || [ "$VOLUME_SIZE_BYTES" -eq 0 ]; then
             echo "Volume is empty or size could not be determined. Creating empty archive."
             # Create an empty tarball
             tar -czf "${VOLUMES_BACKUP_DIR}/${volume}.tar.gz" -T /dev/null
        else
            # Pipe tar output through pv to show progress
            docker run --rm \
                -v "${volume}:/volume_data:ro" \
                busybox tar -c -C /volume_data . | pv -s "$VOLUME_SIZE_BYTES" | gzip > "${VOLUMES_BACKUP_DIR}/${volume}.tar.gz"
        fi

        if [ ${PIPESTATUS[0]} -ne 0 ]; then
            echo "Warning: Failed to back up volume '$volume'. Skipping."
        fi
    done
fi

if [ "$WAS_RUNNING" -eq 1 ]; then
    echo "Restarting Docker Compose services..."
    docker compose up -d
else
    echo "Cleaning up containers..."
    docker compose down
fi

cd - > /dev/null


# --- Archiving ---
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILENAME="${PROJECT_NAME}-${TIMESTAMP}.tar.gz"
BACKUP_DEST_DIR="${DEST_DIR_ARG}"

mkdir -p "$BACKUP_DEST_DIR"

echo "Creating archive: ${BACKUP_DEST_DIR}/${BACKUP_FILENAME}"
# Get total size of the staging directory for pv
TOTAL_SIZE=$(sudo du -sb "$STAGING_DIR/$PROJECT_NAME" | awk '{print $1}')
sudo tar -cz -C "$STAGING_DIR" "$PROJECT_NAME" | pv -s "$TOTAL_SIZE" > "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}"


if [ $? -eq 0 ]; then
    echo "----------------------------------------"
    echo "Backup completed successfully!"
    echo "Archive created at: $(realpath "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}")"
    echo "----------------------------------------"
else
    echo "Error: Backup failed during archiving."
    exit 1
fi
