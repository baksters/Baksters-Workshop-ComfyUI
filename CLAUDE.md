# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker-based deployment for AI image generation and training tools, focused on:
- ComfyUI - Node-based image generation workflow tool (Port 3021)
- Kohya_ss - Training UI for LoRA and other model fine-tuning (Port 3011)

The project provides a containerized environment with CUDA support for running these tools on GPU-enabled systems.

## Key Commands

### Building and Deployment
```bash
# Build Docker image with custom registry/user/release
REGISTRY=docker.io REGISTRY_USER=myuser RELEASE=1.0.0 docker buildx bake -f docker-bake.hcl --push

# Run with docker-compose
docker-compose up -d

# Run with docker directly
docker run -d --gpus all -v /workspace -p 3020:3021 -p 3010:3011 ashleykza/baksters-workshop:latest
```

### Application Management
```bash
# Start individual services (inside container)
/start_comfyui.sh     # Starts ComfyUI on port 3021
/start_kohya.sh       # Starts Kohya_ss on port 3011
/start_tensorboard.sh # Starts Tensorboard on port 6066

# View application logs
tail -f /workspace/logs/comfyui.log
tail -f /workspace/logs/kohya_ss.log
tail -f /workspace/logs/tensorboard.log
```

### Version Updates
When updating application versions, modify these files:
- `docker-bake.hcl`: Update VERSION variables (COMFYUI_VERSION, KOHYA_VERSION)
- Commit message format: "Bump [AppName] to version [version]"

## Architecture

### Directory Structure
- `/build/` - Installation scripts for each application during Docker build
- `/scripts/` - Runtime startup and management scripts
- `/app-manager/` - Application manager configuration
- `/comfyui/` - ComfyUI-specific configurations
- `/kohya_ss/` - Kohya_ss-specific configurations
- `/nginx/` - NGINX proxy configuration

### Build Process
The Dockerfile uses a multi-stage build:
1. Base image with CUDA and Python setup
2. Kohya_ss installation stage
3. ComfyUI installation stage  
4. Tensorboard installation stage
5. Final image assembly with scripts and configs

### Virtual Environments
Each application runs in its own Python virtual environment:
- ComfyUI: `/workspace/ComfyUI/venv`
- Kohya_ss: `/workspace/venvs/kohya_ss`

### Model Storage
Models are centrally stored in `/workspace/models/`:
- `/workspace/models/checkpoints` - Base models
- `/workspace/models/vae` - VAE models
- `/workspace/models/loras` - LoRA models
- `/workspace/models/embeddings` - Text embeddings
- `/workspace/models/controlnet` - ControlNet models
- `/workspace/models/upscale_models` - Upscaling models

ComfyUI is configured via `extra_model_paths.yaml` to use these directories.

## Important Considerations

- All applications log to `/workspace/logs/` for debugging
- The container expects GPU support via NVIDIA Docker runtime
- Port mappings are configured in docker-compose.yml
- Application startup can be disabled with `DISABLE_AUTOLAUNCH` environment variable
- Tensorboard can be enabled/disabled with `ENABLE_TENSORBOARD` environment variable