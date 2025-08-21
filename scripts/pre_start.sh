#!/usr/bin/env bash

export PYTHONUNBUFFERED=1
export APP="baksters-workshop"

TEMPLATE_NAME="${APP}"
TEMPLATE_VERSION_FILE="/workspace/${APP}/template.json"

echo "TEMPLATE NAME: ${TEMPLATE_NAME}"
echo "TEMPLATE VERSION: ${TEMPLATE_VERSION}"

if [[ -e ${TEMPLATE_VERSION_FILE} ]]; then
    EXISTING_TEMPLATE_NAME=$(jq -r '.template_name // empty' "$TEMPLATE_VERSION_FILE")

    if [[ -n "${EXISTING_TEMPLATE_NAME}" ]]; then
        if [[ "${EXISTING_TEMPLATE_NAME}" != "${TEMPLATE_NAME}" ]]; then
            EXISTING_VERSION="0.0.0"
        else
            EXISTING_VERSION=$(jq -r '.template_version // empty' "$TEMPLATE_VERSION_FILE")
        fi
    else
        EXISTING_VERSION="0.0.0"
    fi
else
    EXISTING_VERSION="0.0.0"
fi

save_template_json() {
    cat << EOF > ${TEMPLATE_VERSION_FILE}
{
    "template_name": "${TEMPLATE_NAME}",
    "template_version": "${TEMPLATE_VERSION}"
}
EOF
}

sync_directory() {
    local src_dir="$1"
    local dst_dir="$2"
    local use_compression=${3:-false}

    echo "SYNC: Syncing from ${src_dir} to ${dst_dir}, please wait (this can take a few minutes)..."

    # Ensure destination directory exists
    mkdir -p "${dst_dir}"

    # Check whether /workspace is fuse, overlay, or xfs
    local workspace_fs=$(df -T /workspace | awk 'NR==2 {print $2}')
    echo "SYNC: File system type: ${workspace_fs}"

    # Rsync options
    rsync_opts="-av --info=progress2"

    # Add compression option if requested
    if [[ "${use_compression}" == true ]]; then
        rsync_opts="${rsync_opts} -z"
    fi

    # Perform the sync
    rsync ${rsync_opts} "${src_dir}/" "${dst_dir}/"
}

# Check if we need to sync
if [[ "${DISABLE_SYNC}" == "1" ]]; then
    echo "Syncing disabled"
else
    echo "Syncing ComfyUI and Kohya_ss to workspace..."
    
    # Sync ComfyUI if not exists
    if [[ ! -d "/workspace/ComfyUI" ]]; then
        sync_directory "/ComfyUI" "/workspace/ComfyUI"
    fi
    
    # Sync Kohya_ss if not exists
    if [[ ! -d "/workspace/kohya_ss" ]]; then
        sync_directory "/kohya_ss" "/workspace/kohya_ss"
    fi
fi

# Create logs directory
mkdir -p /workspace/logs

# Create models directories for ComfyUI
mkdir -p /workspace/models/checkpoints
mkdir -p /workspace/models/vae
mkdir -p /workspace/models/loras
mkdir -p /workspace/models/embeddings
mkdir -p /workspace/models/hypernetworks
mkdir -p /workspace/models/controlnet
mkdir -p /workspace/models/upscale_models

echo "Starting Nginx"
nginx -c /etc/nginx/nginx.conf

if [[ "${DISABLE_AUTOLAUNCH}" != "1" ]]; then
    echo "Starting ComfyUI..."
    nohup /start_comfyui.sh > /workspace/logs/comfyui.log 2>&1 &
    
    echo "Starting Kohya_ss..."
    nohup /start_kohya.sh > /workspace/logs/kohya_ss.log 2>&1 &
    
    if [[ "${ENABLE_TENSORBOARD}" == "1" ]]; then
        echo "Starting Tensorboard..."
        nohup /start_tensorboard.sh > /workspace/logs/tensorboard.log 2>&1 &
    fi
else
    echo "Auto-launch disabled"
fi

# Save template information
save_template_json

echo "Container is ready!"