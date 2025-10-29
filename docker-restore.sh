#!/bin/bash

# Script to restore a docker-compose project from a backup archive.

# --- Validation ---
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_archive.tar.gz> <target_restore_directory>"
    exit 1
fi

ARCHIVE_FILE=$(realpath "$1")
TARGET_DIR=$(realpath "$2")

if [ ! -f "$ARCHIVE_FILE" ]; then
    echo "Error: Archive file '$ARCHIVE_FILE' not found."
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' not found."
    exit 1
fi

echo "Starting restore from: $ARCHIVE_FILE"

# --- Archive Validation ---
echo "Validating archive..."
# Get the top-level directory name(s) from the archive by listing all contents,
# cutting the path at the first '/', and finding the unique names.
ROOT_DIRS=$(tar -tf "$ARCHIVE_FILE" | cut -d/ -f1 | uniq)
NUM_ROOT_DIRS=$(echo "$ROOT_DIRS" | wc -l)
ROOT_FOLDER=$(echo "$ROOT_DIRS" | head -n 1) # Get the folder name

if [ "$NUM_ROOT_DIRS" -ne 1 ]; then
    echo "Error: Archive is not valid. It should contain exactly one root folder."
    echo "Found root items:"
    echo "$ROOT_DIRS"
    exit 1
fi
echo "Archive contains a single root folder: $ROOT_FOLDER"

# --- Target Directory Validation ---
RESTORE_PATH="$TARGET_DIR/$ROOT_FOLDER"
if [ -e "$RESTORE_PATH" ]; then
    echo "Error: A file or directory already exists at the target restore path: $RESTORE_PATH"
    echo "Please remove it or choose a different target directory."
    exit 1
fi

# --- Extraction ---
EXTRACT_DIR=$(mktemp -d)
trap 'echo "Cleaning up temporary files..."; sudo rm -rf "$EXTRACT_DIR"' EXIT

echo "Extracting archive to a temporary location..."
sudo tar -xzf "$ARCHIVE_FILE" -C "$EXTRACT_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract archive."
    exit 1
fi

EXTRACTED_PROJECT_DIR="$EXTRACT_DIR/$ROOT_FOLDER"
VOLUMES_BACKUP_DIR="$EXTRACTED_PROJECT_DIR/volumes_backup"

# --- File & Volume Restoration ---
echo "Moving project files to: $RESTORE_PATH"
sudo mv "$EXTRACTED_PROJECT_DIR" "$TARGET_DIR/"

# Define the path to the volume backups inside the newly restored project directory
VOLUMES_BACKUP_DIR="$RESTORE_PATH/volumes_backup"

if [ -d "$VOLUMES_BACKUP_DIR" ]; then
    echo "Restoring Docker volumes..."
    
    # Check if there are any volume archives to restore
    if [ -z "$(ls -A "$VOLUMES_BACKUP_DIR"/*.tar.gz 2>/dev/null)" ]; then
        echo "No volume archives (.tar.gz) found in the backup."
    else
        echo "Letting docker-compose create empty volumes with correct labels..."
        cd "$RESTORE_PATH"
        docker compose up --no-start
        if [ $? -ne 0 ]; then
            echo "Error: 'docker compose up --no-start' failed. Cannot create volumes correctly."
            cd - > /dev/null
            exit 1
        fi
        cd - > /dev/null

        for volume_archive in "$VOLUMES_BACKUP_DIR"/*.tar.gz; do
            volume_name=$(basename "$volume_archive" .tar.gz)
            
            # Verify that docker-compose actually created the volume
            if ! docker volume inspect "$volume_name" >/dev/null 2>&1; then
                echo "Warning: Volume '$volume_name' was not created by docker-compose. Skipping restore for this volume."
                continue
            fi

            echo "Populating volume '$volume_name' using a busybox container..."
            # We need the absolute path to the backup dir for the docker volume mount
            ABS_VOLUMES_BACKUP_DIR=$(realpath "$VOLUMES_BACKUP_DIR")
            docker run --rm \
                -v "${volume_name}:/volume_data" \
                -v "${ABS_VOLUMES_BACKUP_DIR}:/backup:ro" \
                busybox sh -c "tar -xzf /backup/$(basename "$volume_archive") -C /volume_data"

            if [ $? -ne 0 ]; then
                echo "Warning: Failed to restore data to volume '$volume_name'."
            fi
        done
    fi
    echo "Volume restoration complete."
    
    echo "Cleaning up volume backup data from project folder..."
    sudo rm -rf "$VOLUMES_BACKUP_DIR"
else
    echo "No volume backup data found in the archive."
fi

echo "----------------------------------------"
echo "Restore completed successfully!"
echo "Project restored at: $RESTORE_PATH"
echo "You can now navigate to the directory and start your containers, e.g., 'docker compose up -d'"
echo "----------------------------------------"
