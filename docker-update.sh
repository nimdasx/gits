#!/bin/bash

# Cek parameter
if [ "$1" != "exekusi" ]; then
    SESSION="docker-update"
    tmux new-session -d -s $SESSION "$0 exekusi"
    tmux attach -t $SESSION
    exit 0
fi

# Ambil docker compose yang running DAN menggunakan docker-compose.yml
docker compose ls --format json | jq -r '
.[] 
| select(.Status | test("running"))
| .ConfigFiles
' | while read config_files; do

    # ConfigFiles bisa berisi banyak file (dipisahkan koma)
    IFS=',' read -ra FILES <<< "$config_files"

    for compose_file in "${FILES[@]}"; do
        compose_file=$(echo "$compose_file" | xargs) # trim spasi

        # HANYA proses docker-compose.yml
        if [ "$(basename "$compose_file")" = "docker-compose.yml" ]; then
            dir=$(dirname "$compose_file")

            echo "=============================="
            echo "Processing $dir"
            cd "$dir" || { echo "Gagal masuk ke $dir"; continue; }

            echo "Pulling images..."
            docker compose pull

            echo "down..."
            docker compose down

            echo "Starting containers..."
            docker compose up -d

            echo "Done with $dir"

            #sleep 2

        fi
    done
done