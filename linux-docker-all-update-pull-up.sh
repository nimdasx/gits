#!/bin/bash

# Ambil semua docker compose yang running
docker compose ls --format json | jq -r '.[] | select(.Status | test("running")) | .ConfigFiles' | while read compose_file; do
    dir=$(dirname "$compose_file")
    echo "=============================="
    echo "Processing $dir"
    cd "$dir" || { echo "Gagal masuk ke $dir"; continue; }

    # Pull image terbaru
    echo "Pulling images..."
    docker compose pull

    # Up container
    echo "Starting containers..."
    docker compose up -d

    echo "Done with $dir"
    echo "=============================="
done