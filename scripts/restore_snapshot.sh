#!/usr/bin/env bash

set -e

# Use a fixed path instead of searching
SNAPSHOT_FILE="/snapshot.json"

if [ ! -f "$SNAPSHOT_FILE" ]; then
    echo "runpod-worker-comfy: No snapshot file found at $SNAPSHOT_FILE. Exiting..."
    exit 0
fi

echo "runpod-worker-comfy: restoring snapshot: $SNAPSHOT_FILE"

comfy --workspace /ComfyUI node restore-snapshot /snapshot.json <<< "N"

echo "------------------------------------------------------------"
echo "runpod-worker-comfy: restored snapshot file: $SNAPSHOT_FILE"
echo "-----------------------------------------------------------"