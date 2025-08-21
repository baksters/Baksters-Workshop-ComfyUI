<div align="center">

# Bakster's Workshop - ComfyUI & Kohya_ss Docker Image

[![GitHub Repo](https://img.shields.io/badge/github-repo-green?logo=github)](https://github.com/ashleykleynhans/stable-diffusion-docker)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/ashleykza/baksters-workshop?logo=docker&label=dockerhub&color=blue)](https://hub.docker.com/repository/docker/ashleykza/baksters-workshop)

</div>

A streamlined Docker image for AI training and generation workflows, featuring ComfyUI and Kohya_ss.

## Features

* Ubuntu 22.04 LTS
* CUDA 12.4
* Python 3.10.12
* Torch 2.6.0
* xformers 0.0.29.post3
* [ComfyUI](https://github.com/comfyanonymous/ComfyUI) v0.3.51
* [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager)
* [Kohya_ss](https://github.com/bmaltais/kohya_ss) v25.2.1
* [Jupyter Lab](https://github.com/jupyterlab/jupyterlab)
* [Tensorboard](https://www.tensorflow.org/tensorboard)

## Quick Start

### Docker Compose (Recommended)

```bash
docker-compose up -d
```

### Manual Docker Run

```bash
docker run -d \
  --gpus all \
  -v /workspace:/workspace \
  -p 3010:3011 \
  -p 3020:3021 \
  -p 6006:6066 \
  -p 8888:8888 \
  -e JUPYTER_PASSWORD=Jup1t3R! \
  -e ENABLE_TENSORBOARD=1 \
  ashleykza/baksters-workshop:latest
```

## Ports

| Connect Port | Internal Port | Description     |
|--------------|---------------|-----------------|
| 3010         | 3011          | Kohya_ss        |
| 3020         | 3021          | ComfyUI         |
| 6006         | 6066          | Tensorboard     |
| 8888         | 8888          | Jupyter Lab     |

## Environment Variables

| Variable             | Description                                  | Default       |
|---------------------|----------------------------------------------|---------------|
| JUPYTER_LAB_PASSWORD| Set a password for Jupyter lab              | not set       |
| DISABLE_AUTOLAUNCH  | Disable apps from launching automatically   | (not set)     |
| DISABLE_SYNC        | Disable syncing to workspace                | (not set)     |
| ENABLE_TENSORBOARD  | Enable Tensorboard on port 6006             | enabled       |

## Model Storage

Models are stored in `/workspace/models/` with the following structure:
- `/workspace/models/checkpoints` - Model checkpoints
- `/workspace/models/vae` - VAE models
- `/workspace/models/loras` - LoRA models
- `/workspace/models/embeddings` - Embeddings
- `/workspace/models/controlnet` - ControlNet models
- `/workspace/models/upscale_models` - Upscaling models

## Logs

Application logs are available at:

| Application | Log file                     |
|-------------|------------------------------|
| ComfyUI     | /workspace/logs/comfyui.log  |
| Kohya_ss    | /workspace/logs/kohya_ss.log |

View logs with:
```bash
tail -f /workspace/logs/comfyui.log
tail -f /workspace/logs/kohya_ss.log
```

## Building the Docker Image

### Prerequisites
- Docker with buildx support
- At least 16GB of system RAM
- NVIDIA GPU with CUDA support

### Build Process

1. Clone the repository:
```bash
git clone https://github.com/your-repo/baksters-workshop.git
cd baksters-workshop
```

2. Log in to Docker Hub:
```bash
docker login
```

3. Build and push the image:
```bash
REGISTRY=docker.io REGISTRY_USER=yourusername RELEASE=1.0.0 \
  docker buildx bake -f docker-bake.hcl --push
```

## Running Locally

### Install NVIDIA CUDA Driver

- [Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
- [Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)

### Start the Container

Use either Docker Compose (recommended) or the manual Docker run command shown above.

## Contributing

Pull requests and issues on [GitHub](https://github.com/your-repo/baksters-workshop) are welcome. Bug fixes and new features are encouraged.

## License

This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE - see the LICENSE file for details.