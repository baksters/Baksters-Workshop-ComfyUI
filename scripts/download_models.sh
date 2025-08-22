#!/usr/bin/env bash

# Create directories if they don't exist
echo "Creating model directories..."
mkdir -p /workspace/models/unet
mkdir -p /workspace/models/clip
mkdir -p /workspace/models/vae
mkdir -p /workspace/models/clip_vision
mkdir -p /workspace/models/style_models

# Download Flux Dev FP8 model
if [ ! -f "/workspace/models/unet/flux1-dev-fp8.safetensors" ]; then
    echo "Downloading Flux Dev FP8 model (17.2GB)... This may take a while."
    wget -q --show-progress --progress=bar:force:noscroll \
        --header="Authorization: Bearer ${HUGGINGFACE_ACCESS_TOKEN}" \
        -O /workspace/models/unet/flux1-dev-fp8.safetensors \
        https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8.safetensors
    echo "✓ Flux Dev FP8 model downloaded."
else
    echo "✓ Flux Dev FP8 model already exists, skipping download."
fi

# Download CLIP L model
if [ ! -f "/workspace/models/clip/clip_l.safetensors" ]; then
    echo "Downloading CLIP L model..."
    wget -q --show-progress --progress=bar:force:noscroll \
        -O /workspace/models/clip/clip_l.safetensors \
        https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
    echo "✓ CLIP L model downloaded."
else
    echo "✓ CLIP L model already exists, skipping download."
fi

# Download T5XXL FP8 model
if [ ! -f "/workspace/models/clip/t5xxl_fp8_e4m3fn.safetensors" ]; then
    echo "Downloading T5XXL FP8 model (4.9GB)... This may take a while."
    wget -q --show-progress --progress=bar:force:noscroll \
        -O /workspace/models/clip/t5xxl_fp8_e4m3fn.safetensors \
        https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors
    echo "✓ T5XXL FP8 model downloaded."
else
    echo "✓ T5XXL FP8 model already exists, skipping download."
fi

# Download VAE (ae.safetensors)
if [ ! -f "/workspace/models/vae/ae.safetensors" ]; then
    echo "Downloading Flux VAE (ae.safetensors)..."
    wget -q --show-progress --progress=bar:force:noscroll \
        --header="Authorization: Bearer ${HUGGINGFACE_ACCESS_TOKEN}" \
        -O /workspace/models/vae/ae.safetensors \
        https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors
    echo "✓ Flux VAE downloaded."
else
    echo "✓ Flux VAE already exists, skipping download."
fi

# Download CLIP Vision model
if [ ! -f "/workspace/models/clip_vision/sigclip_vision_patch14_384.safetensors" ]; then
    echo "Downloading SIGCLIP Vision model..."
    wget -q --show-progress --progress=bar:force:noscroll \
        --header="Authorization: Bearer ${HUGGINGFACE_ACCESS_TOKEN}" \
        -O /workspace/models/clip_vision/sigclip_vision_patch14_384.safetensors \
        https://huggingface.co/Comfy-Org/sigclip_vision_384/resolve/main/sigclip_vision_patch14_384.safetensors
    echo "✓ SIGCLIP Vision model downloaded."
else
    echo "✓ SIGCLIP Vision model already exists, skipping download."
fi

# Download Flux Redux Dev model
if [ ! -f "/workspace/models/style_models/flux1-redux-dev.safetensors" ]; then
    echo "Downloading Flux Redux Dev model..."
    wget -q --show-progress --progress=bar:force:noscroll \
        --header="Authorization: Bearer ${HUGGINGFACE_ACCESS_TOKEN}" \
        -O /workspace/models/style_models/flux1-redux-dev.safetensors \
        https://huggingface.co/black-forest-labs/FLUX.1-Redux-dev/resolve/main/flux1-redux-dev.safetensors
    echo "✓ Flux Redux Dev model downloaded."
else
    echo "✓ Flux Redux Dev model already exists, skipping download."
fi

echo ""
echo "Model download process completed!"
echo ""
echo "Model locations:"
echo "- Flux Dev FP8: /workspace/models/unet/flux1-dev-fp8.safetensors"
echo "- CLIP L: /workspace/models/clip/clip_l.safetensors"
echo "- T5XXL FP8: /workspace/models/clip/t5xxl_fp8_e4m3fn.safetensors"
echo "- VAE (AE): /workspace/models/vae/ae.safetensors"
echo "- SIGCLIP Vision: /workspace/models/clip_vision/sigclip_vision_patch14_384.safetensors"
echo "- Flux Redux Dev: /workspace/models/style_models/flux1-redux-dev.safetensors"


